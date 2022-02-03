import SpriteKit

class Point: Entity <SKNode> {
    
    private let image = SKSpriteNode(imageNamed: "score-image")
    private let label = SKLabelNode()
    
    func setScore(to value: Int) {
        label.text = String(value)
    }
    
    override func configureNode() {
        node.addChild(image)
        label.fontColor = .black
        label.font = .depot(size: 24)
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        node.addChild(label)
    }
    
    override func die() {
        node.run(.sequence([.wait(forDuration: 0.5), .fadeOut(withDuration: 0.3)])) {
            self.node.removeFromParent()
        }
    }
}
