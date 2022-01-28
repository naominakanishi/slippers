import SpriteKit

class StarManager {
    
    private let scene: SKScene
    private let starYThreshold: CGFloat
    private let originNode = SKSpriteNode(imageNamed: "star")
    
    private var timeToNextSpawn: TimeInterval = 3
    
    private var stars: [Star] = []
    
    init(scene: SKScene, starYThreshold: CGFloat) {
        self.scene = scene
        self.starYThreshold = starYThreshold
    }
    
    func update(deltaTime: TimeInterval) {
        spawnIfPossible(deltaTime: deltaTime)
        updateStars(deltaTime: deltaTime)
        cleanStars()
    }

    func spawnIfPossible(deltaTime: TimeInterval) {
        timeToNextSpawn -= deltaTime
        if timeToNextSpawn <= 0 {
            let newStar = Star(node: originNode.copy() as! SKSpriteNode)
            scene.addEntity(newStar)
            newStar.node.position = .init(
                x: .random(in: -180...180),
                y: scene.frame.maxY)
            timeToNextSpawn = 1
            stars.append(newStar)
        }
    }
    
    func cleanStars() {
        stars.filter{
            $0.node.position.y - $0.node.frame.height / 2 <= starYThreshold
        }
        .forEach{
            $0.removeFromParent()
        }
    }
    
    func updateStars(deltaTime: TimeInterval) {
        for star in stars {
            star.update(deltaTime: deltaTime)
        }
    }
}
