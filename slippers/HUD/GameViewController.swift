import UIKit
import SpriteKit
import GoogleMobileAds
import AVFoundation

class GameViewController: UIViewController, AdServiceDelegate {
    
    var backgroundSong: AVAudioPlayer?
    
    func showError() {
        // TODO
        print("deu erro")

    }
    
    func rewardUser() {
        scoreTracker.revive()
        self.renderScene()
        self.stateMachine.currentState = .playing
    }
    
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
            self.backgroundSong!.play()

        },
        didTapOnRanking: {}
    ))
    
    private lazy var gameOverView = GameOverView(actions: .init(
        watchAd: {
            self.adService.showRewardAd(in: self)
        },
        startOver: {
            self.scoreTracker.reset()
            self.renderScene()
            self.stateMachine.currentState = .playing
            self.backgroundSong?.play()

        }))
    
    private let scoreTracker = ScoreTracker()
    private let soundConfig = SoundConfig()
    private let adService = AdService()
    private let stateMachine = GameStateMachine()
   
    
    override func loadView() {
        view = gameView
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addStateView(startScreenView)
        addStateView(gameOverView)
        
        let path = Bundle.main.path(forResource: "background-music.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do {
            backgroundSong = try AVAudioPlayer(contentsOf: url)
        } catch {
            // couldn't load file :(
        }
        stateMachine.addRenderer(renderer: self)
        
        renderScene()
        
        adService.delegate = self
        self.stateMachine.currentState = .playing
        Timer.scheduledTimer(withTimeInterval: 0, repeats: false) { _ in
            
            self.stateMachine.currentState = .initialScreen
        }
    }
    
    private func renderScene() {
        let scene = createScene()
        gameView.presentScene(scene)
        stateMachine.addRenderer(renderer: scene)
    }
    
    
    // loads the first screen to be displayed
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    func createScene() -> GameScene {
        let scene = GameScene(
            stateMachine: stateMachine,
            scoreTracker: scoreTracker,
            soundConfig: soundConfig)
        scene.anchorPoint = .init(x: 0.5, y: 0.5)
        scene.scaleMode = .resizeFill
        return scene
    }
}


extension GameViewController: StateRenderer {
    func render(state: GameState) {
        [
            startScreenView,
            gameOverView
        ].forEach { $0.isHidden = true }
        
        switch state {
        case .initialScreen:
            startScreenView.configure(highScore: scoreTracker.highScore)
            startScreenView.isHidden = false
            startScreenView.alpha = 0
            UIView.animate(withDuration: 0.4) {
                self.startScreenView.alpha = 1
            }
        case .playing:
            break
        case .gameOver:
            backgroundSong?.stop()
            gameOverView.isHidden = false
            gameOverView.alpha = 0
            gameOverView.configure(using: .init(
                currentScore: scoreTracker.score,
                highScore: scoreTracker.highScore))
            UIView.animate(withDuration: 0.4) {
                self.gameOverView.alpha = 1
            }
        }
    }
}

extension GameViewController {
    func addStateView(_ view: UIView) {
        self.view.addSubview(view)
        view.layout {
            $0.topAnchor.constraint(equalTo: self.view.topAnchor)
            $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
            $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            $0.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        }
        view.isHidden = true
    }
}
