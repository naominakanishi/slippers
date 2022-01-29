import SpriteKit

class Background: Entity<SKSpriteNode> {
    
    override func configureNode() {
        let secondNode = SKSpriteNode(imageNamed: "background")
        node.addChild(secondNode)
        secondNode.position.y = -node.frame.height
        node.zPosition = Depth.background
    }
//    override func update(deltaTime: TimeInterval) {
//        node.position.y -= deltaTime * 50
//        
//        if node.position.y <= 0 {
//            node.position.y += node.frame.height
//        }
//    }
}
