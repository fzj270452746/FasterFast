//
//  VelocityConstants.swift
//  FasterFast
//

import UIKit
import SpriteKit

struct Colors {

    static let teal = UIColor(red: 0.18, green: 0.80, blue: 0.78, alpha: 1.0)
    static let coral = UIColor(red: 1.0, green: 0.42, blue: 0.42, alpha: 1.0)
    static let lavender = UIColor(red: 0.68, green: 0.53, blue: 0.98, alpha: 1.0)
    static let amber = UIColor(red: 1.0, green: 0.76, blue: 0.22, alpha: 1.0)
    static let mint = UIColor(red: 0.40, green: 0.92, blue: 0.72, alpha: 1.0)
    static let peach = UIColor(red: 1.0, green: 0.62, blue: 0.58, alpha: 1.0)
    static let sky = UIColor(red: 0.55, green: 0.78, blue: 1.0, alpha: 1.0)

    static let bgTop = UIColor(red: 0.94, green: 0.96, blue: 1.0, alpha: 1.0)
    static let bgBottom = UIColor(red: 0.85, green: 0.90, blue: 0.98, alpha: 1.0)

    static let darkText = UIColor(red: 0.15, green: 0.15, blue: 0.22, alpha: 1.0)
    static let caption = UIColor(red: 0.45, green: 0.47, blue: 0.55, alpha: 1.0)

    static let frostedPanel = UIColor(white: 1.0, alpha: 0.88)
    static let dimOverlay = UIColor(white: 0.0, alpha: 0.45)
}

struct Config {

    static let baseInterval: TimeInterval = 2.0
    static let minInterval: TimeInterval = 0.35
    static let speedRate: CGFloat = 0.03

    static let minTargets: Int = 2
    static let maxTargets: Int = 5
    static let targetScaleStep: Int = 10

    static let baseRadius: CGFloat = 40.0
    static let minRadius: CGFloat = 22.0
    static let shrinkAt: Int = 30

    static let comboMilestones: [Int] = [5, 10, 20]

    static let slowDuration: TimeInterval = 2.0
    static let chaosDuration: TimeInterval = 3.0
    static let powerUpChance: CGFloat = 0.08

    static let blinkDuration: TimeInterval = 0.5
    static let moveSpeed: CGFloat = 120.0
    static let spinSpeed: CGFloat = CGFloat.pi * 2.0
}

struct Assets {

    static let circle = "target_circle"
    static let square = "target_square"
    static let blink = "target_blink"
    static let moving = "target_moving"
    static let spin = "target_spin"
}

struct SoundIDs {

    static let tap = "tap_correct"
    static let combo = "combo_chime"
    static let fault = "fault_buzz"
    static let surge = "surge_whoosh"
}

enum GameMode {
    case single
    case two
}

struct TwoMode {
    static let baseInterval: TimeInterval = 3.5
    static let minInterval: TimeInterval = 0.6
    static let minDistance: CGFloat = 2.8
}

struct Keys {

    static let bestScore = "com.fasterfast.apexScore"
    static let playCount = "com.fasterfast.cumulativePlays"
    static let soundOn = "com.fasterfast.audioEnabled"
    static let hapticOn = "com.fasterfast.hapticEnabled"
    static let gameMode = "com.fasterfast.selectedGameMode"
}
