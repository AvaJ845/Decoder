import SwiftUI
import DecoderCore

struct GamePlayView: View {
    @Environment(\.colorScheme) private var scheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @StateObject private var model: GameModel
    @State private var showSettings = false

    init(pack: ContentPack, profileStore: ProfileStore = InMemoryProfileStore()) {
        _model = StateObject(wrappedValue: GameModel(pack: pack, profileStore: profileStore))
    }

    private var teal: Color { Color(hex: scheme == .dark ? DesignTokens.brandTeal.dark : DesignTokens.brandTeal.light) }
    private var tealText: Color { Color(hex: scheme == .dark ? DesignTokens.brandTealText.dark : DesignTokens.brandTealText.light) }
    private var ink: Color { Color(hex: scheme == .dark ? DesignTokens.ink.dark : DesignTokens.ink.light) }
    private var surface: Color { Color(hex: scheme == .dark ? DesignTokens.readingSurface.dark : DesignTokens.readingSurface.light) }
    private var reserve: Color { Color(hex: scheme == .dark ? DesignTokens.gentleReserve.dark : DesignTokens.gentleReserve.light) }
    private var bgTint: BackgroundTint { model.learner.accessibility.bgTint }

    var body: some View {
        ZStack {
            Theme.ground(scheme, tint: bgTint).ignoresSafeArea()

            VStack(spacing: 24) {
                header
                RaceTrack(progress: model.progress, reduceMotion: reduceMotion)
                    .frame(height: 60)
                if let item = model.current {
                    round(item)
                        .id(item.itemId)
                        .transition(reduceMotion
                            ? .opacity
                            : .asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                                          removal: .opacity))
                } else {
                    finished
                }
                Spacer(minLength: 8)
                arloBar
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
            .animation(reduceMotion ? .none : .spring(response: 0.45, dampingFraction: 0.85),
                       value: model.current?.itemId)

            if case .correct = model.feedback {
                CelebrateBurst(reduceMotion: reduceMotion, color: Theme.gold(scheme))
                    .id(model.burstToken)
                    .allowsHitTesting(false)
            }
        }
        .sheet(isPresented: $showSettings) {
            AccessibilitySettingsView(manager: model.fontManager) {
                model.savePreferences()
                showSettings = false
            }
        }
    }

    // MARK: - Round

    private func round(_ item: Item) -> some View {
        VStack(spacing: 20) {
            chunkPrompt(item.payload.targetChunk)
            Text("Pick the word with this chunk")
                .font(model.fontManager.reading(size: 17, weight: .medium))
                .readingSpacing(for: model.learner)
                .foregroundStyle(ink.opacity(0.6))
            VStack(spacing: 14) {
                ForEach(model.choices, id: \.self) { word in
                    card(word: word, chunk: item.payload.targetChunk)
                }
            }
        }
    }

    private func chunkPrompt(_ chunk: String) -> some View {
        Text(chunk)
            .font(model.fontManager.display(size: 56, weight: .heavy))
            .foregroundStyle(tealText)
            .frame(minWidth: 140, minHeight: 110)
            .background(surface, in: RoundedRectangle(cornerRadius: 24))
            .overlay(RoundedRectangle(cornerRadius: 24).stroke(teal, lineWidth: 5))
            .readingRuler(model.learner.accessibility.ruler, scheme: scheme)
            .accessibilityLabel("Target chunk \(chunk)")
    }

    private func card(word: String, chunk: String) -> some View {
        let state = cardState(for: word)
        return Button { model.choose(word) } label: {
            highlighted(word: word, chunk: chunk)
                .font(model.fontManager.reading(size: 36, weight: .bold))
                .readingSpacing(for: model.learner)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 22)
                .background(cardFill(state), in: RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(cardStroke(state), lineWidth: 4))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(word)
        .accessibilityHint("Choose if it contains the chunk")
        .opacity(state == .reserved ? 0.35 : 1)
        .offset(y: state == .reserved && !reduceMotion ? 24 : 0)
        .scaleEffect(state == .picked && !reduceMotion ? 1.04 : 1)
        .animation(reduceMotion ? .none : .spring(response: 0.35, dampingFraction: 0.7), value: model.feedback)
    }

    // MARK: - Chrome

