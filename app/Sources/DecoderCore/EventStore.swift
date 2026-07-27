import Foundation

/// One append-only learning event — the raw material for both the adaptive engine
/// and the parent/teacher evidence view (build doc §7, §10). Never mutated.
public struct LearningEvent: Codable, Equatable {
    public let learnerId: String
    public let appId: String
    public let itemId: String
    public let correct: Bool
    public let latencyMs: Int
    public let ts: Date

    public init(learnerId: String, appId: String, itemId: String, correct: Bool, latencyMs: Int, ts: Date = Date()) {
        self.learnerId = learnerId
        self.appId = appId
        self.itemId = itemId
        self.correct = correct
        self.latencyMs = latencyMs
        self.ts = ts
    }
}

public protocol EventStore {
    func append(_ event: LearningEvent) throws
    func all() throws -> [LearningEvent]
}

/// In-memory store for tests and previews.
public final class InMemoryEventStore: EventStore {
    private var events: [LearningEvent] = []
    public init() {}
    public func append(_ event: LearningEvent) throws { events.append(event) }
    public func all() throws -> [LearningEvent] { events }
}

/// Append-only JSON-Lines store. One event per line so writes are cheap and the log
/// is never rewritten. Offline-first: it works with no connectivity; a sync layer
/// ships the lines later (Sprint 9).
public final class FileEventStore: EventStore {
    private let url: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    public init(url: URL) {
        self.url = url
        self.encoder = JSONEncoder()
        self.encoder.dateEncodingStrategy = .iso8601
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }

    public func append(_ event: LearningEvent) throws {
        var line = try encoder.encode(event)
        line.append(0x0A) // newline
        if FileManager.default.fileExists(atPath: url.path) {
            let handle = try FileHandle(forWritingTo: url)
            defer { try? handle.close() }
            try handle.seekToEnd()
            try handle.write(contentsOf: line)
        } else {
            // First write sets the file's protection class; appends inherit it.
            try line.write(to: url, options: [.atomic, .completeFileProtectionUntilFirstUserAuthentication])
        }
    }

    public func all() throws -> [LearningEvent] {
        guard FileManager.default.fileExists(atPath: url.path) else { return [] }
        let data = try Data(contentsOf: url)
        return data.split(separator: 0x0A).compactMap { try? decoder.decode(LearningEvent.self, from: Data($0)) }
    }
}
