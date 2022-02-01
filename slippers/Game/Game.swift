import SpriteKit

final class Game {
    private let scene: GameScene
    private let camera = SKCameraNode()
    
    private lazy var player = Player(imageName: "player-standing")
    private lazy var ground = Ground(imageName: "ground")
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
            scene: self.scene,
            player: player,
            node: node,
            spawnCount: 10)
    }()
    
    private lazy var background: Background = {
        let node = SKSpriteNode(imageNamed: "background")
        return Background(playerNode: player.node, node: node)
    }()
    
    private lazy var contactHandlers: [ContactHandler] = [
        StarContactHandler(starManager: starManager, player: player),
        PortalContactHandler(player: player, scene: self, portalManager: portalManager)
    ]
    
    init(scene: GameScene) {
        self.scene = scene
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
        let debug = SKShapeNode(circleOfRadius: 10)
        debug.fillColor = .red
        scene.addChild(debug)
        debug.position = starManager.node.position
        debug.zPosition = 1000
    }
    
    func update(deltaTime: TimeInterval) {
        background.update(deltaTime: deltaTime)
        starManager.update(deltaTime: deltaTime)
        portalManager.update(deltaTime: deltaTime)
        camera.position.y = max(player.node.position.y, 0)
    }
    
    func didSimulatePhysics() {
        player.didSimulatePhysics()
    }
    
    
    func touchDown(at location: CGPoint) {}
    
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
        .init(hue: .random(in: 0...1), saturation: .random(in: 0.2...1), brightness: 1, alpha: 1)
    }
}
