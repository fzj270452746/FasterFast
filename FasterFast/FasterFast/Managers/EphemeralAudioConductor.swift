//
//  EphemeralAudioConductor.swift
//  FasterFast
//

import AVFoundation
import UIKit

final class Audio {

    static let shared = Audio()

    private var players: [String: AVAudioPlayer] = [:]
    private var soundOn = true
    private var hapticOn = true

    private let light = UIImpactFeedbackGenerator(style: .light)
    private let medium = UIImpactFeedbackGenerator(style: .medium)
    private let notify = UINotificationFeedbackGenerator()

    private init() {
        loadPrefs()
        light.prepare()
        medium.prepare()
        notify.prepare()
    }

    func loadPrefs() {
        soundOn = UserDefaults.standard.object(forKey: Keys.soundOn) as? Bool ?? true
        hapticOn = UserDefaults.standard.object(forKey: Keys.hapticOn) as? Bool ?? true
    }

    func setSound(_ on: Bool) {
        soundOn = on
        UserDefaults.standard.set(on, forKey: Keys.soundOn)
    }

    func setHaptic(_ on: Bool) {
        hapticOn = on
        UserDefaults.standard.set(on, forKey: Keys.hapticOn)
    }

    var isSoundOn: Bool { soundOn }
    var isHapticOn: Bool { hapticOn }

    func play(_ id: String) {
        guard soundOn else { return }

        if let cached = players[id] {
            cached.currentTime = 0
            cached.play()
            return
        }

        let url = Bundle.main.url(forResource: id, withExtension: "mp3")
            ?? Bundle.main.url(forResource: id, withExtension: "wav")
            ?? Bundle.main.url(forResource: id, withExtension: "caf")

        guard let url else { return }

        do {
            let p = try AVAudioPlayer(contentsOf: url)
            p.prepareToPlay()
            p.play()
            players[id] = p
        } catch {
            // non-critical
        }
    }

    func tap() {
        guard soundOn else { return }
        AudioServicesPlaySystemSound(1104)
    }

    func error() {
        guard soundOn else { return }
        AudioServicesPlaySystemSound(1053)
    }

    func hapticLight() {
        guard hapticOn else { return }
        light.impactOccurred()
    }

    func hapticMedium() {
        guard hapticOn else { return }
        medium.impactOccurred()
    }

    func hapticSuccess() {
        guard hapticOn else { return }
        notify.notificationOccurred(.success)
    }

    func hapticFail() {
        guard hapticOn else { return }
        notify.notificationOccurred(.error)
    }
}
