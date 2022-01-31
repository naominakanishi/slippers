import SpriteKit

final class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private let stateMachine: GameStateMachine
    private lazy var game = Game(scene: self)
    
    private var lastTime: TimeInterval?
        
    init(stateMachine: GameStateMachine) {
        self.stateMachine = stateMachine
        super.init(size: .zero)
        physicsWorld.contactDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .red
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let lastTime = self.lastTime else {
            lastTime = currentTime
            return
        }
        defer { self.lastTime = currentTime }
        let deltaTime = currentTime - lastTime
        game.update(deltaTime: deltaTime)
    }
    
    override func didSimulatePhysics() {
        game.didSimulatePhysics()
    }
    

    
    func didBegin(_ contact: SKPhysicsContact) {
        game.handle(contact: contact)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            game.touchDown(at: touch.location(in: self))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            game.touchMoved(to: touch.location(in: self))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            game.touchUp(at: touch.location(in: self))
        }
    }
}

extension GameScene: StateRenderer {
    func render(state: GameState){
        switch state {
        case .initialScreen:
            isPaused = true
        case .playing:
            isPaused = false
            backgroundColor = .blue
        case .pending:
            break
        case .gameOver:
            break
        }
    }
}

extension SKScene {
    func addEntity<T>(_ entity: Entity<T>) {
        addChild(entity.node)
    }
}