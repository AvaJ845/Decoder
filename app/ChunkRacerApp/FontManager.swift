import SwiftUI
import DecoderCore

/// Manages the two type roles from the art bible (§4): display and reading.
/// Falls back to the system rounded font when the bundled licensed faces are not
/// yet present in the app bundle. When they are dropped into Resources/Fonts,
/// the app will load them automatically and Dynamic Type will continue to work.
@MainActor
final class FontManager: ObservableObject {
    @Published var profile: LearnerProfile

    init(profile: LearnerProfile) {
        self.profile = profile
    }

    /// Display type: Fredoka One (titles, buttons, celebrations).
    /// Falls back to system rounded if the bundled font is missing.
    func display(size: CGFloat, weight: Font.Weight = .bold) -> Font {
        let prefs = profile.accessibility
        if UIFont(name: prefs.displayFontName, size: 1) != nil {
            return .custom(prefs.displayFontName, size: size, relativeTo: textStyleFor(size: size))
                .weight(weight)
        }
        // Fallback: a semantic system style so Dynamic Type still scales before the
        // licensed fonts are dropped in (a fixed .system(size:) would NOT scale).
        return .system(textStyleFor(size: size), design: .rounded).weight(weight)
    }

    /// Reading type: OpenDyslexic or Lexend Deca, user-switchable.
    /// Scales with Dynamic Type and honors letter spacing / line height.
    func reading(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let prefs = profile.accessibility
        let name = prefs.readingFontName
        if UIFont(name: name, size: 1) != nil {
            return .custom(name, size: size, relativeTo: textStyleFor(size: size))
                .weight(weight)
        }
        // Fallback scales with Dynamic Type too (see display()).
        return .system(textStyleFor(size: size), design: .rounded).weight(weight)
    }

    /// Semantic text style for Dynamic Type sizing based on the requested point size.
    private func textStyleFor(size: CGFloat) -> Font.TextStyle {
        switch size {
        case ..<14: return .caption
        case ..<17: return .footnote
        case ..<21: return .body
        case ..<29: return .title3
        case ..<37: return .title2
        default: return .largeTitle
        }
    }

    /// Register bundled fonts at launch. Call once from the app entry point.
    static func registerBundledFonts() {
        guard let urls = Bundle.main.urls(forResourcesWithExtension: "ttf", subdirectory: "Fonts")
            ?? Bundle.main.urls(forResourcesWithExtension: "otf", subdirectory: "Fonts") else {
            return
        }
        for url in urls {
            var error: Unmanaged<CFError>?
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
            // Log and ignore registration failures — the system rounded fallback covers it.
            if let error = error?.takeRetainedValue() {
                print("Font registration failed for \(url.lastPathComponent): \(error)")
            }
        }
    }
}

// MARK: - Convenience modifiers for reading spacing

extension View {
    /// Apply the learner's reading spacing and line height to any reading text.
    func readingSpacing(for profile: LearnerProfile) -> some View {
        self
            .kerning(profile.accessibility.letterSpacing * 16) // convert to points at 16pt base
            .lineSpacing(profile.accessibility.lineHeight - 1)
    }
}
