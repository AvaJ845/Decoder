import SwiftUI
import DecoderCore

/// Loads + validates the bundled pack through DecoderCore, then hands off to the
/// interactive gray-box loop. A load failure surfaces the validator's reason.
struct ContentView: View {
    @Environment(\.colorScheme) private var scheme
    @State private var pack: ContentPack?
    @State private var error: String?

    /// The production store keeps mastery + momentum across launches.
    private var profileStore: ProfileStore {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent("DecoderProfiles", isDirectory: true)
        if let dir {
            return FileProfileStore(directory: dir)
        }
        return InMemoryProfileStore()
    }

    var body: some View {
        Group {
            if let pack {
                GamePlayView(pack: pack, profileStore: profileStore)
            } else if let error {
                VStack(spacing: 10) {
                    Text("Couldn’t start")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.ink(scheme))
                    Text(error)
                        .font(.footnote.monospaced())
                        .foregroundStyle(Theme.ink(scheme).opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Theme.ground(scheme))
            } else {
                Color.clear.task { load() }
            }
        }
    }

    private func load() {
        guard let packURL = Bundle.main.url(forResource: "chunk-racer-basics-pack", withExtension: "json"),
              let graphURL = Bundle.main.url(forResource: "skill-graph", withExtension: "json") else {
            error = "Bundle resources missing"; return
        }
        do {
            let graph = try PackLoader.loadSkillGraph(from: graphURL)
            pack = try PackLoader.loadValidated(from: packURL, skillNodeIDs: graph.nodeIDs())
        } catch {
            self.error = "\(error)"
        }
    }
}
