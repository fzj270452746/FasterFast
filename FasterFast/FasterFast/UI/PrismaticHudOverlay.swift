//
//  PrismaticHudOverlay.swift
//  FasterFast
//

import SpriteKit

// NOTE: This class is unused now that ZenithHudOverlay covers all modes.
// Keeping around in case we revisit the layout split.
final class PrismaticHudOverlay: SKNode {

    private var scoreLabel: SKLabelNode!
    private var speedLabel: SKLabelNode!
    private var comboLabel: SKLabelNode!
    private var banner: SKLabelNode!
    private var timerRing: SKShapeNode!

    private let sceneSize: CGSize
    private let insets: UIEdgeInsets

    init(size: CGSize, insets: UIEdgeInsets) {
        self.sceneSize = size
        self.insets = insets
        super.init()
        zPosition = 100
        build()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private func build() {
        let s = sceneSize.width / Layout.referenceWidth

        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreLabel.fontSize = (32 * s).rounded()
        scoreLabel.fontColor = Colors.darkText
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.position = CGPoint(x: sceneSize.width / 2, y: sceneSize.height - insets.top - 16 * s)
        scoreLabel.text = "0"
        addChild(scoreLabel)

        let caption = SKLabelNode(fontNamed: "AvenirNext-Medium")
        caption.fontSize = (12 * s).rounded()
        caption.fontColor = Colors.caption
        caption.horizontalAlignmentMode = .center
        caption.verticalAlignmentMode = .top
        caption.position = CGPoint(x: sceneSize.width / 2, y: scoreLabel.position.y - scoreLabel.fontSize - 4 * s)
        caption.text = "SCORE"
        addChild(caption)

        speedLabel = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
        speedLabel.fontSize = (16 * s).rounded()
        speedLabel.fontColor = Colors.lavender
        speedLabel.horizontalAlignmentMode = .right
        speedLabel.verticalAlignmentMode = .top
        speedLabel.position = CGPoint(x: sceneSize.width - 20 * s, y: sceneSize.height - insets.top - 20 * s)
        speedLabel.text = "1.0x"
        addChild(speedLabel)

        comboLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        comboLabel.fontSize = (18 * s).rounded()
        comboLabel.fontColor = Colors.amber
        comboLabel.horizontalAlignmentMode = .left
        comboLabel.verticalAlignmentMode = .top
        comboLabel.position = CGPoint(x: 20 * s, y: sceneSize.height - insets.top - 20 * s)
        comboLabel.text = ""
        comboLabel.alpha = 0
        addChild(comboLabel)

        banner = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        banner.fontSize = (28 * s).rounded()
        banner.fontColor = Colors.coral
        banner.horizontalAlignmentMode = .center
        banner.verticalAlignmentMode = .center
        banner.position = CGPoint(x: sceneSize.width / 2, y: sceneSize.height * 0.75)
        banner.alpha = 0
        banner.zPosition = 150
        addChild(banner)

        timerRing = SKShapeNode(circleOfRadius: 30 * s)
        timerRing.strokeColor = Colors.teal
        timerRing.lineWidth = 3 * s
        timerRing.fillColor = .clear
        timerRing.position = CGPoint(x: sceneSize.width / 2, y: insets.bottom + 60 * s)
        timerRing.alpha = 0
        addChild(timerRing)
    }

    func updateScore(_ score: Int) {
        scoreLabel.text = "\(score)"
        scoreLabel.run(.sequence([.scale(to: 1.2, duration: 0.08), .scale(to: 1.0, duration: 0.08)]))
    }

    func updateSpeed(_ multiplier: CGFloat) {
        speedLabel.text = String(format: "%.1fx", multiplier)
    }

    func updateCombo(_ count: Int) {
        if count >= 3 {
            comboLabel.text = "\(count) COMBO"
            if comboLabel.alpha < 1 { comboLabel.run(.fadeIn(withDuration: 0.15)) }
            comboLabel.run(.sequence([.scale(to: 1.3, duration: 0.06), .scale(to: 1.0, duration: 0.06)]))
        } else {
            comboLabel.run(.fadeOut(withDuration: 0.15))
        }
    }

    func showBanner(_ text: String, color: UIColor) {
        banner.text = text
        banner.fontColor = color
        banner.alpha = 0
        banner.setScale(0.5)
        banner.run(.sequence([
            .group([.fadeIn(withDuration: 0.2), .scale(to: 1.2, duration: 0.2)]),
            .scale(to: 1.0, duration: 0.1),
            .wait(forDuration: 1.0),
            .fadeOut(withDuration: 0.5)
        ]))
    }

    func startTimer(duration: TimeInterval) {
        timerRing.alpha = 1
        let s = sceneSize.width / Layout.referenceWidth
        let r: CGFloat = 30 * s
        let animate = SKAction.customAction(withDuration: duration) { [weak self] node, elapsed in
            guard let ring = self?.timerRing else { return }
            let progress = elapsed / CGFloat(duration)
            let end = CGFloat.pi / 2 + (1 - progress) * CGFloat.pi * 2
            ring.path = UIBezierPath(arcCenter: .zero, radius: r, startAngle: .pi / 2, endAngle: end, clockwise: true).cgPath
        }
        timerRing.run(.sequence([animate, .fadeOut(withDuration: 0.2)]))
    }

    func bonusPop(_ value: Int) {
        let s = sceneSize.width / Layout.referenceWidth
        let label = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        label.fontSize = (24 * s).rounded()
        label.fontColor = Colors.amber
        label.text = "+\(value)"
        label.position = CGPoint(x: sceneSize.width / 2, y: sceneSize.height * 0.6)
        label.zPosition = 120
        addChild(label)
        label.run(.group([.moveBy(x: 0, y: 60 * s, duration: 0.8), .fadeOut(withDuration: 0.8)])) {
            label.removeFromParent()
        }
    }
}
