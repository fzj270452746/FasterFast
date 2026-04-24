//
//  ZenithHudOverlay.swift
//  FasterFast
//

import SpriteKit

final class HudOverlay: SKNode {

    private var scoreLabel: SKLabelNode!
    private var speedLabel: SKLabelNode!
    private var comboLabel: SKLabelNode!
    private var banner: SKLabelNode!
    private var dot: SKShapeNode!
    private var twoModeLabel: SKLabelNode!

    private var width: CGFloat = 375
    private var topInset: CGFloat = 44

    func setup(screenWidth: CGFloat, topInset: CGFloat) {
        self.width = screenWidth
        self.topInset = topInset
        zPosition = 100
        isUserInteractionEnabled = false

        buildScore()
        buildSpeed()
        buildCombo()
        buildBanner()
        buildDot()
        buildTwoModeLabel()
    }

    private func buildScore() {
        let fs = max(32, Layout.scaled(32, to: width))
        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreLabel.fontSize = fs
        scoreLabel.fontColor = Colors.darkText
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.position = CGPoint(x: width / 2, y: -topInset - 12)
        scoreLabel.text = "0"
        scoreLabel.zPosition = 101
        addChild(scoreLabel)
    }

    private func buildSpeed() {
        let fs = max(14, Layout.scaled(14, to: width))
        speedLabel = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
        speedLabel.fontSize = fs
        speedLabel.fontColor = Colors.caption
        speedLabel.horizontalAlignmentMode = .center
        speedLabel.verticalAlignmentMode = .top
        speedLabel.position = CGPoint(x: width / 2, y: scoreLabel.position.y - 40)
        speedLabel.text = "Speed: 1.0x"
        speedLabel.zPosition = 101
        addChild(speedLabel)
    }

    private func buildCombo() {
        let fs = max(18, Layout.scaled(18, to: width))
        comboLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        comboLabel.fontSize = fs
        comboLabel.fontColor = Colors.amber
        comboLabel.horizontalAlignmentMode = .center
        comboLabel.verticalAlignmentMode = .center
        comboLabel.position = CGPoint(x: width / 2, y: speedLabel.position.y - 30)
        comboLabel.text = ""
        comboLabel.alpha = 0
        comboLabel.zPosition = 101
        addChild(comboLabel)
    }

    private func buildBanner() {
        let fs = max(22, Layout.scaled(22, to: width))
        banner = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        banner.fontSize = fs
        banner.fontColor = Colors.lavender
        banner.horizontalAlignmentMode = .center
        banner.verticalAlignmentMode = .center
        banner.position = CGPoint(x: width / 2, y: speedLabel.position.y - 60)
        banner.text = ""
        banner.alpha = 0
        banner.zPosition = 102
        addChild(banner)
    }

    private func buildDot() {
        dot = SKShapeNode(circleOfRadius: 6)
        dot.fillColor = Colors.teal
        dot.strokeColor = .clear
        dot.position = CGPoint(x: width - 30, y: -topInset - 24)
        dot.alpha = 0
        dot.zPosition = 101
        addChild(dot)
    }

    private func buildTwoModeLabel() {
        let fs = max(20, Layout.scaled(20, to: width))
        twoModeLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        twoModeLabel.fontSize = fs
        twoModeLabel.fontColor = Colors.teal
        twoModeLabel.horizontalAlignmentMode = .center
        twoModeLabel.verticalAlignmentMode = .center
        twoModeLabel.position = CGPoint(x: width / 2, y: speedLabel.position.y - 50)
        twoModeLabel.text = ""
        twoModeLabel.alpha = 0
        twoModeLabel.zPosition = 101
        addChild(twoModeLabel)
    }

    // MARK: - Updates

    func updateScore(_ value: Int) {
        scoreLabel.text = "\(value)"
        scoreLabel.run(.sequence([.scale(to: 1.2, duration: 0.08), .scale(to: 1.0, duration: 0.08)]))
    }

    func updateSpeed(_ multiplier: CGFloat) {
        speedLabel.text = String(format: "Speed: %.1fx", multiplier)
    }

    func updateCombo(_ combo: Int) {
        if combo >= 3 {
            comboLabel.text = "COMBO x\(combo)"
            comboLabel.removeAllActions()
            comboLabel.alpha = 1.0
            comboLabel.run(.sequence([.scale(to: 1.3, duration: 0.1), .scale(to: 1.0, duration: 0.1)]))

            if Config.comboMilestones.contains(combo) {
                comboLabel.run(.sequence([
                    .run { [weak self] in self?.comboLabel.fontColor = Colors.coral },
                    .wait(forDuration: 0.3),
                    .run { [weak self] in self?.comboLabel.fontColor = Colors.amber }
                ]))
            }
        } else {
            comboLabel.run(.fadeOut(withDuration: 0.2))
        }
    }

    func showPowerUp(_ text: String, color: UIColor) {
        banner.text = text
        banner.fontColor = color
        banner.removeAllActions()
        banner.alpha = 0
        banner.setScale(0.5)
        banner.run(.sequence([
            .group([.fadeIn(withDuration: 0.3), .scale(to: 1.0, duration: 0.3)]),
            .wait(forDuration: 1.5),
            .fadeOut(withDuration: 0.3)
        ]))
    }

    func pulseDot(duration: TimeInterval) {
        dot.alpha = 1
        let pulse = SKAction.sequence([.scale(to: 1.5, duration: 0.3), .scale(to: 1.0, duration: 0.3)])
        let count = SKAction.repeat(pulse, count: Int(duration / 0.6))
        dot.run(.sequence([count, .fadeOut(withDuration: 0.2)]))
    }

    func updateTwoProgress(_ count: Int) {
        if count > 0 {
            twoModeLabel.text = "\(count)/2"
            twoModeLabel.alpha = 1.0
            twoModeLabel.run(.sequence([.scale(to: 1.3, duration: 0.1), .scale(to: 1.0, duration: 0.1)]))
        } else {
            twoModeLabel.alpha = 0
        }
    }

    func resetTwoProgress() {
        twoModeLabel.alpha = 0
    }

    func reset() {
        scoreLabel.text = "0"
        speedLabel.text = "Speed: 1.0x"
        comboLabel.alpha = 0
        banner.alpha = 0
        dot.alpha = 0
        twoModeLabel.alpha = 0
    }
}
