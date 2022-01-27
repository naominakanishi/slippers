import SpriteKit

class CloudManager {
    
    private let scene: SKScene
    
    private var timeToNextSpawn: TimeInterval = 3
    
    init(scene: SKScene) {
        self.scene = scene
        
    }

    func update(deltaTime: TimeInterval) {
        timeToNextSpawn -= deltaTime
        if timeToNextSpawn <= 0 {
            let newCloud = Cloud(imageName: "cloud")
            scene.addEntity(newCloud)
            newCloud.node.position = .init(x: .random(in: -200...200), y: .random(in: -200...200))
            timeToNextSpawn = 3
        }
    }
}
