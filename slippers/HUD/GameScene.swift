import SpriteKit

final class GameScene: SKScene, SKPhysicsContactDelegate {
    private let scoreTracker: ScoreServiceProtocol
    private let stateMachine: GameStateMachine
    private let soundConfig: SoundConfig
    private lazy var game = Game(scene: self,
                                 scoreTracker: scoreTracker,
                                 soundConfig: soundConfig)
    
    private(set) var canRun = true
    private var lastTime: TimeInterval?
    
    var backgroundMusic: SKAudioNode!
        
    init(stateMachine: GameStateMachine,
         scoreTracker: ScoreServiceProtocol,
         soundConfig: SoundConfig) {
        self.stateMachine = stateMachine
        self.scoreTracker = scoreTracker
        self.soundConfig = soundConfig
        super.init(size: .zero)
        physicsWorld.contactDelegate = self
        isPaused = true
        game.onGameOver = { [weak self] in
            self?.stateMachine.currentState = .gameOver
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .white

    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let lastTime = self.lastTime else {
            game.setup()
            lastTime = currentTime
            canRun = true
            return
        }
        let deltaTime = currentTime - lastTime
        game.syncCamera(deltaTime: deltaTime)
        defer { self.lastTime = currentTime }
        guard canRun else { return }
        game.update(deltaTime: deltaTime)
    }
    
    override func didSimulatePhysics() {
        guard !isPaused else { return }
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
            canRun = false
        case .playing:
            canRun = true
        case .gameOver:
            canRun = false
        }
    }
}

extension SKScene {
    func addEntity<T>(_ entity: Entity<T>) {
        addChild(entity.node)
    }
}

extension GameScene: Colorize {
    func apply(color: UIColor) {
        game.apply(color: color)
    }
}
