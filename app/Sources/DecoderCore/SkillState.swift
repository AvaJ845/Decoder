import Foundation

/// Per-skill mastery state for a single learner. Mirrors the data model in
/// decoder-build-doc.md §7 and the skill graph in decoder-art-bible.md §5.
public struct SkillState: Codable, Equatable, Identifiable {
    public let skillId: String
    public var mastery: Double        // 0…1
    public var lastPracticed: Date?
    public var dueAt: Date?

    public var id: String { skillId }

    public init(skillId: String, mastery: Double = 0, lastPracticed: Date? = nil, dueAt: Date? = nil) {
        self.skillId = skillId
        self.mastery = max(0, min(1, mastery))
        self.lastPracticed = lastPracticed
        self.dueAt = dueAt
    }

    /// Apply one practice outcome and nudge mastery toward the target.
    /// - Parameters:
    ///   - correct: whether the learner answered correctly.
    ///   - targetMastery: threshold from the skill graph (e.g. 0.85).
    public mutating func apply(correct: Bool, targetMastery: Double = 0.8) {
        let step = correct ? 0.12 : -0.05
        // If below target, correct answers move faster; above target, move slower.
        let scale = mastery < targetMastery ? 1.0 : 0.5
        mastery = max(0, min(1, mastery + step * scale))
        lastPracticed = Date()
        // Simple spaced review: due again after a delay that grows with mastery.
        let days = correct ? min(14, 1 + Int(mastery * 14)) : 1
        dueAt = Calendar.current.date(byAdding: .day, value: days, to: Date())
    }
}
