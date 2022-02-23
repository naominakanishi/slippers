import SpriteKit

final class PortalManager: EntityManager<Portal> {
    private let originNode = SKSpriteNode(imageNamed: "portal")
    
    private(set) var currentColor: UIColor = .random()
    
    private let scoreTracker: ScoreKeeper

    
    init(scoreTracker: ScoreKeeper, scene: GameScene,
            player: Player,
            node: SKNode,
            spawnCount: Int) {
        self.scoreTracker = scoreTracker
        super.init(
            
            scene: scene,
            player: player,
            node: node,
            spawnCount: spawnCount)
        apply(color: currentColor)
    }
    
    private var currentScale: CGFloat {
        let mod50 = CGFloat(scoreTracker.points.quotientAndRemainder(dividingBy: 50).quotient)
        let min = 0.05
        let scaleFactor = 0.0005
        return max(0.18 - scaleFactor * mod50, min)
    }
    
    override func makeEntity() -> Portal {
        let node = originNode.copy() as! SKSpriteNode
        node.xScale = currentScale
        node.yScale = node.xScale
        
        return .init(
            currentColor: currentColor,
            player: player,
            node: node)
    }
    
    override func interStarDistance() -> CGFloat {
        50 * Star(imageName: "star").node.frame.height
    }
 
    override func update(deltaTime: TimeInterval) {
        super.update(deltaTime: deltaTime)
        entities.forEach {
            $0.node.xScale = currentScale
            $0.node.yScale = currentScale
        }
    }
    
    func nextColor() {
        currentColor = .random()
        self.apply(color: currentColor)
    }
}
