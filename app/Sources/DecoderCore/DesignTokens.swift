import Foundation

/// The frozen art-bible palette and type roles, platform-neutral (hex strings, not
/// UIColor) so the core stays UI-framework-free. The SwiftUI layer maps these to
/// `Color` (see ChunkRacerApp/Theme.swift). Values match decoder-art-bible.md §3.
public enum DesignTokens {

    public struct Swatch: Equatable {
        public let light: String
        public let dark: String
    }

    // Grounds & ink
    public static let ground        = Swatch(light: "#F7F4EC", dark: "#1A1F23")
    public static let readingSurface = Swatch(light: "#FFFDF7", dark: "#2A3036")
    public static let ink           = Swatch(light: "#264653", dark: "#CED4DA")

    // Brand
    public static let brandTeal     = Swatch(light: "#2A9D8F", dark: "#4ECDC4")
    // Darker teal for text on light surfaces so the reading surface hits AA
    // without changing the brand accent color (D7). Contrast ≥ 4.5:1 on cream/surface.
    public static let brandTealText = Swatch(light: "#1B7A6E", dark: "#4ECDC4")
    public static let secondaryCoral = Swatch(light: "#E76F51", dark: "#F4A261")

    // Semantic — always paired with a shape/icon, never color alone
    public static let rewardGold    = Swatch(light: "#A67C2E", dark: "#FFD670")
    // gentleReserve must be dark enough for a re-serve card border on the light surface (3:1 UI).
    public static let gentleReserve = Swatch(light: "#5A8A8A", dark: "#7AB0B0")
    public static let momentumGreen = Swatch(light: "#8FBF5A", dark: "#A9D66B")

    /// Two type roles that never bleed into each other (art-bible §4).
    /// Reading default is Lexend Deca (D19); OpenDyslexic remains user-switchable.
    public enum TypeRole {
        public static let display = "Fredoka One"          // titles, buttons, celebrations
        public static let readingDefault = "Lexend Deca"   // the decoding surface (default)
        public static let readingFallback = "OpenDyslexic" // user-switchable alternative
    }
}
