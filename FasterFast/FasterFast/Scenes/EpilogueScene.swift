//
//  EpilogueScene.swift
//  FasterFast
//

import SpriteKit

protocol ResultDelegate: AnyObject {
    func didTapReplay()
    func didTapMenu()
}

final class ResultScene: SKScene {

    weak var delegate_: ResultDelegate?

    var finalScore: Int = 0
    var newBest: Bool = false

    private var scoreLabel: SKLabelNode!
    private var badge: SKLabelNode?

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        anchorPoint = CGPoint(x: 0, y: 1)
        buildBackground()
        buildLayout()
        animateIn()
    }

    private func buildBackground() {
        let img = UIColor.gradientImage(
            top: Colors.bgTop,
            bottom: UIColor(red: 0.92, green: 0.88, blue: 0.96, alpha: 1.0),
            size: size
        )
        let bg = SKSpriteNode(texture: SKTexture(image: img), size: size)
        bg.anchorPoint = CGPoint(x: 0, y: 1)
        bg.position = .zero
        bg.zPosition = -10
        addChild(bg)
    }

    private func buildLayout() {
        let s = size.width / Layout.referenceWidth
        let cx = size.width / 2
        let top = view?.safeAreaInsets.top ?? 44

        let title = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        title.text = "Game Over"
        title.fontSize = max(36, (36 * s).rounded())
        title.fontColor = .white
        title.horizontalAlignmentMode = .center
        title.verticalAlignmentMode = .center
        title.position = CGPoint(x: cx, y: -(top + size.height * 0.18))
        title.zPosition = 10
        title.name = "title"
        addChild(title)

        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreLabel.text = "\(finalScore)"
        scoreLabel.fontSize = max(72, (72 * s).rounded())
        scoreLabel.fontColor = Colors.teal
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: cx, y: -(size.height * 0.35))
        scoreLabel.zPosition = 10
        addChild(scoreLabel)

        let caption = SKLabelNode(fontNamed: "AvenirNext-Medium")
        caption.text = "SCORE"
        caption.fontSize = max(14, (14 * s).rounded())
        caption.fontColor = Colors.caption
        caption.horizontalAlignmentMode = .center
        caption.position = CGPoint(x: cx, y: scoreLabel.position.y - 50 * s)
        caption.zPosition = 10
        addChild(caption)

        if newBest {
            let b = SKLabelNode(fontNamed: "AvenirNext-Heavy")
            b.text = "NEW BEST!"
            b.fontSize = max(18, (18 * s).rounded())
            b.fontColor = Colors.amber
            b.horizontalAlignmentMode = .center
            b.verticalAlignmentMode = .center
            b.position = CGPoint(x: cx, y: scoreLabel.position.y + 50 * s)
            b.zPosition = 10
            addChild(b)
            badge = b
        }

        let bestLabel = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
        bestLabel.text = "Best: \(Store.shared.bestScore)"
        bestLabel.fontSize = max(16, (16 * s).rounded())
        bestLabel.fontColor = Colors.lavender
        bestLabel.horizontalAlignmentMode = .center
        bestLabel.position = CGPoint(x: cx, y: caption.position.y - 35 * s)
        bestLabel.zPosition = 10
        addChild(bestLabel)

        let bw = min(220, size.width * 0.58)
        let bh = 52 * s

        let replay = pillButton("PLAY AGAIN", width: bw, height: bh, color: Colors.teal, fontSize: max(18, (18 * s).rounded()))
        replay.position = CGPoint(x: cx, y: -(size.height * 0.68))
        replay.name = "replay"
        replay.zPosition = 20
        addChild(replay)

        let menu = pillButton("MENU", width: bw, height: bh, color: Colors.lavender, fontSize: max(18, (18 * s).rounded()))
        menu.position = CGPoint(x: cx, y: replay.position.y - bh - 16 * s)
        menu.name = "menu"
        menu.zPosition = 20
        addChild(menu)
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
        n.addChild(pill)

        let label = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
        label.text = text
        label.fontSize = fontSize
        label.fontColor = .white
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: 0, y: -2)
        n.addChild(label)

        return n
    }

    private func animateIn() {
        children.filter { $0.name != "title" }.forEach { $0.alpha = 0 }

        scoreLabel.alpha = 1
        let dur = min(1.0, Double(finalScore) * 0.03)
        if dur > 0 {
            scoreLabel.run(.customAction(withDuration: dur) { [weak self] _, elapsed in
                guard let self else { return }
                let t = min(elapsed / CGFloat(dur), 1.0)
                self.scoreLabel.text = "\(Int(CGFloat(self.finalScore) * t))"
            })
        }

        children.filter { $0 !== scoreLabel && $0.name != "title" && $0.zPosition >= 0 }.forEach {
            $0.run(.sequence([.wait(forDuration: 0.4), .fadeIn(withDuration: 0.4)]))
        }

        if let b = badge {
            b.alpha = 0
            b.setScale(0.5)
            b.run(.sequence([
                .wait(forDuration: dur + 0.2),
                .group([.fadeIn(withDuration: 0.3), .scale(to: 1.0, duration: 0.3)]),
                .repeatForever(.sequence([.scale(to: 1.08, duration: 0.6), .scale(to: 1.0, duration: 0.6)]))
            ]))
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let hit = nodes(at: touch.location(in: self))

        for node in hit {
            if ancestor(of: node, named: "replay") {
                tapButton(parent(of: node, named: "replay")) { [weak self] in self?.delegate_?.didTapReplay() }
                return
            }
            if ancestor(of: node, named: "menu") {
                tapButton(parent(of: node, named: "menu")) { [weak self] in self?.delegate_?.didTapMenu() }
                return
            }
        }
    }

    private func ancestor(of node: SKNode, named name: String) -> Bool {
        var cur: SKNode? = node
        while let n = cur {
            if n.name == name { return true }
            cur = n.parent
        }
        return false
    }

    private func parent(of node: SKNode, named name: String) -> SKNode {
        var cur: SKNode? = node
        while let n = cur {
            if n.name == name { return n }
            cur = n.parent
        }
        return node
    }

    private func tapButton(_ node: SKNode, completion: @escaping () -> Void) {
        Audio.shared.hapticLight()
        node.run(.sequence([.scale(to: 0.93, duration: 0.08), .scale(to: 1.0, duration: 0.08)])) {
            completion()
        }
    }
}
