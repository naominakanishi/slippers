import SpriteKit

class Player: Entity <SKSpriteNode> {
    
    let playerScale = CGFloat(0.3)
    
    override func configureNode() {
        node.xScale = playerScale
        node.yScale = playerScale
        node.zPosition = Depth.player
    }
    
    override func configurePhysicsBody() -> SKPhysicsBody? {
        let body = SKPhysicsBody(texture: node.texture!, size: node.size)
        return body
    }
    
    func move(to position: CGPoint) {
        node.position.x = position.x
    }
    
}