    private var header: some View {
        HStack(alignment: .center) {
            Text("Chunk Racer")
                .font(model.fontManager.display(size: 26, weight: .heavy))
                .foregroundStyle(tealText)
            Spacer()
            progressDots
            Button {
                showSettings = true
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(ink.opacity(0.7))
                    .frame(width: 40, height: 40)
                    .background(surface, in: RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Reading settings")
        }
    }

    /// Five-dot session progress indicator, matching the mockup's top-right chrome.
    /// Progress lives on the race track too; the dots give the child a second, calmer cue.
    private var progressDots: some View {
        HStack(spacing: 6) {
            ForEach(0..<5, id: \.self) { i in
                Circle()
                    .fill(i < filledDots ? teal : ink.opacity(0.15))
                    .frame(width: 8, height: 8)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Session progress")
        .accessibilityValue("\(model.solved) of \(model.total) words cleared")
    }

    private var filledDots: Int {
        let total = max(model.total, 1)
        let fraction = Double(model.solved) / Double(total)
        let dots = Int((fraction * 5.0).rounded(.toNearestOrAwayFromZero))
        return Swift.min(5, dots)
    }

    /// The forgiving streak (art-bible §7): a star + streak count, and a shield when
    /// the child is protected (a miss won't reset it). Moved to the footer so the header
    /// matches the mockup's five-dot progress indicator.
    private var streakCounter: some View {
        HStack(spacing: 6) {
            Image(systemName: "star.fill")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(Theme.gold(scheme))
            Text("\(model.momentum.streak)")
                .font(model.fontManager.display(size: 18, weight: .heavy))
                .foregroundStyle(ink)
            if model.momentum.protectedCount > 0 {
                Image(systemName: "shield.fill")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(teal)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(surface, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(ink.opacity(0.12), lineWidth: 2))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Streak")
        .accessibilityValue("\(model.momentum.streak)" + (model.momentum.protectedCount > 0 ? ", protected" : ""))
    }

    private var arloToken: some View {
        if let img = BundleImage.image("arlo_smiley") {
            return AnyView(img.resizable().scaledToFit().frame(width: 56, height: 56))
        }
        // Fallback uses the darker teal so the white face stays AA-compliant.
        return AnyView(
            ZStack {
                RoundedRectangle(cornerRadius: 16).fill(tealText)
                Image(systemName: "face.smiling")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.white)
            }
            .frame(width: 56, height: 56)
        )
    }

    private var arloBar: some View {
        HStack(alignment: .bottom, spacing: 14) {
            arloToken
            Text(model.arloLine)
                .font(model.fontManager.reading(size: 16, weight: .semibold))
                .readingSpacing(for: model.learner)
                .foregroundStyle(ink)
                .padding(13)
                .background(surface, in: RoundedRectangle(cornerRadius: 18))
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(ink.opacity(0.12), lineWidth: 2))
            Spacer(minLength: 0)
            streakCounter
        }
        .padding(.bottom, 8)
    }

    private var finished: some View {
        VStack(spacing: 14) {
            Text("Race complete!")
                .font(model.fontManager.display(size: 32, weight: .heavy))
                .foregroundStyle(tealText)
            Text("\(model.solved) words cleared")
                .font(model.fontManager.reading(size: 17, weight: .medium))
                .readingSpacing(for: model.learner)
                .foregroundStyle(ink.opacity(0.7))
        }
        .padding(.top, 60)
    }

    // MARK: - Feedback state + text

    private enum CardState { case normal, picked, reserved }

    private func cardState(for word: String) -> CardState {
        switch model.feedback {
        case .correct(let w) where w == word: return .picked
        case .reserve(let w) where w == word: return .reserved
        default: return .normal
        }
    }

    private func cardFill(_ s: CardState) -> Color {
        switch s {
        case .picked: return Theme.gold(scheme).opacity(0.35)
        case .reserved: return reserve.opacity(0.35)
        case .normal: return surface
        }
    }

    private func cardStroke(_ s: CardState) -> Color {
        switch s {
        case .picked: return Theme.gold(scheme)
        case .reserved: return reserve
        case .normal: return ink.opacity(0.85)
        }
    }

    /// Highlight the target chunk inside the word (live text, so it honors the reading font).
    private func highlighted(word: String, chunk: String) -> Text {
        let lw = word.lowercased(), lc = chunk.lowercased()
        guard let r = lw.range(of: lc) else { return Text(word).foregroundColor(ink) }
        let start = lw.distance(from: lw.startIndex, to: r.lowerBound)
        let end = lw.distance(from: lw.startIndex, to: r.upperBound)
        var out = Text("")
        for (i, ch) in Array(word).enumerated() {
            let inChunk = (i >= start && i < end)
            out = out + Text(String(ch)).foregroundColor(inChunk ? tealText : ink)
        }
        return out
    }
}

// MARK: - Race track (mockup style: dashed line, car, flag)

private struct RaceTrack: View {
    let progress: Double
    let reduceMotion: Bool
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        GeometryReader { geo in
            let inset: CGFloat = 12
            let racerW: CGFloat = 48
            let usable = max(0, geo.size.width - inset * 2 - racerW)
            // Scheme-aware so the track stays visible in dark mode (light ink on a
            // dark ground would vanish). Decorative, so kept subtle either way.
            let inkC = Color(hex: scheme == .dark ? DesignTokens.ink.dark : DesignTokens.ink.light)
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(inkC.opacity(0.08))
                    .frame(height: 12)
                    .overlay(
                        DashedCenterLine().stroke(style: StrokeStyle(lineWidth: 2, dash: [10, 10]))
                            .foregroundStyle(inkC.opacity(0.25))
                    )
                    .offset(y: 26)
                // Finish flag
                if let flag = BundleImage.image("finish_flag") {
                    flag.resizable().scaledToFit()
                        .frame(width: 32, height: 32)
                        .offset(x: geo.size.width - 32, y: 14)
                } else {
                    Image(systemName: "flag.checkered")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color(hex: DesignTokens.ink.light).opacity(0.5))
                        .offset(x: geo.size.width - 28, y: 14)
                }
                // Car icon
                if let car = BundleImage.image("racer_car") {
                    car.resizable().scaledToFit()
                        .frame(width: racerW, height: 32)
                        .offset(x: inset + usable * progress, y: 14)
                        .animation(reduceMotion ? .none : .spring(response: 0.5, dampingFraction: 0.7), value: progress)
                } else {
                    Racer()
                        .frame(width: racerW, height: 32)
                        .offset(x: inset + usable * progress, y: 14)
                        .animation(reduceMotion ? .none : .spring(response: 0.5, dampingFraction: 0.7), value: progress)
                }
            }
        }
    }
}

private struct DashedCenterLine: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: 0, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.width, y: rect.midY))
        return p
    }
}

