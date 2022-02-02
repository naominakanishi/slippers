import SpriteKit

protocol ScoreTracker {
    var points: Int { get }
    func score()
    func didEnterDoubleScore()
    func didExitDoubleScore()
}

final class Game: ScoreTracker {
    private let scene: GameScene
    private let camera = SKCameraNode()
    
    private lazy var player = Player(imageName: "player-standing")
    private lazy var ground = Ground(imageName: "ground")
    private lazy var point = PointSpawner(scene: scene, scoreTracker: self)
    private lazy var doubleScoreMessage = DoubleScoreZoneSpawner(scene: scene)
    private(set) var points: Int = 0
    private var scoreMultiplier = 1
    
    private lazy var starManager: StarManager = {
        let node = SKNode()
        return StarManager(
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
            spawnCount: 10,
            scoreTracker: self)
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
            scoreTracker: self),
        PortalContactHandler(
            player: player,
            scene: self,
            portalManager: portalManager,
            doubleScoreSpawner: doubleScoreMessage,
            scoreTracker: self)
    ]
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func score() {
        points += scoreMultiplier
    }
    
    func didEnterDoubleScore() {
        scoreMultiplier = 2
    }
    
    func didExitDoubleScore() {
        scoreMultiplier = 1
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
    }
    
    func update(deltaTime: TimeInterval) {
        background.update(deltaTime: deltaTime)
        starManager.update(deltaTime: deltaTime)
        portalManager.update(deltaTime: deltaTime)
        player.update(deltaTime: deltaTime)
        camera.position.y = max(player.node.position.y, 0)
    }
    
    func didSimulatePhysics() {
        player.didSimulatePhysics()
    }
    
    func touchDown(at location: CGPoint) {
        if player.physicsBody?.velocity == .zero {
            player.impulse()
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
