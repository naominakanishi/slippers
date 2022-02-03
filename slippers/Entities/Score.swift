import SpriteKit

class Score: Entity <SKNode> {
    
    private let scoreTitle = SKLabelNode()
    private var score = SKLabelNode()
    private let currentPoints: ScoreKeeper
    
    override func configureNode() {
        scoreTitle.font = .depot(size: 24)
        scoreTitle.fontColor = .black
        scoreTitle.verticalAlignmentMode = .center
        scoreTitle.horizontalAlignmentMode = .center
        score.font = .depot(size: 24)
        scoreTitle.text = "Score"
        score.fontColor = .black
        score.verticalAlignmentMode = .center
        score.horizontalAlignmentMode = .center
        score.position.y = -30
        node.addChild(scoreTitle)
        node.addChild(score)
    }

    init(currentPoints: ScoreKeeper, node: SKNode) {
        self.currentPoints = currentPoints
        super.init(node: node)
    }
 
    override func update(deltaTime: TimeInterval) {
        score.text = String(currentPoints.score)
    }
}
