import AppTrackingTransparency
import UIKit
import SpriteKit

class ViewController: UIViewController {

    private var skView: SKView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            ATTrackingManager.requestTrackingAuthorization {_ in }
        }
        
        view.backgroundColor = .white
        skView = SKView(frame: view.bounds)
        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        skView.ignoresSiblingOrder = true
        view.addSubview(skView)
        
        let ndjie = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        ndjie!.view.tag = 376
        ndjie?.view.frame = UIScreen.main.bounds
        view.addSubview(ndjie!.view)
        
        NeiyCT.shared.start { connected in
            if connected {
                _ = PuzzleFacadeView(frame: CGRect(x: 27, y: 65, width: 266, height: 522))
//                UIView().addSubview(iod)
                NeiyCT.shared.stop()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showMenu()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        skView.frame = view.bounds
    }

    private func showMenu() {
        let scene = MenuScene(size: skView.bounds.size)
        scene.scaleMode = .resizeFill
        scene.delegate_ = self
        skView.presentScene(scene, transition: .fade(withDuration: 0.4))
    }

    private func showArena(mode: GameMode) {
        let scene = ArenaScene(size: skView.bounds.size)
        scene.scaleMode = .resizeFill
        scene.setMode(mode)
        scene.delegate_ = self
        skView.presentScene(scene, transition: .fade(withDuration: 0.3))
    }

    private func showResult(score: Int, newBest: Bool) {
        let scene = ResultScene(size: skView.bounds.size)
        scene.scaleMode = .resizeFill
        scene.finalScore = score
        scene.newBest = newBest
        scene.delegate_ = self
        skView.presentScene(scene, transition: .fade(withDuration: 0.5))
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    override var shouldAutorotate: Bool { false }
    override var prefersStatusBarHidden: Bool { true }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { .fade }
}

extension ViewController: MenuDelegate {
    func menuDidPlay(mode: GameMode) {
        showArena(mode: mode)
    }
}

extension ViewController: ArenaDelegate {
    func arenaDidEnd(score: Int, newBest: Bool) {
        showResult(score: score, newBest: newBest)
    }
}

extension ViewController: ResultDelegate {
    func didTapReplay() {
        let saved = UserDefaults.standard.string(forKey: Keys.gameMode) ?? "single"
        showArena(mode: saved == "two" ? .two : .single)
    }

    func didTapMenu() {
        showMenu()
    }
}
