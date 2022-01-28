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
        return view
    }()
    
    private let stateMachine = GameStateMachine()
    
    private var canGameStart = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(gameView)
        
        gameView.layout {
            $0.topAnchor.constraint(equalTo: view.topAnchor)
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            $0.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            $0.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        }
        
        let scene = createScene()
        gameView.presentScene(scene)
        
        stateMachine.addRenderer(renderer: scene)
        stateMachine.addRenderer(renderer: self)
        
        stateMachine.currentState = .playing
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func createScene() -> GameScene {
        let scene = GameScene(stateMachine: stateMachine)
        scene.anchorPoint = .init(x: 0.5, y: 0.5)
        scene.scaleMode = .resizeFill
        return scene
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if canGameStart {
            stateMachine.currentState = .playing
        }
    }
}


extension GameViewController: StateRenderer {
    func render(state: GameState) {
        switch state {
        case .initialScreen:
            canGameStart = true
        case .playing:
            break
            //todo: hide everything from intial screen
        case .pending:
            break
            //todo: present overlay with options
        case .gameOver:
            break
            //todo: endgame screen layout
        }
    }
}
