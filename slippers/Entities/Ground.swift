import SpriteKit

final class Ground: Entity<SKSpriteNode> {
    
    private let groundScale = CGFloat(0.9)
    private let groundHeight = CGFloat(20)
    
    override func configureNode() {
        node.xScale = groundScale
        node.yScale = groundScale
        node.zPosition = Depth.ground
        node.name = "ground"
    }
    
    override func configurePhysicsBody() -> SKPhysicsBody? {
        let body = SKPhysicsBody(
            rectangleOf: .init(
                width: node.frame.width,
                height: groundHeight),
            center: .init(
                x: node.frame.midX,
                y: (node.frame.maxY + node.frame.midY) / 2))
        
        body.isDynamic = false
        body.categoryBitMask = CollisionMasks.ground
        body.collisionBitMask = CollisionMasks.player
        
        return body
    }
    
    func configurePlayer(player: SKSpriteNode) {
        player.position = .init(
            x: node.position.x,
            y: node.frame.maxY)
    }
}
