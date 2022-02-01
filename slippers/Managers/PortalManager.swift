import SpriteKit

final class PortalManager: EntityManager<Portal> {
    private let originNode = SKSpriteNode(imageNamed: "portal")
    
    private(set) var currentColor: UIColor = .random()
    
    override func makeEntity() -> Portal {
        .init(currentColor: currentColor, node: originNode.copy() as! SKSpriteNode)
    }
    
    override func interStarDistance() -> CGFloat {
        20 * Star(imageName: "star").node.frame.height
    }
    
    func nextColor() {
        currentColor = .random()
        self.apply(color: currentColor)
    }
}
