import SpriteKit

class PointSpawner {
    
    let scene: SKScene
    private let scoreTracker: ScoreKeeper
    
    init(scene: SKScene, scoreTracker: ScoreKeeper) {
        self.scene = scene
        self.scoreTracker = scoreTracker
    }
    
    func spawn(at location: CGPoint) {
        let point = Point(node: .init())
        scene.addEntity(point)
        point.node.position = location
        point.setScore(to: scoreTracker.points)
        point.die()
    }
}
