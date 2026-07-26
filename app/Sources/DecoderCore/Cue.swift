import Foundation

/// An abstract multisensory cue. The app maps it to Core Haptics on iPhone and to
/// audio/visual emphasis everywhere (iPad has no haptic engine). Content never names
/// a device-specific effect — that keeps iPad a drop-in (build doc §8.1–8.2).
public struct Cue: Codable, Equatable {
    public let emphasis: Emphasis
    public let type: CueType
}

public enum Emphasis: String, Codable, Equatable {
    case light, medium, strong
}

public enum CueType: String, Codable, Equatable {
    case snap, pulse, bloom, drift
}
