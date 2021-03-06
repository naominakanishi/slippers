import SpriteKit

class Star: Entity <SKSpriteNode> {
    
    override func update(deltaTime: TimeInterval) {
        node.position.y -= 100 * deltaTime
    }
    
    override func configurePhysicsBody() -> SKPhysicsBody? {
        let body = SKPhysicsBody(texture: node.texture!, size: node.size)
        body.affectedByGravity = false
        body.categoryBitMask = CollisionMasks.star
        body.contactTestBitMask = CollisionMasks.player
        body.collisionBitMask = CollisionMasks.none
        return body
    }
    
    override func configureNode() {
        node.zPosition = Depth.star
    }
}
