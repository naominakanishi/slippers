import SpriteKit

protocol Colorize {
    func apply(color: UIColor)
}

extension Colorize {
    func action() -> SKAction {
        SKAction.colorize(with: .random(), colorBlendFactor: 0.5, duration: 5)
    }
}

final class Game {
    private let scene: SKScene
    private let camera = SKCameraNode()
    
    private lazy var player = Player(imageName: "player-standing")
    private lazy var ground = Ground(imageName: "ground")
    private lazy var starManager: StarManager = {
        let node = SKNode()
        player.node.addChild(node)
        node.position.y += scene.frame.height / 2
        return StarManager(
            scene: self.scene,
            playerNode: player.node,
            node: node)
    }()
    
    private lazy var background: Background = {
        let node = SKSpriteNode(imageNamed: "background")
        return Background(playerNode: player.node, node: node)
    }()
    
    private var starCount: Int = 0
    
    private var colorizables: [Colorize] {
        [
            starManager, background, player
        ]
    }
    
    init(scene: SKScene) {
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
    }
    
    func update(deltaTime: TimeInterval) {
        background.update(deltaTime: deltaTime)
        starManager.update(deltaTime: deltaTime)
        if player.node.physicsBody?.velocity.dy != 0 {
            camera.position.y = max(player.node.position.y, 0)
        }
    }
    
    func didSimulatePhysics() {
        player.didSimulatePhysics()
    }
    
    func touchUp(at location: CGPoint) {
        colorizables.forEach {
            $0.apply(color: .blue)
        }
    }
    
    func touchMoved(to location: CGPoint) {
        player.move(to: location)
    }
    
    func touchDown(at location: CGPoint) {
        player.jump()
    }
    
    func handle(contact: SKPhysicsContact) {
        processContact(playerBody: contact.bodyA, starBody: contact.bodyB)
        processContact(playerBody: contact.bodyB, starBody: contact.bodyA)
    }
    
    private func processContact(playerBody: SKPhysicsBody, starBody: SKPhysicsBody) {
        guard playerBody.categoryBitMask == CollisionMasks.player &&
                starBody.categoryBitMask == CollisionMasks.star
        else { return }
        DispatchQueue.main.async {
            guard let node = starBody.node as? SKSpriteNode,
                  self.starManager.handleHit(on: node)
            else { return }
            self.player.impulse()
            self.starCount += 1
            print(self.starCount)
        }
    }
}

extension UIColor {
    static func random() -> UIColor {
        .init(hue: .random(in: 0...1), saturation: .random(in: 0...1), brightness: 1, alpha: 1)
    }
}
