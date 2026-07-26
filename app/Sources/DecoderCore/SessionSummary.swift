import Foundation

/// A lightweight, kid-friendly summary of one race/session. Used for the parent/
/// teacher evidence view and for the playtest observer (playtest-1-plan §7).
/// All values are computed from the append-only event stream so they remain true
/// to the learner's actual performance.
public struct SessionSummary: Codable, Equatable {
    public let totalAnswers: Int
    public let correctAnswers: Int
    public let accuracy: Double          // 0…1
    public let medianLatencyMs: Int
    public let totalTimeMs: Int
    public let reservedItemIds: [String]   // items answered incorrectly this session
    public let slowestItemId: String?    // highest latency
    public let fastestItemId: String?    // lowest latency

    public init(events: [LearningEvent]) {
        let total = events.count
        let correct = events.filter(\.correct).count
        let latencies = events.map(\.latencyMs).sorted()
        let median = latencies.isEmpty ? 0 : (latencies.count % 2 == 0
            ? (latencies[latencies.count / 2 - 1] + latencies[latencies.count / 2]) / 2
            : latencies[latencies.count / 2])
        let totalTime = events.last?.ts.timeIntervalSince(events.first?.ts ?? Date()).rounded(.awayFromZero) ?? 0

        self.totalAnswers = total
        self.correctAnswers = correct
        self.accuracy = total == 0 ? 0 : Double(correct) / Double(total)
        self.medianLatencyMs = median
        self.totalTimeMs = Int(totalTime * 1000)
        self.reservedItemIds = events.filter { !$0.correct }.map(\.itemId)
        self.slowestItemId = events.max(by: { $0.latencyMs < $1.latencyMs })?.itemId
        self.fastestItemId = events.min(by: { $0.latencyMs < $1.latencyMs })?.itemId
    }
}

public extension EventStore {
    /// Compute a session summary from all events currently in the store.
    func sessionSummary() throws -> SessionSummary {
        SessionSummary(events: try all())
    }
}
