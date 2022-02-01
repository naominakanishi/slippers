import SpriteKit

class DoubleScoreZoneSpawner {
    
    let scene: SKScene
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func configure(label: SKLabelNode) {
        label.fontColor = .black
        label.font = .amatic(style: .bold, size: 40)
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        
    }
    
    func spawn() {
        let label = SKLabelNode()
        
        
        configure(label: label)
        scene.camera?.addChild(label)
        label.text = "Double Score Zone"
        label.run(.fadeOut(withDuration: 3)) {
            label.removeFromParent()
        }
    }
}
