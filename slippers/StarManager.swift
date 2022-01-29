import SpriteKit

final class StarManager: Entity <SKNode> {
    
    private let scene: SKScene
    private let originNode = SKSpriteNode(imageNamed: "star")
    private let spawnCount = 100
    private lazy var interStarDistance: CGFloat = 20
    private let newStarOffset: CGFloat = 100
    private var startHeight: CGFloat {
        originNode.frame.height
    }
    
    private var stars: [Star] = []
    private var starYThreshold: CGFloat {
        node.parent?.position.y ?? 0
    }
    
    private var lastSpawn: Star? {
        stars.last
    }
    
    init(scene: SKScene, node: SKNode) {
        self.scene = scene
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
                y: scene.frame.maxY + CGFloat(i) * interStarDistance)
            stars.append(newStar)
        }
    }
    
    func handleHit(on node: SKSpriteNode) {
        guard let star = star(for: node) else { return }
        respawn(star: star)
    }
    
    func cleanStars() {
        guard let playerY = node.parent?.position.y
        else { return }
        stars.filter{
            $0.node.position.y < playerY - 200
        }
        .forEach{
//            respawn(star: $0)
            _ in
        }
    }
    
    private func respawn(star: Star) {
        
        guard let lastSpawn = stars.max(by: {
            $0.node.position.y < $1.node.position.y
        }) else {
            return
        }
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
