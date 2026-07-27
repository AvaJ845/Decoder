import SwiftUI
import DecoderCore

/// Parent-accessible settings for the child's reading surface. Tied directly to
/// LearnerProfile.accessibility so changes persist across launches (D7, D8, D10).
struct AccessibilitySettingsView: View {
    @Environment(\.colorScheme) private var scheme
    @ObservedObject var manager: FontManager
    let onSave: () -> Void
    var onStartFresh: () -> Void = {}
    @State private var confirmFresh = false

    private var prefs: AccessibilityPrefs { manager.profile.accessibility }

    var body: some View {
        NavigationStack {
            Form {
                Section("Reading font") {
                    Picker("Font", selection: $manager.profile.accessibility.readingFontName) {
                        Text("System").tag("System")
                        Text("Lexend Deca").tag(DesignTokens.TypeRole.readingDefault)
                        Text("OpenDyslexic").tag(DesignTokens.TypeRole.readingFallback)
                    }
                    .pickerStyle(.segmented)

                    Text("The quick brown fox jumps over the lazy dog.")
                        .font(manager.reading(size: 20, weight: .regular))
                        .readingSpacing(for: manager.profile)
                        .padding(.vertical, 4)
                }

                Section("Spacing") {
                    VStack(alignment: .leading) {
                        Text("Letter spacing: \(String(format: "%.2f", prefs.letterSpacing))")
                        Slider(value: $manager.profile.accessibility.letterSpacing, in: 0...0.12, step: 0.01)
                    }
                    VStack(alignment: .leading) {
                        Text("Line height: \(String(format: "%.2f", prefs.lineHeight))")
                        Slider(value: $manager.profile.accessibility.lineHeight, in: 1.0...2.0, step: 0.05)
                    }
                }

                Section("Background tint") {
                    Picker("Tint", selection: $manager.profile.accessibility.bgTint) {
                        ForEach(BackgroundTint.allCases, id: \.self) { tint in
                            Text(tint.rawValue.capitalized).tag(tint)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Reading aids") {
                    Toggle("Reading ruler", isOn: $manager.profile.accessibility.ruler)
                    Toggle("Text-to-speech", isOn: $manager.profile.accessibility.tts)
                    Toggle("Reduce motion", isOn: $manager.profile.accessibility.reduceMotion)
                }

                Section("New player") {
                    Button(role: .destructive) { confirmFresh = true } label: {
                        Label("Start fresh — new player", systemImage: "arrow.counterclockwise")
                    }
                    .confirmationDialog("Start fresh for a new player? This clears the current progress and settings.",
                                        isPresented: $confirmFresh, titleVisibility: .visible) {
                        Button("Start fresh", role: .destructive) { onStartFresh() }
                        Button("Cancel", role: .cancel) {}
                    }
                    Text("Use between children in a playtest so each starts clean.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Reading settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { onSave() }
                }
            }
            .background(Theme.ground(scheme, tint: prefs.bgTint))
        }
    }
}
