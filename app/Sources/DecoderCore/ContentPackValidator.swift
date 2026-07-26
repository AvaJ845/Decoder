import Foundation

/// Validates a content pack against schema-v2.1 invariants — in particular the
/// Chunk Racer mechanic rule that guarantees exactly one correct answer.
/// This is the in-app gate: malformed packs are rejected at load (Sprint 0).
public enum ContentPackValidator {

    public struct Issue: Equatable, CustomStringConvertible {
        public enum Severity: String { case error, warning }
        public let severity: Severity
        public let itemId: String?
        public let message: String

        public var description: String {
            "[\(severity.rawValue)] " + (itemId.map { "\($0): " } ?? "") + message
        }
    }

    /// Returns all issues (errors + warnings). Pass `skillNodeIDs` to also check the
    /// pack's skills against the live skill graph.
    public static func validate(_ pack: ContentPack, skillNodeIDs: Set<String>? = nil) -> [Issue] {
        var issues: [Issue] = []

        if pack.items.isEmpty {
            issues.append(.init(severity: .error, itemId: nil, message: "pack has no items"))
        }

        for item in pack.items {
            let chunk = item.payload.targetChunk.lowercased()
            let correct = item.payload.correctWord.lowercased()

            if chunk.isEmpty {
                issues.append(.init(severity: .error, itemId: item.itemId, message: "empty targetChunk"))
            }
            if !correct.contains(chunk) {
                issues.append(.init(severity: .error, itemId: item.itemId,
                    message: "correctWord '\(item.payload.correctWord)' does not contain targetChunk '\(item.payload.targetChunk)'"))
            }
            if item.payload.distractorWords.isEmpty {
                issues.append(.init(severity: .error, itemId: item.itemId, message: "no distractorWords"))
            }
            for d in item.payload.distractorWords {
                let dl = d.lowercased()
                if dl == correct {
                    issues.append(.init(severity: .error, itemId: item.itemId,
                        message: "distractor '\(d)' equals correctWord"))
                }
                if dl.contains(chunk) {
                    issues.append(.init(severity: .error, itemId: item.itemId,
                        message: "distractor '\(d)' contains targetChunk '\(item.payload.targetChunk)' — creates a second correct answer"))
                }
            }
            if item.difficultyBand < 1 || item.difficultyBand > 5 {
                issues.append(.init(severity: .error, itemId: item.itemId,
                    message: "difficultyBand \(item.difficultyBand) out of range 1–5"))
            }
            if !pack.skillIds.contains(item.skillId) {
                issues.append(.init(severity: .error, itemId: item.itemId,
                    message: "skillId '\(item.skillId)' not declared in pack.skillIds"))
            }
            if (item.assetKeys ?? []).isEmpty {
                issues.append(.init(severity: .warning, itemId: item.itemId, message: "item has no assetKeys"))
            }
        }

        if let ids = skillNodeIDs {
            for s in pack.skillIds where !ids.contains(s) {
                issues.append(.init(severity: .error, itemId: nil,
                    message: "pack skillId '\(s)' not found in the skill graph"))
            }
        }

        return issues
    }

    public static func errors(_ issues: [Issue]) -> [Issue] {
        issues.filter { $0.severity == .error }
    }
}
