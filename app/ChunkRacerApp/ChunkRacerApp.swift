import SwiftUI
import DecoderCore

// Sprint 0 app shell. Universal target, but only the iPhone UI is built/QA'd now
// (build doc §8.2). Requires the Xcode project — SPM builds DecoderCore headless;
// this UI layer imports it. See app/README.md for project setup.
@main
struct ChunkRacerApp: App {
    init() {
        FontManager.registerBundledFonts()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
