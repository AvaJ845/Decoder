import Foundation

/// Accessibility preferences for a learner. Defaults align with the art-bible:
/// off-white ground, OpenDyslexic reading type, reading ruler on.
public struct AccessibilityPrefs: Codable, Equatable {
    public var readingFontName: String
    public var displayFontName: String
    public var letterSpacing: Double
    public var lineHeight: Double
    public var bgTint: BackgroundTint
    public var ruler: Bool
    public var tts: Bool
    public var reduceMotion: Bool

    public init(
        readingFontName: String = DesignTokens.TypeRole.readingDefault,
        displayFontName: String = DesignTokens.TypeRole.display,
        letterSpacing: Double = 0.02,
        lineHeight: Double = 1.4,
        bgTint: BackgroundTint = .cream,
        ruler: Bool = true,
        tts: Bool = true,
        reduceMotion: Bool = false
    ) {
        self.readingFontName = readingFontName
        self.displayFontName = displayFontName
        self.letterSpacing = letterSpacing
        self.lineHeight = lineHeight
        self.bgTint = bgTint
        self.ruler = ruler
        self.tts = tts
        self.reduceMotion = reduceMotion
    }
}

public enum BackgroundTint: String, Codable, Equatable, CaseIterable {
    case cream, softBlue, softGrey, offWhite

    public var hexLight: String {
        switch self {
        case .cream: return "#F7F4EC"
        case .softBlue: return "#EAF4F4"
        case .softGrey: return "#F0F0F0"
        case .offWhite: return "#FAFAF5"
        }
    }
}

/// A single learner's profile. One profile is shared across all apps in the
/// Decoder series (build doc §4.1).
public struct LearnerProfile: Codable, Equatable {
    public let id: String
    public var displayName: String
    public var ageBand: String
    public var accessibility: AccessibilityPrefs
    public var skillStates: [String: SkillState]
    public var momentum: ForgivingMomentum
    public var toolIds: [String]
    public var currencyBalance: Int
    public var createdAt: Date
    public var updatedAt: Date

    public init(
        id: String = UUID().uuidString,
        displayName: String,
        ageBand: String = "6-8",
        accessibility: AccessibilityPrefs = AccessibilityPrefs(),
        skillStates: [String: SkillState] = [:],
        momentum: ForgivingMomentum = ForgivingMomentum(),
        toolIds: [String] = [],
        currencyBalance: Int = 0
    ) {
        self.id = id
        self.displayName = displayName
        self.ageBand = ageBand
        self.accessibility = accessibility
        self.skillStates = skillStates
        self.momentum = momentum
        self.toolIds = toolIds
        self.currencyBalance = currencyBalance
        self.createdAt = Date()
        self.updatedAt = Date()
    }

    public mutating func touch() {
        updatedAt = Date()
    }

    public func state(for skillId: String) -> SkillState {
        skillStates[skillId] ?? SkillState(skillId: skillId)
    }

    public mutating func apply(_ event: LearningEvent, targetMastery: Double = 0.8) {
        // Events don't carry skillId, so we need the item's skillId to be supplied by the caller.
        // This is handled by the caller (GameModel) which knows the item.
        touch()
    }
}
