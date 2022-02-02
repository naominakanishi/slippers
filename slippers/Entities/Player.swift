import SpriteKit

class Player: Entity <SKSpriteNode> {
    private enum PlayerAnimation {
        case up, down
    }
    
    private let fallAction: SKAction = .animate(with: [
        SKTexture(imageNamed: "cape-char-jumping"),
        SKTexture(imageNamed: "cape-char-jumping-mid"),
        SKTexture(imageNamed: "cape-char-standing"),
    ], timePerFrame: 0.1)
    
    private var lastAnimation: PlayerAnimation?
    private var canAnimate = true
    
    private let capeNode = SKSpriteNode(imageNamed: "cape-char-standing")
    private let playerScale = CGFloat(0.27)
    private var streakCount = 0
    private var lastStarTimestamp: Date = .now
    
    override func configureNode() {
        node.xScale = playerScale
        node.yScale = playerScale
        node.zPosition = Depth.player
        node.addChild(capeNode)
        capeNode.yScale = 0.5
        capeNode.xScale = 0.5
    }
    
    override func configurePhysicsBody() -> SKPhysicsBody? {
        let body = SKPhysicsBody(texture: node.texture!, size: node.size)
        body.mass = 10
        body.allowsRotation = false
        body.categoryBitMask = CollisionMasks.player
        body.collisionBitMask = CollisionMasks.ground
        return body
    }
    
    override func update(deltaTime: TimeInterval) {
        guard let body = node.physicsBody else {
            return
        }
        
        if body.velocity.dy > 0 && canAnimate && lastAnimation != .up {
            lastAnimation = .up
            canAnimate = false
            capeNode.run(fallAction) {
                self.canAnimate = true
            }
        } else if body.velocity.dy < 0 && canAnimate && lastAnimation != .down{
            lastAnimation = .down
            canAnimate = false
            capeNode.run(fallAction.reversed()) {
                self.canAnimate = true
            }
        }
    }
    
    func move(to position: CGPoint) {
        node.position.x = position.x
    }
    
    func impulse() {
        node.physicsBody?.velocity.dy = 800
    }
}

extension Player: Colorize {
    func apply(color: UIColor) {
        capeNode.run(action(for: color))
    }
}
