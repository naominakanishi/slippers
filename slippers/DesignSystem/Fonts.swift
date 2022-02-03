import UIKit
import SpriteKit

enum FontStyle {
    case bold, regular
}

enum CustomFont {
    case amatic, depot
    
    
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
    
    func uiFont() -> UIFont? {
        .init(
            name: fontName,
            size: size)
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

extension UIFont {
    static var amatic: (FontStyle, CGFloat) -> UIFont? = {
        AppFont.amatic(style: $0, size: $1).uiFont()
    }
    
    static var depot: (CGFloat) -> UIFont? = {
        AppFont.depot(size: $0).uiFont()
    }
}
