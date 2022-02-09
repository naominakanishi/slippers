import SpriteKit

final class Game {
    private let soundConfig: SoundConfig
    private let scoreTracker: ScoreTrackerProtocol
    private let scene: GameScene
    private let camera = SKCameraNode()
    
    private lazy var player = Player(imageName: "player-standing")
    private lazy var ground = Ground(imageName: "ground")
    private lazy var point = PointSpawner(
        scene: scene,
        scoreTracker: scoreTracker)
    private lazy var doubleScoreMessage = DoubleScoreZoneSpawner(scene: scene)
    private lazy var scoreEntity = Score(currentPoints: scoreTracker,
                                         node: .init())
    private lazy var starManager: StarManager = {
        let node = SKNode()
        return StarManager(
            scoreTracker: scoreTracker,
            scene: self.scene,
            player: player,
            node: node,
            spawnCount: 10)
    }()
    
    private lazy var portalManager: PortalManager = {
        let node = SKNode()
        return PortalManager(
            scene: scene,
            player: player,
            node: node,
            spawnCount: 10  )
    }()
    
    private lazy var background: Background = {
        let node = SKSpriteNode(imageNamed: "background")
        return Background(playerNode: player.node, node: node)
    }()
    
    private lazy var contactHandlers: [ContactHandler] = [
        StarContactHandler(
            starManager: starManager,
            player: player,
            pointSpawner: point,
            scoreTracker: scoreTracker,
            soundConfig: soundConfig),
        PortalContactHandler(
            player: player,
            scene: self,
            portalManager: portalManager,
            doubleScoreSpawner: doubleScoreMessage,
            scoreTracker: scoreTracker),
        GroundContactHandler(scoreKeeper: scoreTracker) {
            self.onGameOver?()
        }
    ]
    
    var onGameOver: (() -> Void)?
    private var currentMessageIndex = 0
    
    private let label = SKLabelNode(text: "asd")
    
    private lazy var instructionLabel: SKLabelNode = {
        let label = SKLabelNode()
        label.fontColor = .black
        label.font = .amatic(style: .bold, size: 28)
        label.numberOfLines = 0
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.position.y = scene.frame.midY
        label.zPosition = .infinity
        return label
    }()
    
    private var messages: [String] = [
        "JUMP THROUGH AS MANY STARS AS YOU CAN",
        "USE THE COLOR PORTALS TO GET A SCORE BOOST",
        "SET NEW RECORDS GOING HIGHER EVERY TIME",
    ]
    
    init(scene: GameScene,
         scoreTracker: ScoreTrackerProtocol,
         soundConfig: SoundConfig) {
        self.scene = scene
        self.scoreTracker = scoreTracker
        self.soundConfig = soundConfig
    }
    
    private func changeMessage() {
        currentMessageIndex += 1
        if currentMessageIndex >= messages.count { currentMessageIndex = 0 }
        instructionLabel.text = messages[currentMessageIndex]

    }
    
    func setup() {
        scene.camera = camera
        scene.addChild(camera)
        camera.position = .zero
        
        scene.addEntity(background)
        scene.addEntity(player)
        scene.addEntity(ground)
        
        starManager.spawnInitialBatch()
        portalManager.spawnInitialBatch()
        
        ground.node.position.y = scene.frame.minY + ground.node.frame.height / 6
        ground.configurePlayer(player: player.node)
        
        scene.addEntity(starManager)
        starManager.node.position.y = scene.frame.height
        camera.addChild(scoreEntity.node)
        scoreEntity.node.position.x = scene.frame.minX + 20 + scoreEntity.node.frame.width / 2
        scoreEntity.node.position.y = scene.frame.maxY - 50 + scoreEntity.node.frame.height / 2
        
        scene.addChild(instructionLabel)
       
        
        instructionLabel.run(.repeatForever(.sequence([
            .fadeOut(withDuration: 1.3),
            .run {
                self.changeMessage()
            },
            .fadeIn(withDuration: 1.3)
        ])))
        
    }
    
    func update(deltaTime: TimeInterval) {
        starManager.update(deltaTime: deltaTime)
        portalManager.update(deltaTime: deltaTime)
        player.update(deltaTime: deltaTime)
        scoreEntity.update(deltaTime: deltaTime)
        checkIfGameIsOver()
    }
    
    func didSimulatePhysics() {
        player.didSimulatePhysics()
    }
    
    func touchDown(at location: CGPoint) {
        if player.physicsBody?.velocity == .zero {
            player.impulse()
            self.instructionLabel.removeAllActions()
            self.instructionLabel.removeFromParent()
        }
    }
    
    func touchMoved(to location: CGPoint) {
        player.move(to: location)
    }
    
    func touchUp(at location: CGPoint) {}
    
    func handle(contact: SKPhysicsContact) {
        contactHandlers.forEach{
            $0.handle(contact: contact)
        }
    }
    
    func syncCamera(deltaTime: TimeInterval) {
        camera.position.y = max(player.node.position.y, 0)
        background.update(deltaTime: deltaTime)
    }
    
    private func checkIfGameIsOver() {
        let yThreshold: CGFloat = -2000
        if (player.physicsBody?.velocity.dy ?? 0) < yThreshold {
            onGameOver?()
            return
        }
    }
}


extension Game: Colorize {
    func apply(color: UIColor) {
        let colorizeables: [Colorize] = [
            portalManager, starManager,
            player, background
        ]
        
        colorizeables.forEach { $0.apply(color: color) }
    }
}

extension UIColor {
    static func random() -> UIColor {
        Colors.random()
    }
}
