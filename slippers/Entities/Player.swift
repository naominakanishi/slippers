import SpriteKit

class Player: Entity <SKSpriteNode> {
    
    private let playerScale = CGFloat(0.27)
    private var streakCount = 0
    private var lastStarTimestamp: Date = .now
    
    override func configureNode() {
        node.xScale = playerScale
        node.yScale = playerScale
        node.zPosition = Depth.player
    }
    
    override func configurePhysicsBody() -> SKPhysicsBody? {
        let body = SKPhysicsBody(texture: node.texture!, size: node.size)
        body.mass = 10
        body.allowsRotation = false
        body.categoryBitMask = CollisionMasks.player
        body.collisionBitMask = CollisionMasks.ground
        return body
    }
    
    func move(to position: CGPoint) {
        node.position.x = position.x
    }
    
    override func didSimulatePhysics() {
        guard let body = node.physicsBody else { return }
//        body.velocity.dy = min(body.velocity.dy, 1500)
    }
    
    func impulse() {
        node.physicsBody?.velocity.dy = 800
    }
}

extension Player: Colorize {
    func apply(color: UIColor) {
        node.run(action(for: color))
    }
}
