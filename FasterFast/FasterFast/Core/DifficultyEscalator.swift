//
//  DifficultyEscalator.swift
//  FasterFast
//

import Foundation
import CoreGraphics

struct Snapshot {
    let speedMultiplier: CGFloat
    let spawnInterval: TimeInterval
    let targetCount: Int
    let radius: CGFloat
    let hasBlinkers: Bool
    let hasMovers: Bool
    let hasSpinners: Bool
}

final class Escalator {

    private(set) var score: Int = 0
    private(set) var streak: Int = 0
    private(set) var doubled: Bool = false
    private(set) var slowed: Bool = false
    private(set) var chaos: Bool = false
    private(set) var mode: GameMode = .single

    var speedMultiplier: CGFloat {
        let raw = 1.0 + CGFloat(score) * Config.speedRate
        return slowed ? raw * 0.5 : raw
    }

    var spawnInterval: TimeInterval {
        let base: TimeInterval
        let min: TimeInterval

        switch mode {
        case .single:
            base = Config.baseInterval
            min = Config.minInterval
        case .two:
            base = TwoMode.baseInterval
            min = TwoMode.minInterval
        }

        return Swift.max(base / Double(speedMultiplier), min)
    }

    var targetCount: Int {
        let extra = score / Config.targetScaleStep
        return Swift.min(Config.minTargets + extra, Config.maxTargets)
    }

    var radius: CGFloat {
        guard score >= Config.shrinkAt else { return Config.baseRadius }
        let t = min(CGFloat(score - Config.shrinkAt) / 30.0, 1.0)
        return Config.baseRadius - (Config.baseRadius - Config.minRadius) * t
    }

    func snapshot() -> Snapshot {
        return Snapshot(
            speedMultiplier: speedMultiplier,
            spawnInterval: spawnInterval,
            targetCount: targetCount,
            radius: radius,
            hasBlinkers: score >= 15,
            hasMovers: score >= 25,
            hasSpinners: score >= 35
        )
    }

    func hit() -> (score: Int, bonus: Int) {
        score += 1
        streak += 1

        var bonus = 0
        if doubled {
            score += 1
            bonus += 1
        }

        for milestone in Config.comboMilestones {
            if streak == milestone {
                bonus += milestone
                score += milestone
                break
            }
        }

        return (score, bonus)
    }

    func miss() {
        streak = 0
    }

    func reset() {
        score = 0
        streak = 0
        doubled = false
        slowed = false
        chaos = false
    }

    func setMode(_ m: GameMode) {
        mode = m
    }

    func rollPowerUp() -> PowerUp? {
        guard CGFloat.random(in: 0...1) < Config.powerUpChance else { return nil }
        return PowerUp.allCases.randomElement()
    }

    func activate(_ p: PowerUp) {
        switch p {
        case .slow: slowed = true
        case .double: doubled = true
        case .chaos: chaos = true
        }
    }

    func deactivate(_ p: PowerUp) {
        switch p {
        case .slow: slowed = false
        case .double: doubled = false
        case .chaos: chaos = false
        }
    }
}

enum PowerUp: String, CaseIterable {
    case slow = "SLOW MOTION"
    case double = "SCORE x2"
    case chaos = "CHAOS"
}
