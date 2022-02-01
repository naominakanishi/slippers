import SpriteKit

class Portal: Entity <SKSpriteNode> {
    
    private let portalScale = CGFloat(0.2)
    
    private var rightDirection = true
    
    private let currentColor: UIColor
    
    init(currentColor: UIColor, node: SKSpriteNode) {
        self.currentColor = currentColor
        super.init(node: node)
    }
    
    override func configureNode() {
        node.xScale = portalScale
        node.yScale = portalScale
        node.zPosition = Depth.portal
        node.name = "portal"
    }
    
    override func update(deltaTime: TimeInterval) {
        guard let scene = node.scene else { return }
        if node.position.x >= scene.frame.maxX {
            rightDirection = false
        } else if node.position.x <= scene.frame.minX {
            rightDirection = true
        }
        if rightDirection {
            node.position.x += 100 * deltaTime
        } else {
            node.position.x -= 100 * deltaTime
        }
        
    }

    override func configurePhysicsBody() -> SKPhysicsBody? {
        let body = SKPhysicsBody(texture: node.texture!, size: node.size)
        body.affectedByGravity = false
        body.categoryBitMask = CollisionMasks.portal
        body.contactTestBitMask = CollisionMasks.player
        body.collisionBitMask = CollisionMasks.none
        return body
    }
}

extension Portal: Colorize {
    func apply(color: UIColor) {
        node.colorBlendFactor = blendFactor
        node.color = color
    }
}
