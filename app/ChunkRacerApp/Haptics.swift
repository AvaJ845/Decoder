import Foundation
import CoreHaptics
import DecoderCore

/// Sprint 0 risk-spike + the real cue→haptic mapper (build doc §8.1).
/// Content fires an abstract `Cue`; on iPhone this plays a Core Haptics transient/
/// continuous pattern. On iPad (no haptic engine) `CHHapticEngine.capabilitiesForHardware`
/// reports no support and we no-op — the visual/audio half of the cue still fires.
final class Haptics {
    private var engine: CHHapticEngine?
    let supportsHaptics = CHHapticEngine.capabilitiesForHardware().supportsHaptics

    func start() {
        guard supportsHaptics else { return } // iPad path: silently skip
        engine = try? CHHapticEngine()
        try? engine?.start()
    }

    /// Map the abstract cue to intensity/sharpness. `snap` is a crisp transient (a hit),
    /// `pulse` a softer tap (sight word), `bloom` a swelling continuous (multisyllable
    /// success), `drift` a gentle fade (fluency). Emphasis scales intensity.
    func play(_ cue: Cue) {
        guard supportsHaptics, let engine else { return }
        let intensity: Float = switch cue.emphasis {
            case .light: 0.4; case .medium: 0.7; case .strong: 1.0
        }
        let sharpness: Float; let duration: TimeInterval; let continuous: Bool
        switch cue.type {
        case .snap:  sharpness = 0.9; duration = 0.0;  continuous = false
        case .pulse: sharpness = 0.4; duration = 0.0;  continuous = false
        case .bloom: sharpness = 0.3; duration = 0.35; continuous = true
        case .drift: sharpness = 0.2; duration = 0.5;  continuous = true
        }
        let event = CHHapticEvent(
            eventType: continuous ? .hapticContinuous : .hapticTransient,
            parameters: [
                .init(parameterID: .hapticIntensity, value: intensity),
                .init(parameterID: .hapticSharpness, value: sharpness),
            ],
            relativeTime: 0,
            duration: duration
        )
        if let pattern = try? CHHapticPattern(events: [event], parameters: []) {
            try? engine.makePlayer(with: pattern).start(atTime: 0)
        }
    }
}
