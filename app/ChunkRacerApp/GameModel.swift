import SwiftUI
import DecoderCore

/// UI orchestration for a Chunk Racer race. The gameplay *rules* live in the testable
/// `RaceSession` (DecoderCore); this layer owns only what's inherently UI: `@Published`
/// state for SwiftUI, the feedback-pause timing, side-effecting persistence (event store +
/// profile), and user-facing copy. It mirrors the session's state into `@Published`
/// properties so the view stays declarative and its public surface is unchanged.
///
/// Loop rules (enforced in `RaceSession`): the target chunk is the prompt; a miss
/// re-serves warmly (no lose-state, D3); progress advances only on a correct answer; one
/// brief celebrate (D5). See decoder-fellow-direction.md for the bar.
@MainActor
final class GameModel: ObservableObject {
    enum ArloState { case idle, celebrate, encourage }
    enum Feedback: Equatable { case correct(String); case reserve(String) }

    private let session: RaceSession
    private let profileStore: ProfileStore
    private let events: EventStore

    @Published var fontManager: FontManager
    @Published var learner: LearnerProfile
    @Published var current: Item?
    @Published var choices: [String] = []
    @Published var feedback: Feedback?
    @Published var solved = 0
    @Published var momentum: ForgivingMomentum
    @Published var burstToken = 0
    @Published var arlo: ArloState = .idle
    @Published var arloLine = "Find the chunk!"
    @Published var sessionSummary: SessionSummary?

    private var promptTime: Date?

    var total: Int { session.total }
    var progress: Double { session.progress }   // re-renders when @Published `solved` changes

    convenience init(pack: ContentPack) {
        self.init(pack: pack, profileStore: InMemoryProfileStore(),
                  engine: SimpleAdaptiveEngine(), events: nil)
    }

    init(pack: ContentPack,
         profileStore: ProfileStore = InMemoryProfileStore(),
         engine: AdaptiveEngine = SimpleAdaptiveEngine(),
         events: EventStore? = nil) {
        self.profileStore = profileStore

        // Load or create a default learner, then hand it to the session (single source
        // of truth for mastery + momentum + prefs).
        let initialLearner = (try? profileStore.load(id: "demo")) ?? LearnerProfile(displayName: "Player")
        self.session = RaceSession(pack: pack, engine: engine, learner: initialLearner)

        // File-backed event store by default so playtest sessions are reviewable;
        // tests/previews can inject an InMemoryEventStore.
        self.events = events ?? GameModel.fileEventStore(for: initialLearner.id)

        self.learner = session.learner
        self.momentum = session.momentum
        self.fontManager = FontManager(profile: session.learner)

        syncPresentation()
    }

    // MARK: - Actions

    func choose(_ word: String) {
        // Short-circuit protects against double-answers during the feedback pause;
        // `session.answer` (a mutation) is only reached when feedback is clear.
        guard feedback == nil, let result = session.answer(word, promptShownAt: promptTime) else { return }

        try? events.append(result.event)          // persist evidence (I/O)
        learner = session.learner                 // mirror mastery/prefs
        momentum = session.momentum
        solved = session.solved                   // progress advances only on correct (in session)
        try? profileStore.save(session.learner)

        if result.isCorrect {
            feedback = .correct(word)
            arlo = .celebrate
            arloLine = "Nice hit — you found \(result.item.payload.targetChunk)!"
            burstToken += 1
        } else {
            feedback = .reserve(word)
            arlo = .encourage
            arloLine = "Let's see that one again later"
        }

        // Hold the answered item briefly (celebrate / gentle re-serve), then advance.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) { [weak self] in
            guard let self else { return }
            self.session.advance()
            self.syncPresentation()
        }
    }

    /// Persist accessibility changes from the settings sheet. The sheet edits
    /// `fontManager.profile`; push those prefs into the canonical session learner (this is
    /// the fix for edits being discarded), then mirror + save.
    func savePreferences() {
        session.updateAccessibility(fontManager.profile.accessibility)
        learner = session.learner
        fontManager.profile = session.learner
        try? profileStore.save(session.learner)
    }

    // MARK: - Presentation mirroring

    private func syncPresentation() {
        current = session.current
        choices = session.choices
        if session.isComplete {
            promptTime = nil
            sessionSummary = session.summary   // only when uncleared items are exhausted
        } else {
            feedback = nil
            arlo = .idle
            arloLine = "Find the chunk!"
            promptTime = Date()
            sessionSummary = nil
        }
    }

    // MARK: - Helpers

    private static func fileEventStore(for learnerId: String) -> EventStore {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent("Decoder/events", isDirectory: true)
        if let dir, !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        let url = dir?.appendingPathComponent("\(learnerId).jsonl") ?? URL(fileURLWithPath: "/tmp/events.jsonl")
        return FileEventStore(url: url)
    }
}
