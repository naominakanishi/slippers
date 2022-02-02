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
            node: originNode.copy() as! SKSpriteNode)
    }
    
    override func interStarDistance() -> CGFloat {
        50 * Star(imageName: "star").node.frame.height
    }
    
    func nextColor() {
        currentColor = .random()
        self.apply(color: currentColor)
    }
    
    override func didRespawn(_ entity: Portal) {
        scoreTracker.didExitDoubleScore()
//        scene.apply(color: .white) // TODO fix when portal is not picked up
    }
}
