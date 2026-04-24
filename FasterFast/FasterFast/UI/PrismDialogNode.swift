//
//  PrismDialogNode.swift
//  FasterFast
//

import SpriteKit

struct DialogButton {
    let title: String
    let color: UIColor
    let dismiss: Bool
    let action: () -> Void

    init(_ title: String, color: UIColor, dismiss: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.color = color
        self.dismiss = dismiss
        self.action = action
    }
}

final class DialogNode: SKNode {

    private var backdrop: SKShapeNode!
    private var card: SKShapeNode!
    private var sceneSize: CGSize = .zero
    private var handlers: [(action: () -> Void, dismiss: Bool)] = []

    func show(in scene: SKScene, title: String, body: String? = nil, buttons: [DialogButton]) {
        sceneSize = scene.size
        zPosition = 500
        isUserInteractionEnabled = true

        backdrop = SKShapeNode(rectOf: sceneSize)
        backdrop.position = CGPoint(x: sceneSize.width / 2, y: -sceneSize.height / 2)
        backdrop.fillColor = Colors.dimOverlay
        backdrop.strokeColor = .clear
        backdrop.zPosition = 501
        backdrop.alpha = 0
        addChild(backdrop)

        let cardWidth = min(sceneSize.width - 60, 320)
        let btnH: CGFloat = 48
        let btnGap: CGFloat = 12
        let topPad: CGFloat = 32
        let botPad: CGFloat = 24
        let titleH: CGFloat = 36
        let bodyFontSize = max(13.0, Layout.scaled(13, to: sceneSize.width))
        let textWidth = cardWidth - 48

        // pre-measure body height so the card doesn't clip
        var bodyH: CGFloat = 0
        if let body {
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "AvenirNext-Medium", size: bodyFontSize) ?? UIFont.systemFont(ofSize: bodyFontSize)
            ]
            let rect = (body as NSString).boundingRect(
                with: CGSize(width: textWidth, height: .greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: attrs,
                context: nil
            )
            bodyH = ceil(rect.height) + 8
        }

        let totalBtnH = CGFloat(buttons.count) * btnH + CGFloat(max(buttons.count - 1, 0)) * btnGap
        let cardH = topPad + titleH + bodyH + 20 + totalBtnH + botPad

        card = SKShapeNode(rect: CGRect(x: -cardWidth / 2, y: -cardH / 2, width: cardWidth, height: cardH), cornerRadius: 20)
        card.fillColor = Colors.frostedPanel
        card.strokeColor = UIColor(white: 0.9, alpha: 1.0)
        card.lineWidth = 1
        card.position = CGPoint(x: sceneSize.width / 2, y: -sceneSize.height / 2)
        card.zPosition = 502
        card.setScale(0.7)
        card.alpha = 0
        addChild(card)

        let titleFont = max(22, Layout.scaled(22, to: sceneSize.width))
        let titleNode = SKLabelNode(fontNamed: "AvenirNext-Bold")
        titleNode.text = title
        titleNode.fontSize = titleFont
        titleNode.fontColor = Colors.darkText
        titleNode.horizontalAlignmentMode = .center
        titleNode.verticalAlignmentMode = .top
        titleNode.position = CGPoint(x: 0, y: cardH / 2 - topPad)
        card.addChild(titleNode)

        var cursor = titleNode.position.y - titleH
        if let body {
            let bodyNode = SKLabelNode(fontNamed: "AvenirNext-Medium")
            bodyNode.text = body
            bodyNode.fontSize = bodyFontSize
            bodyNode.fontColor = Colors.caption
            bodyNode.horizontalAlignmentMode = .center
            bodyNode.verticalAlignmentMode = .top
            bodyNode.numberOfLines = 0
            bodyNode.preferredMaxLayoutWidth = textWidth
            bodyNode.position = CGPoint(x: 0, y: cursor)
            card.addChild(bodyNode)
            cursor -= bodyH
        }

        let btnWidth = cardWidth - 48
        var btnY = cursor - 20 - btnH / 2
        for (i, spec) in buttons.enumerated() {
            let btn = makeButton(title: spec.title, width: btnWidth, height: btnH, color: spec.color, tag: i)
            btn.position = CGPoint(x: 0, y: btnY)
            btn.name = "btn_\(i)"
            card.addChild(btn)
            btnY -= (btnH + btnGap)
        }

        handlers = buttons.map { ($0.action, $0.dismiss) }

        backdrop.run(.fadeIn(withDuration: 0.25))
        let grow = SKAction.scale(to: 1.0, duration: 0.3)
        grow.timingMode = .easeOut
        card.run(.group([grow, .fadeIn(withDuration: 0.3)]))

        scene.addChild(self)
    }

    private func makeButton(title: String, width: CGFloat, height: CGFloat, color: UIColor, tag: Int) -> SKNode {
        let container = SKNode()
        let bg = SKShapeNode(rect: CGRect(x: -width / 2, y: -height / 2, width: width, height: height), cornerRadius: 14)
        bg.fillColor = color
        bg.strokeColor = .clear
        bg.name = "btn_\(tag)"
        container.addChild(bg)

        let label = SKLabelNode(fontNamed: "AvenirNext-DemiBold")
        label.text = title
        label.fontSize = max(16, Layout.scaled(16, to: sceneSize.width))
        label.fontColor = .white
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: 0, y: -2)
        label.name = "btn_\(tag)"
        container.addChild(label)

        return container
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        for i in (0..<handlers.count).reversed() {
            let name = "btn_\(i)"
            for btn in card.children.filter({ $0.name == name }) {
                if let bg = btn.children.first as? SKShapeNode, bg.contains(touch.location(in: btn)) {
                    btn.run(.sequence([.scale(to: 0.95, duration: 0.05), .scale(to: 1.0, duration: 0.05)]))
                    let (action, shouldDismiss) = handlers[i]
                    if shouldDismiss {
                        hide { action() }
                    } else {
                        action()
                    }
                    return
                }
            }
        }
    }

    func hide(completion: (() -> Void)? = nil) {
        backdrop.run(.fadeOut(withDuration: 0.2))
        let shrink = SKAction.scale(to: 0.7, duration: 0.2)
        shrink.timingMode = .easeIn
        card.run(.group([shrink, .fadeOut(withDuration: 0.2)])) { [weak self] in
            self?.removeFromParent()
            completion?()
        }
    }
}
