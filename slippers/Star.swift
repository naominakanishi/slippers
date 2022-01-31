import SpriteKit

class Star: Entity <SKSpriteNode> {
    
    private(set) var canHit = true
    
    override func update(deltaTime: TimeInterval) {
        node.position.y -= 100 * deltaTime
    }
    
    func removeFromParent() {
        node.removeFromParent()
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
        node.xScale = 0.2
        node.yScale = 0.2
    }
    
    func die() {
        canHit = false
    }
    
    func respawn() {
        canHit = true
    }
}
