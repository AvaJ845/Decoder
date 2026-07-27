import XCTest
@testable import DecoderCore

final class DecoderCoreTests: XCTestCase {

    private func packURL() throws -> URL {
        try XCTUnwrap(Bundle.module.url(forResource: "chunk-racer-basics-pack", withExtension: "json"))
    }
    private func graphURL() throws -> URL {
        try XCTUnwrap(Bundle.module.url(forResource: "skill-graph", withExtension: "json"))
    }

    // MARK: - Loading

    func testPackLoads() throws {
        let pack = try PackLoader.load(from: packURL())
        XCTAssertEqual(pack.appId, "chunk-racer")
        XCTAssertEqual(pack.locale, "en-US")
        XCTAssertEqual(pack.items.count, 12)
    }

    func testSkillGraphLoads() throws {
        let graph = try PackLoader.loadSkillGraph(from: graphURL())
        XCTAssertFalse(graph.nodes.isEmpty)
        XCTAssertTrue(graph.nodeIDs().contains("fluency-target-wpm"))
    }

    // MARK: - Validation (the shipping gate)

    func testShippedPackValidatesClean() throws {
        let pack = try PackLoader.load(from: packURL())
        let graph = try PackLoader.loadSkillGraph(from: graphURL())
        let issues = ContentPackValidator.validate(pack, skillNodeIDs: graph.nodeIDs())
        let errors = ContentPackValidator.errors(issues)
        XCTAssertTrue(errors.isEmpty, "unexpected validation errors: \(errors)")
    }

    func testPackSkillIdsResolveToGraph() throws {
        let pack = try PackLoader.load(from: packURL())
        let ids = try PackLoader.loadSkillGraph(from: graphURL()).nodeIDs()
        for s in pack.skillIds { XCTAssertTrue(ids.contains(s), "unresolved skillId: \(s)") }
    }

    /// The v2.1 mechanic invariant on the *shipped* content.
    func testMechanicInvariantHoldsForShippedPack() throws {
        let pack = try PackLoader.load(from: packURL())
        for item in pack.items {
            let chunk = item.payload.targetChunk.lowercased()
            XCTAssertTrue(item.payload.correctWord.lowercased().contains(chunk),
                          "\(item.itemId): correctWord must contain the chunk")
            for d in item.payload.distractorWords {
                XCTAssertFalse(d.lowercased().contains(chunk),
                               "\(item.itemId): distractor '\(d)' must NOT contain the chunk")
            }
        }
    }

    /// Regression for the cr-011 / cr-012 bug: the correct answer appearing among
    /// its own distractors must be caught as an error.
    func testValidatorCatchesAnswerInDistractors() {
        let bad = ContentPack(
            id: "x", version: "1.0.0", appId: "chunk-racer", locale: "en-US",
            skillIds: ["s"], alignment: nil,
            items: [Item(
                itemId: "bad", skillId: "s", difficultyBand: 1,
                payload: Payload(targetChunk: "swim", correctWord: "swimming",
                                 distractorWords: ["swam", "swim"], hint: nil),
                assetKeys: ["k"], cues: nil, minCanvas: nil, enhancedInput: nil)]
        )
        XCTAssertFalse(ContentPackValidator.errors(ContentPackValidator.validate(bad)).isEmpty)
    }

    func testValidatorCatchesUnknownSkillId() throws {
        let pack = try PackLoader.load(from: packURL())
        // Empty node set → every declared skill is unresolved.
        let errors = ContentPackValidator.errors(ContentPackValidator.validate(pack, skillNodeIDs: []))
        XCTAssertFalse(errors.isEmpty)
    }

    // MARK: - Adaptive engine seam

    func testAdaptivePicksWeakestSkillFirst() throws {
        let pack = try PackLoader.load(from: packURL())
        // Mastery high everywhere except CVC → engine should serve a CVC item.
        var profile = LearnerProfile(displayName: "Test")
        profile.skillStates = [
            "decode-cvc": SkillState(skillId: "decode-cvc", mastery: 0.1),
            "decode-digraphs-blends": SkillState(skillId: "decode-digraphs-blends", mastery: 0.9),
            "sight-words-short": SkillState(skillId: "sight-words-short", mastery: 0.9),
            "multisyllable-chunking": SkillState(skillId: "multisyllable-chunking", mastery: 0.9),
            "fluency-target-wpm": SkillState(skillId: "fluency-target-wpm", mastery: 0.9)
        ]
        let item = SimpleAdaptiveEngine().nextItem(from: pack, profile: profile)
        XCTAssertEqual(item?.skillId, "decode-cvc")
    }

