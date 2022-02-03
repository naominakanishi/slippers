import SpriteKit

final class PortalManager: EntityManager<Portal> {
    private let originNode = SKSpriteNode(imageNamed: "portal")
    
    private(set) var currentColor: UIColor = .random()
    
    override init(scene: GameScene,
            player: Player,
            node: SKNode,
            spawnCount: Int) {
        super.init(
            scene: scene,
            player: player,
            node: node,
            spawnCount: spawnCount)
        apply(color: currentColor)
    }
    
    override func makeEntity() -> Portal {
        .init(
            currentColor: currentColor,
            player: player,
            node: originNode.copy() as! SKSpriteNode)
    }
    
    override func interStarDistance() -> CGFloat {
        50 * Star(imageName: "star").node.frame.height
    }
    
    func nextColor() {
        currentColor = .random()
        self.apply(color: currentColor)
    }
}
