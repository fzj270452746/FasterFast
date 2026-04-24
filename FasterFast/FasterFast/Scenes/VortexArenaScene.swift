//
//  VortexArenaScene.swift
//  FasterFast
//

import SpriteKit

protocol ArenaDelegate: AnyObject {
    func arenaDidEnd(score: Int, newBest: Bool)
}

final class ArenaScene: SKScene {

    weak var delegate_: ArenaDelegate?

    private let escalator = Escalator()
    private var hud: HudOverlay!
    private var targets: [TargetNode] = []
    private var spawnTimer: Timer?
    private var countdownTimer: Timer?
    private var timeLeft: TimeInterval = 0
    private var running = false
    private var paused_ = false

    private var mode: GameMode = .single
    private var tappedThisRound: Set<TargetNode> = []

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        anchorPoint = CGPoint(x: 0, y: 1)
        backgroundColor = .white
        escalator.setMode(mode)
        buildBackground()
        buildParticles()
        buildHud()
        startSession()
    }

    func setMode(_ m: GameMode) {
        mode = m
    }

    override func willMove(from view: SKView) {
        super.willMove(from: view)
        stopTimers()
    }

    private func buildBackground() {
        let img = UIColor.gradientImage(top: Colors.bgTop, bottom: Colors.bgBottom, size: size)
        let bg = SKSpriteNode(texture: SKTexture(image: img), size: size)
        bg.anchorPoint = CGPoint(x: 0, y: 1)
        bg.position = .zero
        bg.zPosition = -10
        addChild(bg)
    }

    private func buildParticles() {
        let layer = SKNode()
        layer.zPosition = -5
        addChild(layer)

        for _ in 0..<8 {
            let dot = SKShapeNode(circleOfRadius: CGFloat.random(in: 2...5))
            dot.fillColor = Colors.sky.withAlphaComponent(0.2)
            dot.strokeColor = .clear
            dot.position = CGPoint(x: CGFloat.random(in: 0...size.width), y: CGFloat.random(in: -size.height...0))
            layer.addChild(dot)

            let drift = SKAction.moveBy(x: CGFloat.random(in: -30...30), y: CGFloat.random(in: 20...60), duration: .random(in: 3...6))
            let fade = SKAction.sequence([.fadeAlpha(to: 0.4, duration: 2), .fadeAlpha(to: 0.1, duration: 2)])
            dot.run(.repeatForever(.group([drift, fade, .sequence([drift.reversed(), fade.reversed()])])))
        }
    }

    private func buildHud() {
        hud = HudOverlay()
        hud.setup(screenWidth: size.width, topInset: view?.safeAreaInsets.top ?? 44)
        hud.position = .zero
        addChild(hud)
    }

    func startSession() {
        escalator.reset()
        removeAllTargets()
        hud.reset()
        running = true
        paused_ = false
        scheduleWave()
    }

    private func scheduleWave() {
        stopTimers()

        let interval = escalator.spawnInterval
        timeLeft = interval

        spawnTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            guard let self, self.running else { return }
            self.onTimeout()
        }
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.timeLeft -= 0.1
        }

        spawnWave()
    }

    private func spawnWave() {
        removeAllTargets()
        tappedThisRound.removeAll()

        let snap = escalator.snapshot()
        let area = playRegion()

        if mode == .single {
            let correct = TargetNode(kind: .circle, radius: snap.radius)
            correct.position = CGPoint.random(in: area, margin: snap.radius)
            addChild(correct)
            targets.append(correct)

            var placed = [correct.position]
            for i in 0..<(snap.targetCount - 1) {
                let t = spawnDecoy(index: i, snap: snap, area: area, placed: &placed)
                targets.append(t)
            }
        } else {
            var placed: [CGPoint] = []

            let c1 = TargetNode(kind: .circle, radius: snap.radius)
            c1.position = CGPoint.random(in: area, margin: snap.radius)
            addChild(c1)
            targets.append(c1)
            placed.append(c1.position)

            let c2 = TargetNode(kind: .circle, radius: snap.radius)
            var pos2: CGPoint
            var tries = 0
            let minDist = snap.radius * TwoMode.minDistance
            repeat {
                pos2 = CGPoint.random(in: area, margin: snap.radius)
                tries += 1
            } while placed.contains(where: { $0.distance(to: pos2) < minDist }) && tries < 30
            c2.position = pos2
            addChild(c2)
            targets.append(c2)
            placed.append(pos2)

            for i in 0..<(snap.targetCount - 1) {
                let t = spawnDecoy(index: i, snap: snap, area: area, placed: &placed)
                targets.append(t)
            }
        }

        if escalator.chaos {
            for t in targets { t.startChaos(in: area) }
        }
    }

    @discardableResult
    private func spawnDecoy(index: Int, snap: Snapshot, area: CGRect, placed: inout [CGPoint]) -> TargetNode {
        var pool: [TargetKind] = [.square]
        if snap.hasBlinkers { pool.append(.blink) }
        if snap.hasMovers { pool.append(.mover) }
        if snap.hasSpinners { pool.append(.spinner) }

        let kind = pool.randomElement() ?? .square
        let node = TargetNode(kind: kind, radius: snap.radius)

        var pos: CGPoint
        var tries = 0
        repeat {
            pos = CGPoint.random(in: area, margin: snap.radius)
            tries += 1
        } while placed.contains(where: { $0.distance(to: pos) < snap.radius * 2.5 }) && tries < 20

        node.position = pos
        placed.append(pos)
        addChild(node)

        if kind == .mover { node.startWandering(in: area) }
        return node
    }

    private func playRegion() -> CGRect {
        let top = view?.safeAreaInsets.top ?? 44
        let bot = view?.safeAreaInsets.bottom ?? 34
        let m: CGFloat = 20
        let hh: CGFloat = 100
        return CGRect(x: m, y: -(size.height - bot - m), width: size.width - m * 2, height: size.height - top - bot - hh - m * 2)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard running, !paused_, let touch = touches.first else { return }
        let loc = touch.location(in: self)
        if let hit = targets.first(where: { $0.frame.contains(loc) }) {
            onTap(hit)
        } else {
            onMiss(.empty)
        }
    }

    private func onTap(_ target: TargetNode) {
        switch target.kind {
        case .circle:
            mode == .single ? onCorrect(target) : onTwoCorrect(target)
        default:
            onMiss(.wrong(target))
        }
    }

    private func onTwoCorrect(_ target: TargetNode) {
        guard !tappedThisRound.contains(target) else { return }
        tappedThisRound.insert(target)
        target.alpha = 0.5
        Audio.shared.tap()
        Audio.shared.hapticLight()
        hud.updateTwoProgress(tappedThisRound.count)

        if tappedThisRound.count >= 2 {
            finishTwoRound()
        }
    }

    private func finishTwoRound() {
        let result = escalator.hit()

        for t in tappedThisRound {
            t.dismiss()
            targets.removeAll { $0 === t }
        }
        for t in targets { t.dismiss() }
        targets.removeAll()
        tappedThisRound.removeAll()

        Audio.shared.hapticMedium()
        hud.updateScore(result.score)
        hud.updateSpeed(escalator.speedMultiplier)
        hud.updateCombo(escalator.streak)
        hud.resetTwoProgress()

        if let p = escalator.rollPowerUp() { triggerPowerUp(p) }
        scheduleWave()
    }

    private func onCorrect(_ target: TargetNode) {
        let result = escalator.hit()
        target.dismiss()
        targets.removeAll { $0 === target }

        Audio.shared.tap()
        Audio.shared.hapticLight()
        ripple(at: target.position, color: Colors.mint)

        hud.updateScore(result.score)
        hud.updateSpeed(escalator.speedMultiplier)
        hud.updateCombo(escalator.streak)

        if result.bonus > 0 { Audio.shared.hapticMedium() }
        if let p = escalator.rollPowerUp() { triggerPowerUp(p) }
        scheduleWave()
    }

    private enum MissReason {
        case empty
        case wrong(TargetNode)
        case timeout
    }

    private func onMiss(_ reason: MissReason) {
        running = false
        stopTimers()

        Audio.shared.error()
        Audio.shared.hapticFail()

        switch reason {
        case .wrong(let t): t.dismissWithError()
        case .empty, .timeout: flash()
        }

        for t in targets { t.dismiss() }
        targets.removeAll()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            self?.endSession()
        }
    }

    private func onTimeout() {
        guard running else { return }
        onMiss(.timeout)
    }

    private func triggerPowerUp(_ p: PowerUp) {
        escalator.activate(p)

        let color: UIColor
        let dur: TimeInterval
        switch p {
        case .slow:
            color = Colors.sky
            dur = Config.slowDuration
        case .double:
            color = Colors.amber
            dur = Config.slowDuration
        case .chaos:
            color = Colors.coral
            dur = Config.chaosDuration
            let area = playRegion()
            for t in targets { t.startChaos(in: area) }
        }

        hud.showPowerUp(p.rawValue, color: color)
        hud.pulseDot(duration: dur)

        DispatchQueue.main.asyncAfter(deadline: .now() + dur) { [weak self] in
            guard let self else { return }
            self.escalator.deactivate(p)
            if p == .chaos { self.targets.forEach { $0.stopChaos() } }
        }
    }

    private func ripple(at pos: CGPoint, color: UIColor) {
        let r = SKShapeNode(circleOfRadius: 5)
        r.fillColor = color.withAlphaComponent(0.5)
        r.strokeColor = color.withAlphaComponent(0.3)
        r.lineWidth = 2
        r.position = pos
        r.zPosition = 50
        addChild(r)

        let expand = SKAction.scale(to: 4.0, duration: 0.4)
        expand.timingMode = .easeOut
        r.run(.group([expand, .fadeOut(withDuration: 0.4)])) { r.removeFromParent() }
    }

    private func flash() {
        let f = SKShapeNode(rectOf: size)
        f.position = CGPoint(x: size.width / 2, y: -size.height / 2)
        f.fillColor = Colors.coral.withAlphaComponent(0.3)
        f.strokeColor = .clear
        f.zPosition = 200
        f.alpha = 0
        addChild(f)
        f.run(.sequence([.fadeIn(withDuration: 0.05), .fadeOut(withDuration: 0.3), .removeFromParent()]))
    }

    private func endSession() {
        escalator.miss()
        let final = escalator.score
        let isNew = Store.shared.submit(score: final)
        Store.shared.incrementPlays()
        delegate_?.arenaDidEnd(score: final, newBest: isNew)
    }

    private func removeAllTargets() {
        for t in targets {
            t.removeAllActions()
            t.removeFromParent()
        }
        targets.removeAll()
    }

    private func stopTimers() {
        spawnTimer?.invalidate(); spawnTimer = nil
        countdownTimer?.invalidate(); countdownTimer = nil
    }

    func pause_() {
        guard running else { return }
        paused_ = true
        isPaused = true
        stopTimers()
    }

    func resume_() {
        guard running else { return }
        paused_ = false
        isPaused = false
        scheduleWave()
    }
}
