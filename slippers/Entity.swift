import SpriteKit

class Entity<T> where T: SKNode {
    
    let node: T
    var physicsBody: SKPhysicsBody? {
        return node.physicsBody
    }
    
    init(node: T) {
        self.node = node
        configureNode()
        node.physicsBody = configurePhysicsBody()
    }
    
    func configureNode() {
        
    }
    
    func configurePhysicsBody() -> SKPhysicsBody? {
        nil
    }
    
    func update(deltaTime: TimeInterval) {
        
    }
}

extension Entity where T == SKSpriteNode {
    convenience init(imageName: String) {
        self.init(node: SKSpriteNode(imageNamed: imageName))
    }
}
