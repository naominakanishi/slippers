import SpriteKit

class Point: Entity <SKNode> {
    
    private let image = SKSpriteNode(imageNamed: "score-image")
    private let label = SKLabelNode()
    
    func setScore(to value: Int) {
        label.text = String(value)
//        label.fontName = UIFont(name: "DepotNewCondensed-Regular", size: 24)
    }
    
    override func configureNode() {
        node.addChild(image)
        label.fontColor = .blue
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        node.addChild(label)
    }
    
    override func die() {
        self.node.run(.fadeOut(withDuration: 0.3)) {
            self.node.removeFromParent()
        }
    }
}
