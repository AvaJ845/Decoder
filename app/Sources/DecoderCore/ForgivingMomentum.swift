import Foundation

/// Momentum that celebrates streaks but forgives a bad day (art-bible §7).
/// A "protected" rest-day state prevents one miss from resetting long progress.
public struct ForgivingMomentum: Codable, Equatable {
    public private(set) var streak: Int
    public private(set) var maxStreak: Int
    public private(set) var protectedUntil: Date?
    public private(set) var protectedCount: Int

    public var isProtected: Bool {
        guard let until = protectedUntil else { return false }
        return Date() < until
    }

    public init(streak: Int = 0, maxStreak: Int = 0, protectedCount: Int = 0, protectedUntil: Date? = nil) {
        self.streak = streak
        self.maxStreak = maxStreak
        self.protectedCount = protectedCount
        self.protectedUntil = protectedUntil
    }

    /// Record a correct answer. Increases streak and may extend protection.
    public mutating func hit() {
        streak += 1
        maxStreak = max(maxStreak, streak)
        // Protect the next 2 misses once a streak of 5 is reached.
        if streak >= 5 {
            protectedCount = 2
        }
    }

    /// Record a miss. Forgiving: if protected, consumes protection; otherwise
    /// resets streak to a floor of 1 (not 0) so the child keeps some momentum.
    public mutating func miss() {
        if protectedCount > 0 {
            protectedCount -= 1
            // Streak stays; the child is protected.
            return
        }
        streak = max(0, streak - 2)  // drop, but not to zero if they had some
        protectedUntil = nil
    }

    /// Activate a rest-day shield: e.g. after a day without play, one bad day
    /// cannot wipe out a prior streak. Call this at session start when the
    /// previous session was yesterday.
    public mutating func shieldForRestDay() {
        protectedCount = 1
    }

    /// Visual level for the UI (0…5).
    public var displayLevel: Int {
        min(5, streak)
    }
}
