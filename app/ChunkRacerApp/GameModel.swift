import SwiftUI
import DecoderCore

/// Chunk Racer core loop (Fellow decisions D2–D5): the target chunk is the prompt;
/// tap the streaming word that contains it. The "race" is **progress**, never a timer —
/// the racer advances on correct answers, so there is no lose-state (D3). Correct →
/// one brief focal celebrate (D5); miss → gentle re-serve, no shame. Every motion has
/// a Reduce-Motion equivalent that loses no information (D4).
///
/// Sprint update: now uses the persisted learner profile, the adaptive engine, and a
/// forgiving momentum meter so mastery and progress survive relaunch.
@MainActor
final class GameModel: ObservableObject {
    enum ArloState { case idle, celebrate, encourage }
    enum Feedback: Equatable { case correct(String); case reserve(String) }

    private let pack: ContentPack
    private let profileStore: ProfileStore
    private let engine: AdaptiveEngine
    private let events: EventStore
    @Published var learner: LearnerProfile
    @Published var fontManager: FontManager

    @Published var current: Item?
    @Published var choices: [String] = []
    @Published var feedback: Feedback?
    @Published var solved = 0
    @Published var burstToken = 0
    @Published var arlo: ArloState = .idle
    @Published var arloLine = "Find the chunk!"
    @Published var momentum: ForgivingMomentum

    private var promptTime: Date?
    /// Items answered correctly this session — cleared so the race can actually finish.
    private var cleared: Set<String> = []
    /// The most recent item, held out of the very next pick so a miss isn't re-served
    /// back-to-back (it still returns later — a gentle re-serve, not an instant drill).
    private var lastAnswered: String?
    /// Events for this session, kept in memory for the end-of-session summary (playtest §7).
    private var sessionEvents: [LearningEvent] = []
    @Published var sessionSummary: SessionSummary?

    var total: Int { pack.items.count }
    var progress: Double { total == 0 ? 0 : min(1, Double(solved) / Double(total)) }

    convenience init(pack: ContentPack) {
        self.init(pack: pack, profileStore: InMemoryProfileStore(),
                  engine: SimpleAdaptiveEngine(), events: nil)
    }

    init(pack: ContentPack,
         profileStore: ProfileStore = InMemoryProfileStore(),
         engine: AdaptiveEngine = SimpleAdaptiveEngine(),
         events: EventStore? = nil) {
        self.pack = pack
        self.profileStore = profileStore
        self.engine = engine

        // Load or create a default learner profile before touching self.
        let initialLearner = (try? profileStore.load(id: "demo")) ?? LearnerProfile(displayName: "Player")
        self.learner = initialLearner
        self.fontManager = FontManager(profile: initialLearner)
        self.momentum = initialLearner.momentum

        // Default to a file-backed event store so playtest sessions are reviewable.
        // Tests and previews can pass an explicit InMemoryEventStore.
        if let events = events {
            self.events = events
        } else {
            let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
                .appendingPathComponent("Decoder/events", isDirectory: true)
            if let dir = dir, !FileManager.default.fileExists(atPath: dir.path) {
                try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
            }
            let url = dir?.appendingPathComponent("\(initialLearner.id).jsonl") ?? URL(fileURLWithPath: "/tmp/events.jsonl")
            self.events = FileEventStore(url: url)
        }

        present()
    }

    private func present() {
        feedback = nil
        arlo = .idle
        // Exclude cleared items and (softly) the just-answered one, so a miss comes
        // back later rather than instantly. Fall back to allowing it if it's the only
        // uncleared item left.
        var exclude = cleared
        if let last = lastAnswered { exclude.insert(last) }
        current = engine.nextItem(from: pack, excluding: exclude, profile: learner)
            ?? engine.nextItem(from: pack, excluding: cleared, profile: learner)
        if let c = current {
            choices = ([c.payload.correctWord] + c.payload.distractorWords).shuffled()
            arloLine = "Find the chunk!"
            promptTime = Date()
            sessionSummary = nil
        } else {
            promptTime = nil   // nothing uncleared remains → the race is complete
            sessionSummary = SessionSummary(events: sessionEvents)
        }
    }

    func choose(_ word: String) {
        guard let item = current, feedback == nil else { return }
        let isCorrect = word.lowercased() == item.payload.correctWord.lowercased()
        let latencyMs = promptTime.map { Int(Date().timeIntervalSince($0) * 1000) } ?? 0
        let event = LearningEvent(learnerId: learner.id, appId: pack.appId,
                                  itemId: item.itemId, correct: isCorrect, latencyMs: latencyMs)
        try? events.append(event)
        sessionEvents.append(event)

        // Update mastery.
        if learner.skillStates[item.skillId] == nil {
            learner.skillStates[item.skillId] = SkillState(skillId: item.skillId)
        }
        learner.skillStates[item.skillId]?.apply(correct: isCorrect)

        if isCorrect {
            feedback = .correct(word)
            arlo = .celebrate
            arloLine = "Nice hit — you found \(item.payload.targetChunk)!"
            momentum.hit()
            cleared.insert(item.itemId)
            solved = cleared.count
            burstToken += 1
        } else {
            feedback = .reserve(word)
            arlo = .encourage
            arloLine = "Let's see that one again later"
            momentum.miss()   // forgiving; item stays uncleared → returns later
        }
        lastAnswered = item.itemId

        // Persist AFTER applying this answer's momentum, so nothing is lost off-by-one.
        learner.momentum = momentum
        try? profileStore.save(learner)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) { [weak self] in
            self?.present()
        }
    }

    /// Persist accessibility preference changes from the settings sheet.
    func savePreferences() {
        learner.momentum = momentum
        fontManager.profile = learner
        try? profileStore.save(learner)
    }
}
