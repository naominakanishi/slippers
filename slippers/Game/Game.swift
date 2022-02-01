import SpriteKit

final class Game {
    private let scene: GameScene
    private let camera = SKCameraNode()
    
    private lazy var player = Player(imageName: "player-standing")
    private lazy var ground = Ground(imageName: "ground")
    private lazy var starManager: StarManager = {
        let node = SKNode()
        player.node.addChild(node)
        node.position.y += scene.frame.height / 2
        return StarManager(
            scene: self.scene,
            player: player,
            node: node,
            spawnCount: 50)
    }()
    
    private lazy var portalManager: PortalManager = {
        let node = SKNode()
        player.node.addChild(node)
        node.position.y += scene.frame.height / 2
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
        setup()
    }
    
    private func setup() {
        scene.addEntity(background)
        scene.addEntity(player)
        scene.addEntity(ground)
        ground.node.position.y = scene.frame.minY + ground.node.frame.height / 6
        
        ground.configurePlayer(player: player.node)
        
        scene.camera = camera
        scene.addChild(camera)
        
        starManager.spawnInitialBatch()
        portalManager.spawnInitialBatch()
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
    
    func touchUp(at location: CGPoint) {
        
    }
    
    func touchMoved(to location: CGPoint) {
        player.move(to: location)
    }
    
    func touchDown(at location: CGPoint) {
        player.jump()
    }
    
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
