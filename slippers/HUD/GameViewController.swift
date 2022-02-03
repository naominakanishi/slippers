//
//  ViewController.swift
//  slippers
//
//  Created by Naomi Nakanishi on 27/01/22.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
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
        didTapOnAudioSettings: { },
        didTapOnStart: { [stateMachine] in
            stateMachine.currentState = .playing
        }))
    
    private let scoreTracker = ScoreTracker()
    
    
    private let stateMachine = GameStateMachine()
    
    override func loadView() {
        view = gameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addStateView(startScreenView)
        
        let scene = createScene()
        gameView.presentScene(scene)
        
        stateMachine.addRenderer(renderer: scene)
        stateMachine.addRenderer(renderer: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            
            self.stateMachine.currentState = .initialScreen
        }
    }
    
    func createScene() -> GameScene {
        let scene = GameScene(stateMachine: stateMachine,
                              scoreTracker: scoreTracker)
        scene.anchorPoint = .init(x: 0.5, y: 0.5)
        scene.scaleMode = .resizeFill
        return scene
    }
}


extension GameViewController: StateRenderer {
    func render(state: GameState) {
        [
            startScreenView
        ].forEach { $0.isHidden = true }
        switch state {
        case .initialScreen:
            startScreenView.isHidden = false
            startScreenView.alpha = 0
            UIView.animate(withDuration: 0.4) {
                self.startScreenView.alpha = 1
            }
        case .playing:
            break
        case .pending:
            break
        case .gameOver:
            break
            //todo: endgame screen layout
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
