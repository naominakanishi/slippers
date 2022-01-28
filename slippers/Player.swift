import SpriteKit

class Player: Entity <SKSpriteNode> {
    
    let playerScale = CGFloat(0.27)
    
    override func configureNode() {
        node.xScale = playerScale
        node.yScale = playerScale
        node.zPosition = Depth.player
        
    }
    
    override func configurePhysicsBody() -> SKPhysicsBody? {
        let body = SKPhysicsBody(texture: node.texture!, size: node.size)
        body.mass = 0.02
        body.allowsRotation = false
        body.categoryBitMask = CollisionMasks.player
        body.collisionBitMask = CollisionMasks.ground
        return body
    }
    
    func move(to position: CGPoint) {
        node.position.x = position.x
    }
    
    func jump() {
        if node.physicsBody?.velocity.dy == 0 {
            impulse()
        }
    }
    
    func impulse() {
        node.physicsBody?.velocity = .zero
        
        node.physicsBody?.applyImpulse(.init(
            dx: 0,
            dy: 10))
        
    }
}
