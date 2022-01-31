import SpriteKit

final class StarManager: Entity <SKNode> {
    
    private let scene: SKScene
    private let originNode = SKSpriteNode(imageNamed: "star")
    private let spawnCount = 50
    private lazy var interStarDistance: CGFloat = originNode.frame.height/2
    private let newStarOffset: CGFloat = 20
    private let playerNode: SKNode
    private var startHeight: CGFloat {
        originNode.frame.height
    }
    
    private var stars: [Star] = []
    private var starYThreshold: CGFloat {
        node.parent?.position.y ?? 0
    }

    private var lastlyHitNodes: [SKSpriteNode : TimeInterval] = [:]
    
    private var lastSpawn: Star? {
        stars.last
    }
    
    init(scene: SKScene, playerNode: SKNode, node: SKNode) {
        self.scene = scene
        self.playerNode = playerNode
        super.init(node: node)
        
    }
    
    override func update(deltaTime: TimeInterval) {
        updateStars(deltaTime: deltaTime)
        cleanStars()
    }
    
    func spawnInitialBatch() {
        for i in 0...spawnCount {
            let newStar = Star(node: originNode.copy() as! SKSpriteNode)
            scene.addEntity(newStar)
            newStar.node.position = .init(
                x: .random(in: -180...180),
                y: CGFloat(i) * interStarDistance)
            stars.append(newStar)
        }
        stars.forEach{
            print($0.node.position.y)
        }
    }
    
    func handleHit(on node: SKSpriteNode) -> Bool {
        guard let star = star(for: node),
              !lastlyHitNodes.keys.contains(where: { $0 == node })
        else { return false }
        lastlyHitNodes[node] = Date.timeIntervalSinceReferenceDate
        star.die()
        respawn(star: star)
        return true
    }
    
    func cleanStars() {
        let playerY = playerNode.position.y
        stars.filter { $0.node.position.y < playerY - scene.frame.height / 2 }
        .forEach { respawn(star: $0) }
        
        lastlyHitNodes.forEach { node, timestamp in
            let now = Date.timeIntervalSinceReferenceDate
            guard now - timestamp > 1 else { return }
            lastlyHitNodes[node] = nil
        }
    }
    
    private func respawn(star: Star) {
        guard let lastSpawn = stars.max(by: { $0.node.position.y < $1.node.position.y })
        else { return }
        let node = star.node
        node.position = .init(
            x: .random(in: -180...180),
            y: lastSpawn.node.position.y + interStarDistance)
        guard let index = stars.firstIndex(where: { $0.node == node })
        else { return }
        let ref = stars[index]
        stars.remove(at: index)
        stars.append(ref)
    }
    
    func updateStars(deltaTime: TimeInterval) {
        for star in stars {
            star.update(deltaTime: deltaTime)
        }
    }
    
    func star(for node: SKSpriteNode) -> Star? {
        stars.first(where: {
            $0.node == node
        })
    }
}
