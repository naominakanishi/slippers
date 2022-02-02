import SpriteKit

final class PortalManager: EntityManager<Portal> {
    private let originNode = SKSpriteNode(imageNamed: "portal")
    private let scoreTracker: ScoreTracker
    
    private(set) var currentColor: UIColor = .random()
    
    init(scene: GameScene,
            player: Player,
            node: SKNode,
            spawnCount: Int,
            scoreTracker: ScoreTracker
    ) {
        self.scoreTracker = scoreTracker
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
        10 * Star(imageName: "star").node.frame.height
    }
    
    func nextColor() {
        currentColor = .random()
        self.apply(color: currentColor)
    }
}
