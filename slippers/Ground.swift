import SpriteKit

class Ground: Entity <SKSpriteNode> {
    
    let groundScale = CGFloat(0.9)
    let groundHeight = CGFloat(20)
    
    override func configureNode() {
        node.xScale = groundScale
        node.yScale = groundScale
        node.zPosition = Depth.ground
    }
    
    override func configurePhysicsBody() -> SKPhysicsBody? {
        let body = SKPhysicsBody(rectangleOf: .init(width: node.frame.width, height: groundHeight), center: .init(x: node.frame.midX, y: node.frame.minY))
        body.isDynamic = false
        return body
    }
    
    func configurePlayer(player: SKSpriteNode) {
        player.position = .init(x: 0, y: node.position.y - node.frame.height / 2 + player.frame.height / 2  + groundHeight)
    }
}
