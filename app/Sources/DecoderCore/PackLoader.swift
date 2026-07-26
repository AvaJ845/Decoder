import Foundation

/// Loads and decodes packs and the skill graph. Unknown top-level keys (e.g. `$schema`)
/// are ignored by Codable, so authored JSON can carry metadata the app doesn't model.
public enum PackLoader {

    public enum LoadError: Error, CustomStringConvertible {
        case invalidPack([ContentPackValidator.Issue])
        public var description: String {
            switch self {
            case .invalidPack(let issues):
                return "content pack failed validation:\n" + issues.map { "  \($0)" }.joined(separator: "\n")
            }
        }
    }

    public static func load(from url: URL) throws -> ContentPack {
        try JSONDecoder().decode(ContentPack.self, from: Data(contentsOf: url))
    }

    public static func loadSkillGraph(from url: URL) throws -> SkillGraph {
        try JSONDecoder().decode(SkillGraph.self, from: Data(contentsOf: url))
    }

    /// Load + validate in one step. Throws if any *error*-severity issue is present.
    public static func loadValidated(from url: URL, skillNodeIDs: Set<String>? = nil) throws -> ContentPack {
        let pack = try load(from: url)
        let errors = ContentPackValidator.errors(ContentPackValidator.validate(pack, skillNodeIDs: skillNodeIDs))
        if !errors.isEmpty { throw LoadError.invalidPack(errors) }
        return pack
    }
}
