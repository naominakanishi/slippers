import UIKit
import SpriteKit
import GoogleMobileAds
import AVFoundation
import GameKit

final class GameViewController: UIViewController {
    
    private let livesService = LivesService()
    private let soundConfig = SoundConfigService()
    private let adService = AdService()
    private let stateMachine = GameStateMachine()
    private lazy var scoreTracker = ScoreService(scoreSender: leaderboardService)
    private lazy var musicService = MusicService(soundConfig: soundConfig)
    private let leaderboardService = LeaderboardService()
    
    // MARK: - Views
    
    private lazy var gameView: SKView = {
        let view = SKView()
        #if DEBUG
        view.showsFPS = true
        view.showsNodeCount = true
        view.showsPhysics = true
        #endif
        view.ignoresSiblingOrder = false
        return view
    }()
    
    private lazy var startScreenView = StartScreenView(actions: .init(
        didTapOnAudioSettings: {
            let controller = SoundConfigViewController(soundConfig: self.soundConfig)
            controller.modalPresentationStyle = .overCurrentContext
            controller.modalTransitionStyle = .crossDissolve
            self.show(controller, sender: self)
        },
        //changes current state to playing
        didTapOnStart: { [stateMachine] in
            stateMachine.currentState = .playing
            self.musicService.play()
        },
        didTapOnRanking: {
            self.leaderboardService.showLeaderboard()
        },
        didTapOnBuyLives: {
            self.livesService.purchase()
        }
    ))
    
    private lazy var gameOverView = GameOverView(actions: .init(
        livesAction: {
            self.handleLivesAction()
        },
        watchAd: {
            self.adService.showRewardAd(in: self)
        },
        startOver: {
            self.scoreTracker.reset()
            self.renderScene()
            self.stateMachine.currentState = .playing
            self.musicService.play()
        },
        didTapOnBack: {
            self.stateMachine.currentState = .initialScreen
        }))
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
        leaderboardService.initialize()
        livesService.delegate = self
        leaderboardService.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller lifecycle
    
    override func loadView() {
        view = gameView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addStateView(startScreenView)
        addStateView(gameOverView)
        
        stateMachine.addRenderer(renderer: self)
        
        renderScene()
        
        adService.delegate = self
        self.stateMachine.currentState = .playing
        Timer.scheduledTimer(withTimeInterval: 0, repeats: false) { _ in
            self.stateMachine.currentState = .initialScreen
        }
    }
    
    // MARK: - Helpers
    
    private func createScene() -> GameScene {
        let scene = GameScene(
            stateMachine: stateMachine,
            scoreTracker: scoreTracker,
            soundConfig: soundConfig)
        scene.anchorPoint = .init(x: 0.5, y: 0.5)
        scene.scaleMode = .resizeFill
        return scene
    }
    
    private func renderScene() {
        let scene = createScene()
        gameView.presentScene(scene)
        stateMachine.addRenderer(renderer: scene)
    }
    
    private func addStateView(_ view: UIView) {
        self.view.addSubview(view)
        view.layout {
            $0.topAnchor.constraint(equalTo: self.view.topAnchor)
            $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
            $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            $0.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        }
        view.isHidden = true
    }
    
    private func handleLivesAction() {
        if livesService.livesCount > 0 {
            livesService.consume()
            revive()
        } else {
            livesService.purchase()
            updateGameOver()
        }
    }
    
    private func revive() {
        scoreTracker.revive()
        renderScene()
        stateMachine.currentState = .playing
    }
}


extension GameViewController: StateRenderer {
    func render(state: GameState) {
        clearCurrentState()
        switch state {
        case .initialScreen:
            renderInitialScreen()
        case .playing:
            break
        case .gameOver:
            renderGameOver()
        }
    }
    
    private func renderInitialScreen() {
        updateStartScreen()
        startScreenView.isHidden = false
        startScreenView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.startScreenView.alpha = 1
        }
    }
    
    private func renderGameOver() {
        musicService.stop()
        gameOverView.isHidden = false
        gameOverView.alpha = 0
        updateGameOver()
        UIView.animate(withDuration: 0.4) {
            self.gameOverView.alpha = 1
        }
    }
    
    private func updateGameOver() {
        gameOverView.configure(using: .init(
            currentScore: scoreTracker.score,
            highScore: scoreTracker.highScore,
            livesButtonTitle: livesService.livesCount == 0 ? "BUY LIVES" : "USE LIFE (\(livesService.livesCount)/3)"
        ))
    }
    
    private func updateStartScreen() {
        startScreenView.configure(highScore: scoreTracker.highScore,
                                  livesCount: livesService.livesCount)
    }
    
    private func clearCurrentState() {
        [startScreenView, gameOverView].forEach { $0.isHidden = true }
    }
}

extension GameViewController: AdServiceDelegate {
    func showError() {
        // TODO
        print("deu erro")
    }
    
    func rewardUser() {
        revive()
    }
}

extension GameViewController: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}

extension GameViewController: LivesServiceDelegate {
    func didBuyLives() {
        startScreenView.configure(highScore: scoreTracker.highScore,
                                  livesCount: livesService.livesCount)
        updateGameOver()
    }
}

extension GameViewController: LeaderboardServiceDelegate {
    func present(authenticationViewController: UIViewController) {
        showDetailViewController(authenticationViewController, sender: self)
    }
    
    func present(leaderboardViewController: GKGameCenterViewController) {
        leaderboardViewController.gameCenterDelegate = self
        present(leaderboardViewController, animated: true, completion: nil)
    }
    
    func didAuthenticate() {
        leaderboardService.loadBoardHighscore { highScore in
            self.scoreTracker.syncIfNeeded(with: highScore)
            self.updateStartScreen()
        }
    }
}
