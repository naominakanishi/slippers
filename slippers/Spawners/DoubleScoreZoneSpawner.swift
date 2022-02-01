import SpriteKit

class DoubleScoreZoneSpawner {
    
    let scene: SKScene
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func configure(label: SKLabelNode) {
        label.fontColor = .blue
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        
    }
    
    func spawn() {
        let label = SKLabelNode()
        label.font = .amatic(style: .bold, size: 40)
        
        configure(label: label)
        scene.camera?.addChild(label)
        label.text = "Double Score Zone"
        label.run(.fadeOut(withDuration: 0.6)) {
            label.removeFromParent()
        }
    }
}
