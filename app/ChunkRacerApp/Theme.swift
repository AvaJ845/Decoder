import SwiftUI
import DecoderCore

/// Maps the platform-neutral DesignTokens (hex strings) to SwiftUI Colors, honoring
/// light/dark. Reading type uses OpenDyslexic (bundled) with a Lexend Deca fallback;
/// display type uses Fredoka One. Never style the reading role (art-bible §4).
extension Color {
    init(hex: String) {
        let s = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        var v: UInt64 = 0
        Scanner(string: s).scanHexInt64(&v)
        self.init(.sRGB,
                  red: Double((v >> 16) & 0xFF) / 255,
                  green: Double((v >> 8) & 0xFF) / 255,
                  blue: Double(v & 0xFF) / 255,
                  opacity: 1)
    }

    static func token(_ swatch: DesignTokens.Swatch, _ scheme: ColorScheme) -> Color {
        Color(hex: scheme == .dark ? swatch.dark : swatch.light)
    }
}

enum Theme {
    static func ground(_ s: ColorScheme, tint: BackgroundTint = .cream) -> Color {
        // Use the learner's chosen background tint; art-bible requires tint-safe art.
        Color(hex: s == .dark ? DesignTokens.ground.dark : tint.hexLight)
    }
    static func surface(_ s: ColorScheme) -> Color { .token(DesignTokens.readingSurface, s) }
    static func ink(_ s: ColorScheme) -> Color { .token(DesignTokens.ink, s) }
    static func teal(_ s: ColorScheme) -> Color { .token(DesignTokens.brandTeal, s) }
    static func tealText(_ s: ColorScheme) -> Color { .token(DesignTokens.brandTealText, s) }
    static func coral(_ s: ColorScheme) -> Color { .token(DesignTokens.secondaryCoral, s) }
    static func gold(_ s: ColorScheme) -> Color { .token(DesignTokens.rewardGold, s) }
    static func gentleReserve(_ s: ColorScheme) -> Color { .token(DesignTokens.gentleReserve, s) }
}

// MARK: - Reading-ruler helper

struct ReadingRuler: ViewModifier {
    let isEnabled: Bool
    let scheme: ColorScheme

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.token(DesignTokens.brandTeal, scheme).opacity(isEnabled ? 0.12 : 0))
                    .frame(height: isEnabled ? 44 : 0)
                    .allowsHitTesting(false)
            )
    }
}

extension View {
    func readingRuler(_ enabled: Bool, scheme: ColorScheme) -> some View {
        modifier(ReadingRuler(isEnabled: enabled, scheme: scheme))
    }
}
