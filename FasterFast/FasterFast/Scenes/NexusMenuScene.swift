//
//  NexusMenuScene.swift
//  FasterFast
//

import SpriteKit

protocol MenuDelegate: AnyObject {
    func menuDidPlay(mode: GameMode)
}

final class MenuScene: SKScene {

    weak var delegate_: MenuDelegate?

    private var titleLabel: SKLabelNode!
    private var playButton: SKNode!
    private var modeButton: SKNode!
    private var howToButton: SKNode!
    private var settingsButton: SKNode!
    private var bestLabel: SKLabelNode!
    private var currentMode: GameMode = .single

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        anchorPoint = CGPoint(x: 0, y: 1)
        loadMode()
        buildBackground()
        buildOrbs()
        buildLayout()
        animateIn()
    }

    private func loadMode() {
        let saved = UserDefaults.standard.string(forKey: Keys.gameMode) ?? "single"
        currentMode = saved == "two" ? .two : .single
    }

    private func saveMode() {
        UserDefaults.standard.set(currentMode == .two ? "two" : "single", forKey: Keys.gameMode)
    }

    private func buildBackground() {
        let img = UIColor.gradientImage(top: Colors.bgTop, bottom: Colors.bgBottom, size: size)
        let bg = SKSpriteNode(texture: SKTexture(image: img), size: size)
        bg.anchorPoint = CGPoint(x: 0, y: 1)
        bg.position = .zero
        bg.zPosition = -10
        addChild(bg)
    }

    private func buildOrbs() {
        let palette: [UIColor] = [
            Colors.teal.withAlphaComponent(0.12),
            Colors.lavender.withAlphaComponent(0.10),
            Colors.amber.withAlphaComponent(0.08),
            Colors.sky.withAlphaComponent(0.10),
            Colors.mint.withAlphaComponent(0.08)
        ]
        for i in 0..<5 {
            let orb = SKShapeNode(circleOfRadius: CGFloat.random(in: 40...90))
            orb.fillColor = palette[i % palette.count]
            orb.strokeColor = .clear
            orb.position = CGPoint(x: CGFloat.random(in: 0...size.width), y: -CGFloat.random(in: 0...size.height))
            orb.zPosition = -5
            orb.alpha = 0.6
            addChild(orb)

            let dx = CGFloat.random(in: -40...40)
            let dy = CGFloat.random(in: -40...40)
            let drift = SKAction.moveBy(x: dx, y: dy, duration: .random(in: 4...7))
            orb.run(.repeatForever(.sequence([drift, drift.reversed()])))
        }
    }

    private func buildLayout() {
        let s = size.width / Layout.referenceWidth
        let cx = size.width / 2
        let topInset = view?.safeAreaInsets.top ?? 44

        titleLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        titleLabel.text = "Faster &\nFaster"
        titleLabel.numberOfLines = 2
        titleLabel.fontSize = max(42, (42 * s).rounded())
        titleLabel.fontColor = Colors.darkText
        titleLabel.horizontalAlignmentMode = .center
        titleLabel.verticalAlignmentMode = .center
        titleLabel.position = CGPoint(x: cx, y: -(topInset + size.height * 0.22))
        titleLabel.zPosition = 10
        addChild(titleLabel)

        let sub = SKLabelNode(fontNamed: "AvenirNext-Medium")
        sub.text = "How fast can you go?"
        sub.fontSize = max(16, (16 * s).rounded())
        sub.fontColor = Colors.caption
        sub.horizontalAlignmentMode = .center
        let titleLineH = titleLabel.fontSize * 1.2
        sub.position = CGPoint(x: cx, y: titleLabel.position.y - titleLineH - 20 * s)
        sub.zPosition = 10
        addChild(sub)

        let best = Store.shared.bestScore
        bestLabel = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
        bestLabel.text = best > 0 ? "Best: \(best)" : ""
        bestLabel.fontSize = max(14, (14 * s).rounded())
        bestLabel.fontColor = Colors.lavender
        bestLabel.horizontalAlignmentMode = .center
        bestLabel.position = CGPoint(x: cx, y: sub.position.y - 30 * s)
        bestLabel.zPosition = 10
        addChild(bestLabel)

        let bw = min(220, size.width * 0.58)
        let bh = 56 * s

        playButton = pillButton("PLAY", width: bw, height: bh, color: Colors.teal, fontSize: max(20, (20 * s).rounded()))
        playButton.position = CGPoint(x: cx, y: -(size.height * 0.60))
        playButton.name = "play"
        playButton.zPosition = 20
        addChild(playButton)

        modeButton = modeToggle(width: min(220, size.width * 0.58), height: 50 * s, scale: s)
        modeButton.position = CGPoint(x: cx, y: playButton.position.y - 70 * s)
        modeButton.name = "mode"
        modeButton.zPosition = 20
        addChild(modeButton)

        howToButton = outlineButton("How to Play", width: min(220, size.width * 0.58), height: 50 * s, color: Colors.sky, scale: s)
        howToButton.position = CGPoint(x: cx, y: modeButton.position.y - 65 * s)
        howToButton.name = "howto"
        howToButton.zPosition = 20
        addChild(howToButton)

        let botInset = view?.safeAreaInsets.bottom ?? 34
        settingsButton = settingsBtn(scale: s)
        settingsButton.position = CGPoint(x: cx, y: -(size.height - botInset - 40 * s))
        settingsButton.name = "settings"
        settingsButton.zPosition = 20
        addChild(settingsButton)
    }

    private func pillButton(_ text: String, width: CGFloat, height: CGFloat, color: UIColor, fontSize: CGFloat) -> SKNode {
        let n = SKNode()

        let shadow = SKShapeNode(rect: CGRect(x: -width / 2, y: -height / 2 - 3, width: width, height: height), cornerRadius: height / 2)
        shadow.fillColor = color.withAlphaComponent(0.3)
        shadow.strokeColor = .clear
        n.addChild(shadow)

        let pill = SKShapeNode(rect: CGRect(x: -width / 2, y: -height / 2, width: width, height: height), cornerRadius: height / 2)
        pill.fillColor = color
        pill.strokeColor = .clear
        pill.name = "play"
        n.addChild(pill)

        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.text = text
        label.fontSize = fontSize
        label.fontColor = .white
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: 0, y: -2)
        label.name = "play"
        n.addChild(label)

        n.run(.repeatForever(.sequence([.scale(to: 1.03, duration: 1.2), .scale(to: 1.0, duration: 1.2)])))
        return n
    }

    private func outlineButton(_ text: String, width: CGFloat, height: CGFloat, color: UIColor, scale: CGFloat) -> SKNode {
        let n = SKNode()
        let bg = SKShapeNode(rect: CGRect(x: -width / 2, y: -height / 2, width: width, height: height), cornerRadius: height / 2)
        bg.fillColor = color.withAlphaComponent(0.2)
        bg.strokeColor = color.withAlphaComponent(0.5)
        bg.lineWidth = 2
        n.addChild(bg)

        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.text = text
        label.fontSize = max(16, (16 * scale).rounded())
        label.fontColor = color
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        n.addChild(label)

        return n
    }

    private func modeToggle(width: CGFloat, height: CGFloat, scale: CGFloat) -> SKNode {
        let n = SKNode()
        let bg = SKShapeNode(rect: CGRect(x: -width / 2, y: -height / 2, width: width, height: height), cornerRadius: height / 2)
        bg.fillColor = Colors.lavender.withAlphaComponent(0.2)
        bg.strokeColor = Colors.lavender.withAlphaComponent(0.5)
        bg.lineWidth = 2
        bg.name = "mode"
        n.addChild(bg)

        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")
        label.text = currentMode == .single ? "Single Tap" : "Double Tap"
        label.fontSize = max(16, (16 * scale).rounded())
        label.fontColor = Colors.lavender
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.name = "mode"
        n.addChild(label)

        return n
    }

    private func settingsBtn(scale: CGFloat) -> SKNode {
        let n = SKNode()
        let w: CGFloat = 148 * scale
        let h: CGFloat = 40 * scale
        let r = h / 2

        let glow = SKShapeNode(rect: CGRect(x: -w / 2 - 5, y: -h / 2 - 5, width: w + 10, height: h + 10), cornerRadius: r + 5)
        glow.fillColor = Colors.lavender.withAlphaComponent(0.14)
        glow.strokeColor = .clear
        n.addChild(glow)

        let pill = SKShapeNode(rect: CGRect(x: -w / 2, y: -h / 2, width: w, height: h), cornerRadius: r)
        pill.fillColor = UIColor(white: 1.0, alpha: 0.09)
        pill.strokeColor = UIColor(white: 1.0, alpha: 0.30)
        pill.lineWidth = 1.2
        n.addChild(pill)

        let badge = SKShapeNode(circleOfRadius: r - 4)
        badge.fillColor = Colors.lavender.withAlphaComponent(0.55)
        badge.strokeColor = .clear
        badge.position = CGPoint(x: -w / 2 + r, y: 0)
        n.addChild(badge)

        let iconSize = (r - 4) * 1.4
        if let img = UIImage(systemName: "gearshape.fill")?
            .withTintColor(.white, renderingMode: .alwaysOriginal) {
            let tex = SKTexture(image: img)
            let icon = SKSpriteNode(texture: tex, size: CGSize(width: iconSize, height: iconSize))
            icon.position = CGPoint(x: -w / 2 + r, y: 0)
            icon.name = "settings"
            n.addChild(icon)
        }

        let txt = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
        txt.text = "SETTINGS"
        txt.fontSize = max(13, (13 * scale).rounded())
        txt.fontColor = UIColor(white: 1.0, alpha: 0.70)
        txt.horizontalAlignmentMode = .center
        txt.verticalAlignmentMode = .center
        txt.position = CGPoint(x: r + 2, y: -1)
        txt.name = "settings"
        n.addChild(txt)

        n.run(.repeatForever(.sequence([.fadeAlpha(to: 0.75, duration: 1.8), .fadeAlpha(to: 1.0, duration: 1.8)])))
        return n
    }

    private func refreshModeButton() {
        for child in modeButton.children {
            if let l = child as? SKLabelNode {
                l.text = currentMode == .single ? "Single Tap" : "Double Tap"
            }
        }
    }

    private func animateIn() {
        titleLabel.alpha = 0
        titleLabel.position.y += 30
        [playButton, modeButton, howToButton, settingsButton].forEach {
            $0?.alpha = 0
            $0?.setScale(0.8)
        }

        titleLabel.run(.sequence([.wait(forDuration: 0.1), .group([.fadeIn(withDuration: 0.4), .moveBy(x: 0, y: -30, duration: 0.4)])]))
        playButton.run(.sequence([.wait(forDuration: 0.5), .group([.fadeIn(withDuration: 0.4), .scale(to: 1.0, duration: 0.4)])]))
        modeButton.run(.sequence([.wait(forDuration: 0.65), .group([.fadeIn(withDuration: 0.4), .scale(to: 1.0, duration: 0.4)])]))
        howToButton.run(.sequence([.wait(forDuration: 0.8), .group([.fadeIn(withDuration: 0.4), .scale(to: 1.0, duration: 0.4)])]))
        settingsButton.run(.sequence([.wait(forDuration: 0.95), .fadeIn(withDuration: 0.3)]))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let hit = nodes(at: touch.location(in: self))

        for node in hit {
            switch node.name {
            case "play":
                tapButton(playButton) { [weak self] in
                    self?.delegate_?.menuDidPlay(mode: self?.currentMode ?? .single)
                }
                return
            case "mode":
                currentMode = currentMode == .single ? .two : .single
                saveMode()
                refreshModeButton()
                Audio.shared.hapticLight()
                return
            case "howto":
                showHowTo()
                return
            case "settings":
                showSettings()
                return
            default:
                break
            }
        }
    }

    private func tapButton(_ node: SKNode, completion: @escaping () -> Void) {
        Audio.shared.hapticLight()
        node.run(.sequence([.scale(to: 0.93, duration: 0.08), .scale(to: 1.0, duration: 0.08)])) {
            completion()
        }
    }

    private func showSettings() {
        let audio = Audio.shared
        let dialog = DialogNode()
        dialog.show(in: self, title: "Settings", buttons: [
            DialogButton("Sound: \(audio.isSoundOn ? "ON" : "OFF")", color: Colors.sky, dismiss: true) { [weak self] in
                audio.setSound(!audio.isSoundOn)
                self?.showSettings()
            },
            DialogButton("Haptic: \(audio.isHapticOn ? "ON" : "OFF")", color: Colors.lavender, dismiss: true) { [weak self] in
                audio.setHaptic(!audio.isHapticOn)
                self?.showSettings()
            },
            DialogButton("Close", color: Colors.caption) {}
        ])
    }

    private func showHowTo() {
        let body = """
Game Objective
Tap the circles as fast as you can!
Avoid the squares - they end the game

Game Modes
- Single Tap: Tap 1 circle per round
- Double Tap: Tap 2 circles per round

Special Targets
- Blinking: Appears and disappears
- Moving: Wanders around the screen
- Spinning: Rotates continuously

Power-Ups
- SLOW MOTION: Everything slows down
- SCORE x2: Double points for 2 seconds
- CHAOS: All targets move randomly

Tips
- Speed increases as you score
- Build combos for bonus points
"""
        let dialog = DialogNode()
        dialog.show(in: self, title: "How to Play", body: body, buttons: [
            DialogButton("Got it!", color: Colors.teal) {}
        ])
    }
}
