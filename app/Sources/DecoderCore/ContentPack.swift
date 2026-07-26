import Foundation

/// A versioned, platform-neutral content pack (schema v2.1).
/// Content references asset *keys*, never pixel filenames — the app resolves keys
/// to @2x/@3x/PDF and light/dark variants per device (build doc §8.1).
public struct ContentPack: Codable, Equatable {
    public let id: String
    public let version: String
    public let appId: String
    public let locale: String
    public let skillIds: [String]
    public let alignment: Alignment?
    public let items: [Item]
}

public struct Alignment: Codable, Equatable {
    public let framework: String?
    public let strand: String?
    public let level: String?
}

public struct Item: Codable, Equatable {
    public let itemId: String
    public let skillId: String
    public let difficultyBand: Int
    public let payload: Payload
    public let assetKeys: [String]?
    public let cues: [Cue]?
    public let minCanvas: MinCanvas?
    public let enhancedInput: [String]?
}

/// Chunk Racer mechanic (v2.1): the `targetChunk` is the prompt; the player picks
/// the streaming word that contains it. `correctWord` contains the chunk; every
/// `distractorWords` entry must NOT — guaranteeing exactly one right answer.
public struct Payload: Codable, Equatable {
    public let targetChunk: String
    public let correctWord: String
    public let distractorWords: [String]
    public let hint: String?
}

public enum MinCanvas: String, Codable, Equatable {
    case compact, regular, large
}
