import SpriteKit

final class Background: Entity<SKSpriteNode> {
    
    private let upperNode = SKSpriteNode(imageNamed: "background")
    private let lowerNode = SKSpriteNode(imageNamed: "background")
    private let playerNode: SKSpriteNode
    
    private lazy var currentNode = node
    
    override func configureNode() {
        node.addChild(upperNode)
        node.addChild(lowerNode)
        upperNode.position.y = node.frame.height
        lowerNode.position.y = -node.frame.height
        node.zPosition = Depth.background
    }
    
    init(playerNode: SKSpriteNode, node: SKSpriteNode) {
        self.playerNode = playerNode
        super.init(node: node)
    }
    
    
    override func update(deltaTime: TimeInterval) {
        let distance = abs(playerNode.position.y - node.position.y)
        if distance > node.frame.height {
            node.position.y = playerNode.position.y
        }
    }
}

extension Background: Colorize {
    func apply(color: UIColor) {
        [node, upperNode, lowerNode]
            .forEach { $0.run(action(for: color)) }
    }
}
