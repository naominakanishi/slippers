import UIKit
import SpriteKit

enum FontStyle {
    case bold, regular
}

struct AppFont {
    let fontName: String
    let size: CGFloat
}

extension AppFont {
    static func amatic(style: FontStyle, size: CGFloat) -> AppFont {
        switch style {
        case .bold:
            return .init(fontName: "AmaticSC-Bold", size: size)
        case .regular:
            return .init(fontName: "AmaticSC-Regular", size: size)
        }
    }
    
    static func depot(size: CGFloat) -> AppFont {
        .init(fontName: "DepotNewCondensed-Regular", size: size)
    }
}

extension SKLabelNode {
    var font: AppFont {
        get { fatalError("You must not access appFont!") }
        set {
            self.fontName = newValue.fontName
            self.fontSize = newValue.size
        }
    }
}
