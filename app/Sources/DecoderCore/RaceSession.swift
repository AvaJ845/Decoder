import Foundation

/// The pure, testable gameplay/session engine for a Chunk Racer race — extracted from
/// the UI layer (`GameModel`) so the no-shame loop rules can be unit-tested without a
/// SwiftUI host or a simulator.
///
/// It owns the session state machine and nothing else: no I/O (persistence, event files),
/// no UI (colors, copy, `@Published`), no timing (the feedback pause lives in `GameModel`).
///
/// The rules it encodes are the product non-negotiables (decoder-fellow-direction.md):
/// - Progress advances **only** by clearing an item (a correct answer). A miss never costs
///   progress — the item stays uncleared and returns later (D3, no lose-state).
/// - The just-answered item is deferred from the *very next* pick, so a miss re-serves
///   *later*, not as an instant re-drill.
/// - The session completes only when every item is cleared.
public final class RaceSession {
    public let pack: ContentPack
    private let engine: AdaptiveEngine

    public private(set) var learner: LearnerProfile
    public private(set) var momentum: ForgivingMomentum
    public private(set) var cleared: Set<String> = []
    private var lastAnswered: String?
    public private(set) var events: [LearningEvent] = []

    /// The item currently presented, or nil when the race is complete.
    public private(set) var current: Item?
    /// Shuffled answer options for `current` (correct word + distractor words).
    public private(set) var choices: [String] = []

    public var total: Int { pack.items.count }
    public var solved: Int { cleared.count }
    public var progress: Double { total == 0 ? 0 : min(1, Double(solved) / Double(total)) }
    public var isComplete: Bool { current == nil }
    /// Summary computed from the session's event stream (true to actual performance).
    public var summary: SessionSummary { SessionSummary(events: events) }

    public struct AnswerResult: Equatable {
        public let item: Item
        public let isCorrect: Bool
        public let event: LearningEvent
    }

    public init(pack: ContentPack, engine: AdaptiveEngine = SimpleAdaptiveEngine(), learner: LearnerProfile) {
        self.pack = pack
        self.engine = engine
        self.learner = learner
        self.momentum = learner.momentum
        advance()
    }

    /// Advance to the next uncleared item, deferring the just-answered one so a miss
    /// doesn't re-serve back-to-back. Falls back to allowing it if it's the only item
    /// left. Sets `current` to nil (complete) when nothing uncleared remains.
    public func advance() {
        var exclude = cleared
        if let last = lastAnswered { exclude.insert(last) }
        current = engine.nextItem(from: pack, excluding: exclude, profile: learner)
            ?? engine.nextItem(from: pack, excluding: cleared, profile: learner)
        choices = current.map { ([$0.payload.correctWord] + $0.payload.distractorWords).shuffled() } ?? []
    }

    /// Record an answer for the current item: update mastery, momentum, the cleared set,
    /// and the event log. Does **not** advance — the caller controls the feedback pause,
    /// then calls `advance()`. Returns nil if there is no current item.
    @discardableResult
    public func answer(_ word: String, promptShownAt: Date?, now: Date = Date()) -> AnswerResult? {
        guard let item = current else { return nil }
        let isCorrect = word.lowercased() == item.payload.correctWord.lowercased()
        let latencyMs = promptShownAt.map { max(0, Int(now.timeIntervalSince($0) * 1000)) } ?? 0
        let event = LearningEvent(learnerId: learner.id, appId: pack.appId,
                                  itemId: item.itemId, correct: isCorrect, latencyMs: latencyMs)
        events.append(event)

        var state = learner.skillStates[item.skillId] ?? SkillState(skillId: item.skillId)
        state.apply(correct: isCorrect)
        learner.skillStates[item.skillId] = state

        if isCorrect {
            momentum.hit()
            cleared.insert(item.itemId)   // progress advances ONLY on correct
        } else {
            momentum.miss()               // forgiving; item stays uncleared → returns later
        }
        lastAnswered = item.itemId
        learner.momentum = momentum
        return AnswerResult(item: item, isCorrect: isCorrect, event: event)
    }

    /// Apply accessibility preferences edited elsewhere (the settings sheet) back into the
    /// session's canonical learner, so mastery and prefs stay on one profile.
    public func updateAccessibility(_ prefs: AccessibilityPrefs) {
        learner.accessibility = prefs
    }
}