    /// The session must be able to *complete*: excluding every item returns nil, and
    /// excluding all-but-one serves exactly that one. Guards the infinite-loop /
    /// progress-overflow regression.
    func testAdaptiveExcludesClearedAndCompletes() throws {
        let pack = try PackLoader.load(from: packURL())
        let profile = LearnerProfile(displayName: "Test")
        let engine = SimpleAdaptiveEngine()
        let allIds = Set(pack.items.map { $0.itemId })
        XCTAssertNil(engine.nextItem(from: pack, excluding: allIds, profile: profile))
        let onlyId = pack.items[3].itemId
        XCTAssertEqual(engine.nextItem(from: pack, excluding: allIds.subtracting([onlyId]), profile: profile)?.itemId, onlyId)
    }

    // MARK: - Event store (evidence pipeline)

    func testInMemoryEventRoundtrip() throws {
        let store = InMemoryEventStore()
        try store.append(LearningEvent(learnerId: "l1", appId: "chunk-racer",
                                       itemId: "cr-001", correct: true, latencyMs: 820))
        XCTAssertEqual(try store.all().count, 1)
    }

    func testFileEventStoreAppendsJSONLines() throws {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("events-\(UUID().uuidString).jsonl")
        defer { try? FileManager.default.removeItem(at: url) }
        let store = FileEventStore(url: url)
        try store.append(LearningEvent(learnerId: "l1", appId: "chunk-racer", itemId: "cr-001", correct: true, latencyMs: 500))
        try store.append(LearningEvent(learnerId: "l1", appId: "chunk-racer", itemId: "cr-002", correct: false, latencyMs: 1300))
        let all = try store.all()
        XCTAssertEqual(all.count, 2)
        XCTAssertEqual(all.last?.correct, false)
    }

    // MARK: - Asset-key resolver (§8.1)

    func testResolverPrefersVectorThenDensity() {
        let c = AssetKeyResolver.candidates(for: "racer_word_cat")
        XCTAssertEqual(c.first, "racer_word_cat.pdf")
        XCTAssertEqual(c[1], "racer_word_cat@3x.png")
    }

    func testResolverAppliesDarkAndReduceMotionSuffixes() {
        let c = AssetKeyResolver.candidates(for: "ui_momentum_protected", dark: true, reduceMotion: true)
        XCTAssertEqual(c.first, "ui_momentum_protected_reducemotion_dark.pdf")
    }

    // MARK: - Cue vocabulary

    func testCuesDecodeFromShippedPack() throws {
        let pack = try PackLoader.load(from: packURL())
        let firstCue = try XCTUnwrap(pack.items.first?.cues?.first)
        XCTAssertEqual(firstCue.type, .snap)
        XCTAssertEqual(firstCue.emphasis, .medium)
    }

    // MARK: - Learner profile + skill mastery

    func testSkillMasteryGrowsWithCorrectAnswers() {
        var state = SkillState(skillId: "decode-cvc")
        XCTAssertEqual(state.mastery, 0, accuracy: 0.001)
        state.apply(correct: true, targetMastery: 0.8)
        XCTAssertGreaterThan(state.mastery, 0)
        XCTAssertLessThanOrEqual(state.mastery, 1)
        XCTAssertNotNil(state.dueAt)
    }

    func testSkillMasteryShrinksWithIncorrectAnswers() {
        var state = SkillState(skillId: "decode-cvc", mastery: 0.5)
        state.apply(correct: false, targetMastery: 0.8)
        XCTAssertLessThan(state.mastery, 0.5)
    }

    func testProfileStateReturnsDefaultForUnknownSkill() {
        let profile = LearnerProfile(displayName: "Test")
        let state = profile.state(for: "new-skill")
        XCTAssertEqual(state.skillId, "new-skill")
        XCTAssertEqual(state.mastery, 0, accuracy: 0.001)
    }

