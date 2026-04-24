//
//  CanvasExtensions.swift
//  FasterFast
//

import UIKit
import SpriteKit

extension UIColor {

    static func gradientImage(top: UIColor, bottom: UIColor, size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            let colors = [top.cgColor, bottom.cgColor] as CFArray
            let space = CGColorSpaceCreateDeviceRGB()
            guard let gradient = CGGradient(colorsSpace: space, colors: colors, locations: [0, 1]) else { return }
            ctx.cgContext.drawLinearGradient(
                gradient,
                start: .zero,
                end: CGPoint(x: 0, y: size.height),
                options: []
            )
        }
    }
}

extension SKScene {

    var safeInsets: UIEdgeInsets {
        return view?.safeAreaInsets ?? .zero
    }

    var playArea: CGRect {
        let insets = safeInsets
        return CGRect(
            x: insets.left + 16,
            y: insets.bottom + 16,
            width: size.width - insets.left - insets.right - 32,
            height: size.height - insets.top - insets.bottom - 32
        )
    }
}

extension CGPoint {

    func distance(to other: CGPoint) -> CGFloat {
        return hypot(other.x - x, other.y - y)
    }

    static func random(in rect: CGRect, margin: CGFloat = 0) -> CGPoint {
        let x = CGFloat.random(in: (rect.minX + margin)...(rect.maxX - margin))
        let y = CGFloat.random(in: (rect.minY + margin)...(rect.maxY - margin))
        return CGPoint(x: x, y: y)
    }
}

struct Layout {

    static let referenceWidth: CGFloat = 375.0

    static func scaled(_ value: CGFloat, to width: CGFloat) -> CGFloat {
        return value * (width / referenceWidth)
    }

    static func font(_ base: CGFloat, width: CGFloat) -> CGFloat {
        return (base * (width / referenceWidth)).rounded()
    }
}

extension SKNode {

    func fadeIn(duration: TimeInterval = 0.3) {
        alpha = 0
        run(.fadeIn(withDuration: duration))
    }

    func fadeOut(duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        run(.fadeOut(withDuration: duration)) {
            completion?()
        }
    }
}

extension SKShapeNode {

    static func roundedButton(width: CGFloat, height: CGFloat, radius: CGFloat = 16, color: UIColor = Colors.teal) -> SKShapeNode {
        let rect = CGRect(x: -width / 2, y: -height / 2, width: width, height: height)
        let node = SKShapeNode(rect: rect, cornerRadius: radius)
        node.fillColor = color
        node.strokeColor = .clear
        node.lineWidth = 0
        return node
    }
}
