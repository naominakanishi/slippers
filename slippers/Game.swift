import SpriteKit

final class Game {
    private lazy var background = Background(imageName: "background")
    
    private lazy var player = Player(imageName: "player-standing")
    
    private lazy var ground = Ground(imageName: "ground")
    
    private lazy var cloudManager = CloudManager(scene: self.scene)
    
    private let scene: SKScene
    
    init(scene: SKScene) {
        self.scene = scene
        setup()
    }
    
    private func setup() {
        scene.addEntity(background)
        scene.addEntity(player)
        scene.addEntity(ground)
        ground.node.position.y = scene.frame.minY + ground.node.frame.height / 2
        
        ground.configurePlayer(player: player.node)
    }
    
    func update(deltaTime: TimeInterval) {
        background.update(deltaTime: deltaTime)
        cloudManager.update(deltaTime: deltaTime)
    }
    
    func touchUp(at location: CGPoint) {
        
    }
    
    func touchMoved(to location: CGPoint) {
        player.move(to: location)
    }
    
    func touchDown(at location: CGPoint) {
        
    }
}
