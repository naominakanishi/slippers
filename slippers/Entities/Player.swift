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
    
    func impulse() {
        defer { lastStarTimestamp = .now }
        let deltaTime = lastStarTimestamp.timeIntervalSinceNow
        if deltaTime < 0.5 {
            streakCount += 1
        } else {
            streakCount = 0
        }
        node.physicsBody?.velocity.dy = CGFloat(750 + min(streakCount * 25, 750))
    }
}

extension Player: Colorize {
    func apply(color: UIColor) {
        node.run(action(for: color))
    }
}