/// Simple native racer placeholder (teal body, coral stripe, dark wheels).
/// Swaps to real vehicle art via the resolver once DE-Art delivers it.
private struct Racer: View {
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: scheme == .dark ? DesignTokens.brandTeal.dark : DesignTokens.brandTeal.light))
            RoundedRectangle(cornerRadius: 3)
                .fill(Color(hex: DesignTokens.secondaryCoral.light))
                .frame(height: 6)
                .padding(.horizontal, 8)
            HStack {
                Circle().fill(Color(hex: DesignTokens.ink.light)).frame(width: 12, height: 12)
                Spacer()
                Circle().fill(Color(hex: DesignTokens.ink.light)).frame(width: 12, height: 12)
            }
            .padding(.horizontal, 4)
            .offset(y: 12)
        }
    }
}

// MARK: - Celebrate burst

private struct CelebrateBurst: View {
    let reduceMotion: Bool
    let color: Color
    @State private var animate = false

    var body: some View {
        ZStack {
            if reduceMotion {
                Circle()
                    .stroke(color, lineWidth: 5)
                    .frame(width: animate ? 150 : 90, height: animate ? 150 : 90)
                    .opacity(animate ? 0 : 0.9)
            } else {
                ForEach(0..<6, id: \.self) { i in
                    let angle = Double(i) / 6 * 2 * .pi
                    Image(systemName: "star.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(color)
                        .offset(x: animate ? cos(angle) * 96 : 0,
                                y: animate ? sin(angle) * 96 : 0)
                        .opacity(animate ? 0 : 1)
                        .scaleEffect(animate ? 0.4 : 1)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: reduceMotion ? 0.5 : 0.6)) { animate = true }
        }
    }
}
