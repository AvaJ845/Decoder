import Foundation

/// Turns a logical asset key into ordered candidate filenames. Vector (PDF) wins,
/// then raster densities. Dark / Reduce-Motion are suffixes. This is the layer that
/// makes "iPad later" a drop-in: content never names a pixel file (build doc §8.1).
public enum AssetKeyResolver {

    /// Candidate filenames in priority order for the asset catalog / bundle lookup.
    /// Suffix order mirrors the naming convention: `<key>[_reducemotion][_dark]`.
    public static func candidates(for key: String, dark: Bool = false, reduceMotion: Bool = false) -> [String] {
        var base = key
        if reduceMotion { base += "_reducemotion" }
        if dark { base += "_dark" }
        return [
            "\(base).pdf",     // vector-first
            "\(base)@3x.png",
            "\(base)@2x.png",
            "\(base)@1x.png",
            "\(base).png",
        ]
    }
}
