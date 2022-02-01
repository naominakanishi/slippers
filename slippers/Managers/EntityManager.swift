import SpriteKit

struct ManagerDescriptor {
    let spawnCount: Int
    let interEntityDistance: CGFloat
}

class EntityManager<E>: Entity<SKNode> where E: Entity<SKSpriteNode> {
    
    private let scene: GameScene
    private let player: Player
    private let spawnCount: Int
    
    private var entities: [E] = []
    private var lastlyHitNodes: [SKSpriteNode : TimeInterval] = [:]
    private var playerNode: SKNode { player.node }
    
    
    init(scene: GameScene,
         player: Player,
         node: SKNode,
         spawnCount: Int) {
        self.scene = scene
        self.player = player
        self.spawnCount = spawnCount
        super.init(node: node)
    }
    
    override func update(deltaTime: TimeInterval) {
        updateEntities(deltaTime: deltaTime)
        cleanStars()
    }
    
    func makeEntity() -> E {
        fatalError()
    }
    
    func interStarDistance() -> CGFloat {
        fatalError()
    }
    
    func spawnInitialBatch() {
        for i in 0...spawnCount {
            let newStar = makeEntity()
            scene.addEntity(newStar)
            newStar.node.position = .init(
                x: .random(in: -180...180),
                y: CGFloat(i) * interStarDistance())
            entities.append(newStar)
        }
    }
    
    func handleHit(on node: SKSpriteNode) -> Bool {
        guard let entity = entity(for: node),
              !lastlyHitNodes.keys.contains(where: { $0 == node })
        else { return false }
        lastlyHitNodes[node] = Date.timeIntervalSinceReferenceDate
        entity.die()
        respawn(star: entity)
        return true
    }
    
    func respawn(star: E) {
        guard let lastSpawn = entities.max(by: { $0.node.position.y < $1.node.position.y })
        else { return }
        let node = star.node
        node.position = .init(
            x: .random(in: -180...180),
            y: lastSpawn.node.position.y + interStarDistance())
        guard let index = entities.firstIndex(where: { $0.node == node })
        else { return }
        let ref = entities[index]
        entities.remove(at: index)
        entities.append(ref)
    }
    
    func entity(for node: SKSpriteNode) -> E? {
        entities.first(where: {
            $0.node == node
        })
    }
    
    private func updateEntities(deltaTime: TimeInterval) {
        for entity in entities {
            entity.update(deltaTime: deltaTime)
        }
    }
    
    private func cleanStars() {
        let playerY = playerNode.position.y - scene.frame.height / 2
        entities
            .filter { $0.node.position.y < playerY  }
            .forEach { respawn(star: $0) }
        
        lastlyHitNodes.forEach { node, timestamp in
            let now = Date.timeIntervalSinceReferenceDate
            guard now - timestamp > 1 else { return }
            lastlyHitNodes[node] = nil
        }
    }
}

extension EntityManager: Colorize {
    func apply(color: UIColor) {
        entities
            .map { $0.node }
            .forEach { $0.run(action(for: color)) }
    }
}
