//
//  ApexVaultKeeper.swift
//  FasterFast
//

import Foundation

final class Store {

    static let shared = Store()

    private let defaults = UserDefaults.standard

    private init() {}

    var bestScore: Int {
        get { defaults.integer(forKey: Keys.bestScore) }
        set { defaults.set(newValue, forKey: Keys.bestScore) }
    }

    @discardableResult
    func submit(score: Int) -> Bool {
        guard score > bestScore else { return false }
        bestScore = score
        return true
    }

    var playCount: Int {
        get { defaults.integer(forKey: Keys.playCount) }
        set { defaults.set(newValue, forKey: Keys.playCount) }
    }

    func incrementPlays() {
        playCount += 1
    }
}
