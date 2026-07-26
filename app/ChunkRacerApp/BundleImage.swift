import SwiftUI
import DecoderCore

/// Loads a loose bundled image by asset *key*, using the same resolver order the app
/// ships with (vector-first, then densities; dark/reduce-motion suffixes). Prototype
/// chrome (Arlo, etc.) lives as PNGs at bundle root; final vector art swaps in behind
/// this same call with zero view changes.
enum BundleImage {
    static func image(_ key: String, dark: Bool = false, reduceMotion: Bool = false) -> Image? {
        for candidate in AssetKeyResolver.candidates(for: key, dark: dark, reduceMotion: reduceMotion) {
            let base = (candidate as NSString).deletingPathExtension
            let ext = (candidate as NSString).pathExtension
            if let url = Bundle.main.url(forResource: base, withExtension: ext),
               let ui = UIImage(contentsOfFile: url.path) {
                return Image(uiImage: ui)
            }
        }
        return nil
    }
}
