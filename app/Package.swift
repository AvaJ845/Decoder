// swift-tools-version:5.9
import PackageDescription

// DecoderCore — the platform-neutral shared core (Sprint 0).
// Pure Swift / Foundation only so it builds and tests headless via `swift test`.
// The iOS app target (SwiftUI + SpriteKit) lives in ChunkRacerApp/ and is added
// via the Xcode project — it depends on this package.
let package = Package(
    name: "DecoderCore",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "DecoderCore", targets: ["DecoderCore"]),
    ],
    targets: [
        .target(name: "DecoderCore"),
        .testTarget(
            name: "DecoderCoreTests",
            dependencies: ["DecoderCore"],
            resources: [
                .copy("Resources/chunk-racer-basics-pack.json"),
                .copy("Resources/skill-graph.json"),
            ]
        ),
    ]
)
