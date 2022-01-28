import SpriteKit

final class Game {
    private let camera = SKCameraNode()
    
    private lazy var background = Background(imageName: "background")
    
    private lazy var player = Player(imageName: "player-standing")
    
    private lazy var ground = Ground(imageName: "ground")
    
    private lazy var starManager = StarManager(scene: self.scene, starYThreshold: scene.frame.minY + player.node.frame.height + 20)
    
    private let scene: SKScene
    
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
    }
    
    func update(deltaTime: TimeInterval) {
        background.update(deltaTime: deltaTime)
        starManager.update(deltaTime: deltaTime)
    }
    
    func touchUp(at location: CGPoint) {
        player.jump()
    }
    
    func touchMoved(to location: CGPoint) {
        player.move(to: location)
    }
    
    func touchDown(at location: CGPoint) {
        
    }
    
    func handle(contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == CollisionMasks.player && contact.bodyB.categoryBitMask == CollisionMasks.star {
            contact.bodyB.node?.physicsBody = nil
            player.impulse()
            return
        }
        if contact.bodyA.categoryBitMask == CollisionMasks.star && contact.bodyB.categoryBitMask == CollisionMasks.player {
            contact.bodyA.node?.physicsBody = nil
            player.impulse()
            return
        }
        
    }
}
