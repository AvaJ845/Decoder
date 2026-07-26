import SpriteKit

/// Sprint 0 feasibility spike (build doc sprint plan, Sprint 0): can SpriteKit drive a
/// steady rhythm loop with word cards streaming down lanes, and is tap→beat timing
/// tight enough for a fluency game? This scene spawns cards on a fixed beat and logs
/// the offset between a tap and the nearest beat. Answers the "is the loop feasible?"
/// question before any art or engine work.
final class RhythmSpikeScene: SKScene {
    private let bpm: Double = 90
    private var beatInterval: TimeInterval { 60.0 / bpm }
    private var lastBeat: TimeInterval = 0
    private var beatIndex = 0

    /// Reported for the spike: absolute tap-to-nearest-beat offsets (seconds).
    private(set) var tapOffsets: [TimeInterval] = []

    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.965, green: 0.957, blue: 0.925, alpha: 1) // ground #F7F4EC
    }

    override func update(_ currentTime: TimeInterval) {
        if lastBeat == 0 { lastBeat = currentTime }
        if currentTime - lastBeat >= beatInterval {
            lastBeat += beatInterval
            beatIndex += 1
            spawnCard()
        }
    }

    private func spawnCard() {
        let card = SKShapeNode(rectOf: CGSize(width: 120, height: 72), cornerRadius: 14)
        card.fillColor = SKColor(red: 1.0, green: 0.992, blue: 0.969, alpha: 1) // surface #FFFDF7
        card.strokeColor = SKColor(red: 0.165, green: 0.616, blue: 0.561, alpha: 1) // teal
        card.lineWidth = 4
        let lane = CGFloat(beatIndex % 3)
        card.position = CGPoint(x: size.width * (0.25 + 0.25 * lane), y: size.height + 40)
        card.run(.sequence([
            .moveTo(y: -40, duration: 2.4),
            .removeFromParent(),
        ]))
        addChild(card)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let t = touches.first else { return }
        let now = t.timestamp
        let phase = (now - lastBeat).truncatingRemainder(dividingBy: beatInterval)
        let offset = min(phase, beatInterval - phase) // distance to nearest beat
        tapOffsets.append(offset)
    }
}
