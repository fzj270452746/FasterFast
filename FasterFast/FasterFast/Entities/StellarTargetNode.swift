//
//  StellarTargetNode.swift
//  FasterFast
//

import SpriteKit

enum TargetKind {
    case circle     // correct
    case square     // wrong
    case blink      // appears briefly
    case mover      // wanders
    case spinner    // rotates
}

class TargetNode: SKSpriteNode {

    let kind: TargetKind
    private var r: CGFloat
    private var dead = false

    init(kind: TargetKind, radius: CGFloat) {
        self.kind = kind
        self.r = radius

        let name: String
        switch kind {
        case .circle:  name = Assets.circle
        case .square:  name = Assets.square
        case .blink:   name = Assets.blink
        case .mover:   name = Assets.moving
        case .spinner: name = Assets.spin
        }

        let d = radius * 2
        super.init(texture: SKTexture(imageNamed: name), color: .clear, size: CGSize(width: d, height: d))

        self.name = "target_\(kind)"
        isUserInteractionEnabled = false
        zPosition = 10

        setupBehavior()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private func setupBehavior() {
        switch kind {
        case .circle, .square, .mover:
            pop()
        case .blink:
            blinkLoop()
        case .spinner:
            pop()
            run(.repeatForever(.rotate(byAngle: Config.spinSpeed, duration: 1.0)), withKey: "spin")
        }
    }

    private func pop() {
        setScale(0.01)
        alpha = 0
        let grow = SKAction.scale(to: 1.0, duration: 0.25)
        grow.timingMode = .easeOut
        run(.group([grow, .fadeIn(withDuration: 0.25)]))
    }

    private func blinkLoop() {
        setScale(0.01)
        alpha = 0
        let appear = SKAction.group([.scale(to: 1.0, duration: 0.15), .fadeIn(withDuration: 0.15)])
        let hold = SKAction.wait(forDuration: Config.blinkDuration)
        let vanish = SKAction.group([.scale(to: 0.01, duration: 0.15), .fadeOut(withDuration: 0.15)])
        run(.repeatForever(.sequence([appear, hold, vanish, .wait(forDuration: 0.3)])), withKey: "blink")
    }

    func startWandering(in bounds: CGRect) {
        guard kind == .mover else { return }
        wander(in: bounds)
    }

    private func wander(in bounds: CGRect) {
        guard !dead else { return }
        let dest = CGPoint.random(in: bounds, margin: r)
        let d = position.distance(to: dest)
        let move = SKAction.move(to: dest, duration: TimeInterval(d / Config.moveSpeed))
        move.timingMode = .easeInEaseOut
        run(move) { [weak self] in self?.wander(in: bounds) }
    }

    func startChaos(in bounds: CGRect) {
        removeAction(forKey: "chaos")
        let step = SKAction.run { [weak self] in
            guard let self, !self.dead else { return }
            let move = SKAction.move(to: CGPoint.random(in: bounds, margin: self.r), duration: 0.4)
            move.timingMode = .easeInEaseOut
            self.run(move)
        }
        run(.repeatForever(.sequence([step, .wait(forDuration: 0.5)])), withKey: "chaos")
    }

    func stopChaos() {
        removeAction(forKey: "chaos")
    }

    func dismiss(completion: (() -> Void)? = nil) {
        dead = true
        removeAllActions()
        let shrink = SKAction.scale(to: 0.01, duration: 0.15)
        run(.group([shrink, .fadeOut(withDuration: 0.15)])) { [weak self] in
            self?.removeFromParent()
            completion?()
        }
    }

    func dismissWithError(completion: (() -> Void)? = nil) {
        dead = true
        removeAllActions()
        let shake = SKAction.sequence([
            .moveBy(x: -8, y: 0, duration: 0.05),
            .moveBy(x: 16, y: 0, duration: 0.05),
            .moveBy(x: -8, y: 0, duration: 0.05)
        ])
        let tint = SKAction.colorize(with: Colors.coral, colorBlendFactor: 0.8, duration: 0.1)
        let out = SKAction.group([.scale(to: 0.01, duration: 0.2), .fadeOut(withDuration: 0.2)])
        run(.sequence([.group([shake, tint]), out])) { [weak self] in
            self?.removeFromParent()
            completion?()
        }
    }

    func resize(to newRadius: CGFloat) {
        r = newRadius
        let d = newRadius * 2
        run(.resize(toWidth: d, height: d, duration: 0.2))
    }
}