    func testProfileStoreRoundTrip() throws {
        let store = InMemoryProfileStore()
        var profile = LearnerProfile(displayName: "Test")
        profile.skillStates["decode-cvc"] = SkillState(skillId: "decode-cvc", mastery: 0.4)
        try store.save(profile)
        let loaded = try XCTUnwrap(try store.load(id: profile.id))
        XCTAssertEqual(loaded.displayName, "Test")
        let mastery = try XCTUnwrap(loaded.skillStates["decode-cvc"]?.mastery)
        XCTAssertEqual(mastery, 0.4, accuracy: 0.001)
    }

    func testFileProfileStoreRoundTrip() throws {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("profiles-\(UUID().uuidString)")
        defer { try? FileManager.default.removeItem(at: dir) }
        let store = FileProfileStore(directory: dir)
        var profile = LearnerProfile(displayName: "Test")
        profile.skillStates["decode-cvc"] = SkillState(skillId: "decode-cvc", mastery: 0.6)
        try store.save(profile)
        let loaded = try XCTUnwrap(try store.load(id: profile.id))
        XCTAssertEqual(loaded.displayName, "Test")
        let mastery = try XCTUnwrap(loaded.skillStates["decode-cvc"]?.mastery)
        XCTAssertEqual(mastery, 0.6, accuracy: 0.001)
    }

    // MARK: - Forgiving momentum

    func testMomentumHitIncreasesStreak() {
        var m = ForgivingMomentum()
        m.hit()
        XCTAssertEqual(m.streak, 1)
    }

    func testMomentumMissWithoutProtectionDropsButNotToZero() {
        var m = ForgivingMomentum()
        m.hit(); m.hit(); m.hit()  // streak 3
        m.miss()
        XCTAssertEqual(m.streak, 1)  // drops by 2, floors at 0
    }

    func testMomentumProtectedMissPreservesStreak() {
        var m = ForgivingMomentum()
        for _ in 0..<5 { m.hit() }  // reach streak 5 → protected
        XCTAssertEqual(m.protectedCount, 2)
        m.miss()
        XCTAssertEqual(m.streak, 5)
        XCTAssertEqual(m.protectedCount, 1)
    }

    func testMomentumShieldForRestDay() {
        var m = ForgivingMomentum()
        m.hit(); m.hit(); m.hit()
        m.shieldForRestDay()
        XCTAssertEqual(m.protectedCount, 1)
        m.miss()
        XCTAssertEqual(m.streak, 3)
    }

    // MARK: - Session summary (playtest evidence)

    func testSessionSummaryAccuracyAndLatency() {
        let events = [
            LearningEvent(learnerId: "l1", appId: "chunk-racer", itemId: "a", correct: true, latencyMs: 800),
            LearningEvent(learnerId: "l1", appId: "chunk-racer", itemId: "b", correct: false, latencyMs: 1200),
            LearningEvent(learnerId: "l1", appId: "chunk-racer", itemId: "c", correct: true, latencyMs: 600)
        ]
        let summary = SessionSummary(events: events)
        XCTAssertEqual(summary.totalAnswers, 3)
        XCTAssertEqual(summary.correctAnswers, 2)
        XCTAssertEqual(summary.accuracy, 2.0 / 3.0, accuracy: 0.001)
        XCTAssertEqual(summary.medianLatencyMs, 800)
        XCTAssertEqual(summary.reservedItemIds, ["b"])
    }

    func testSessionSummaryFromEmptyEvents() {
        let summary = SessionSummary(events: [])
        XCTAssertEqual(summary.totalAnswers, 0)
        XCTAssertEqual(summary.accuracy, 0, accuracy: 0.001)
        XCTAssertEqual(summary.medianLatencyMs, 0)
        XCTAssertTrue(summary.reservedItemIds.isEmpty)
    }

    // MARK: - No-shame loop invariants
    //
    // These lock the non-negotiable loop behavior at the engine level so it can't
    // silently regress. The *full* loop policy (immediate re-serve deferral, progress
    // counting) lives in GameModel (the UI layer) and isn't reachable from `swift test`
    // — extracting it into a testable DecoderCore service is the recommended follow-up.

