import SpriteKit

final class StarManager: EntityManager<Star> {
    private let originNode = SKSpriteNode(imageNamed: "star")
    private let scoreTracker: ScoreKeeper
    
    init(scoreTracker: ScoreKeeper, scene: GameScene, player: Player, node: SKNode, spawnCount: Int) {
        self.scoreTracker = scoreTracker
        super.init(scene: scene, player: player, node: node, spawnCount: spawnCount)
    }
    
    private var currentScale: CGFloat {
        let mod50 = CGFloat(scoreTracker.points.quotientAndRemainder(dividingBy: 50).quotient)
        let min = 0.05
        let scaleFactor = 0.0005
        return max(0.2 - scaleFactor * mod50, min)
    }
    
    override func makeEntity() -> Star {
        let node = originNode.copy() as! SKSpriteNode
        node.xScale = currentScale
        node.yScale = node.xScale
        return Star(node: node)
    }
    
    override func interStarDistance() -> CGFloat {
        originNode.frame.height * currentScale + 100
    }
    
    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)
        entities.forEach {
            $0.node.xScale = currentScale
            $0.node.yScale = currentScale
        }
    }
}

func clamp(_ value: CGFloat, min _min: CGFloat, max _max: CGFloat) -> CGFloat {
    max(min(value, _max), _min)
}
