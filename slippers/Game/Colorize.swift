import SpriteKit

protocol Colorize {
    var blendFactor: CGFloat { get }
    var duration: TimeInterval { get }
    func apply(color: UIColor)
}

extension Colorize {
    func action(for color: UIColor) -> SKAction {
        SKAction.colorize(with: color,
                          colorBlendFactor: blendFactor,
                          duration: duration)
    }
    
    var blendFactor: CGFloat { 0.3 }
    var duration: TimeInterval { 1 }
}
