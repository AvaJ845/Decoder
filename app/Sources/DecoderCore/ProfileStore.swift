import Foundation

/// Persist a learner profile to disk. Profile is the source of truth for
/// mastery, accessibility prefs, and the reward economy across all apps.
public protocol ProfileStore {
    func load(id: String) throws -> LearnerProfile?
    func save(_ profile: LearnerProfile) throws
}

/// In-memory store for tests and previews.
public final class InMemoryProfileStore: ProfileStore {
    private var profiles: [String: LearnerProfile] = [:]
    public init() {}

    public func load(id: String) throws -> LearnerProfile? { profiles[id] }
    public func save(_ profile: LearnerProfile) throws { profiles[profile.id] = profile }
}

/// File-based JSON store. One profile per app/device for now; multi-learner
/// accounts are a Horizon 2 addition.
public final class FileProfileStore: ProfileStore {
    private let directory: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    public init(directory: URL) {
        self.directory = directory
        self.encoder = JSONEncoder()
        self.encoder.dateEncodingStrategy = .iso8601
        self.encoder.outputFormatting = .prettyPrinted
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    }

    private func url(for id: String) -> URL {
        directory.appendingPathComponent("\(id).profile.json")
    }

    public func load(id: String) throws -> LearnerProfile? {
        let url = url(for: id)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        let data = try Data(contentsOf: url)
        return try decoder.decode(LearnerProfile.self, from: data)
    }

    public func save(_ profile: LearnerProfile) throws {
        var copy = profile
        copy.touch()
        let data = try encoder.encode(copy)
        // Children's data at rest: encrypt on disk (available after first unlock).
        try data.write(to: url(for: profile.id), options: [.atomic, .completeFileProtectionUntilFirstUserAuthentication])
    }
}
