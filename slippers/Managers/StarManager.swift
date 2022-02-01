import SpriteKit

final class StarManager: EntityManager<Star> {
    private let originNode = SKSpriteNode(imageNamed: "star")
    
    override func makeEntity() -> Star {
        Star(node: originNode.copy() as! SKSpriteNode)
    }
    
    override func interStarDistance() -> CGFloat {
        makeEntity().node.frame.height + 50
    }
}
