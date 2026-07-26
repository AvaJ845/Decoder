import Foundation

/// The reading-strategy spine as a DAG (build doc §5). Every game practices nodes
/// on this graph; new content is new nodes/packs, not new plumbing.
public struct SkillGraph: Codable, Equatable {
    public let title: String
    public let version: String
    public let nodes: [SkillNode]
    public let tracks: [SkillTrack]?

    public func nodeIDs() -> Set<String> { Set(nodes.map(\.id)) }
}

public struct SkillNode: Codable, Equatable {
    public let id: String
    public let name: String
    public let description: String?
    public let prerequisites: [String]
    public let masteryThreshold: Double
    public let apps: [String]
}

public struct SkillTrack: Codable, Equatable {
    public let id: String
    public let name: String
    public let description: String?
    public let nodes: [String]
}