    /// Progress advances only by *clearing* an item, and a cleared item is never served
    /// again — while an unanswered/missed (uncleared) item stays available to return.
    /// This is the mechanical basis of "a miss re-serves warmly, it doesn't cost you."
    func testClearedItemsNeverReturnAndMissedItemsRemainAvailable() throws {
        let pack = try PackLoader.load(from: packURL())
        let profile = LearnerProfile(displayName: "Test")
        let engine = SimpleAdaptiveEngine()

        // Model a session where two items were answered correctly (cleared) and the
        // rest remain — including any that were missed (missed items are NOT cleared).
        let cleared = Set(pack.items.prefix(2).map(\.itemId))
        for _ in 0..<20 {
            guard let next = engine.nextItem(from: pack, excluding: cleared, profile: profile) else {
                return XCTFail("engine returned nil while uncleared items remain")
            }
            XCTAssertFalse(cleared.contains(next.itemId), "a cleared item must never be re-served")
        }
    }

    /// Momentum has no "lose" concept: no matter how many misses in a row, the streak
    /// floors at zero and there is no failure/lives state. Failure is invisible.
    func testMomentumHasNoLoseState() {
        var m = ForgivingMomentum()
        for _ in 0..<10 { m.miss() }          // ten misses in a row
        XCTAssertGreaterThanOrEqual(m.streak, 0, "streak must never go negative — there is no lose-state")
    }

    // MARK: - RaceSession (the loop policy, now unit-testable)

    private func makeSession() throws -> RaceSession {
        let pack = try PackLoader.load(from: packURL())
        return RaceSession(pack: pack, engine: SimpleAdaptiveEngine(), learner: LearnerProfile(displayName: "Test"))
    }

    func testSessionStartsWithAnItemAndChoices() throws {
        let s = try makeSession()
        XCTAssertNotNil(s.current)
        XCTAssertFalse(s.isComplete)
        XCTAssertTrue(s.choices.contains(s.current!.payload.correctWord))
        XCTAssertEqual(s.solved, 0)
    }

    func testProgressAdvancesOnlyOnCorrect() throws {
        let s = try makeSession()
        // A wrong answer must NOT advance progress and must NOT clear the item.
        let item = s.current!
        let wrong = item.payload.distractorWords.first!
        s.answer(wrong, promptShownAt: nil)
        XCTAssertEqual(s.solved, 0, "a miss never advances progress")
        XCTAssertFalse(s.cleared.contains(item.itemId), "a missed item stays uncleared → it returns later")
        // A correct answer advances by exactly one.
        s.advance()
        let next = s.current!
        s.answer(next.payload.correctWord, promptShownAt: nil)
        XCTAssertEqual(s.solved, 1)
        XCTAssertTrue(s.cleared.contains(next.itemId))
    }

    func testSessionCompletesWhenAllClearedAndSummaryReflectsIt() throws {
        let s = try makeSession()
        var guardCount = 0
        while !s.isComplete && guardCount < 1000 {
            s.answer(s.current!.payload.correctWord, promptShownAt: nil)
            s.advance()
            guardCount += 1
        }
        XCTAssertTrue(s.isComplete)
        XCTAssertEqual(s.solved, s.total)
        XCTAssertEqual(s.summary.correctAnswers, s.total)
        XCTAssertEqual(s.summary.accuracy, 1.0, accuracy: 0.001)
    }

    func testRepeatedMissesNeverCompleteOrLose() throws {
        let s = try makeSession()
        for _ in 0..<30 {
            let wrong = s.current!.payload.distractorWords.first!
            s.answer(wrong, promptShownAt: nil)
            s.advance()
            XCTAssertFalse(s.isComplete, "misses must never complete the race")
            XCTAssertNotNil(s.current, "there is always a next item — no dead end")
        }
        XCTAssertEqual(s.solved, 0, "no progress from misses, but also no lose-state")
        XCTAssertGreaterThanOrEqual(s.momentum.streak, 0)
    }

    func testJustAnsweredItemIsDeferredFromTheVeryNextPick() throws {
        let s = try makeSession()
        let answered = s.current!
        s.answer(answered.payload.distractorWords.first!, promptShownAt: nil)  // miss (stays uncleared)
        s.advance()
        // With items remaining, the just-answered item should not be re-served immediately.
        XCTAssertNotEqual(s.current?.itemId, answered.itemId,
                          "a missed item returns later, not back-to-back")
    }
}
