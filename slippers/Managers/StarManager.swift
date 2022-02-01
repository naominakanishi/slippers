import SpriteKit

final class StarManager: EntityManager<Star> {
    private let originNode = SKSpriteNode(imageNamed: "star")
    
    override func makeEntity() -> Star {
        let node = originNode.copy() as! SKSpriteNode
        let playerHeight = player.node.position.y
        node.xScale = clamp(playerHeight * 0.01, min: 0.2, max: 1)
        return Star(node: node)
    }
    
    override func interStarDistance() -> CGFloat {
        makeEntity().node.frame.height + 100
    }
}

func clamp(_ value: CGFloat, min _min: CGFloat, max _max: CGFloat) -> CGFloat {
    min(max(value, _min), _max)
}
