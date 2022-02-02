import UIKit

enum Colors {
    static let green: UIColor = .init(hex: 0x84EFB1)
    static let lightBlue: UIColor = .init(hex: 0x27DBFC)
    static let darkBlue: UIColor = .init(hex: 0x158CFD)
    static let yellow: UIColor = .init(hex: 0xFCC047)
    static let red: UIColor = .init(hex: 0xFC6F6B)
    static let purple: UIColor = .init(hex: 0x9260FB)
    static let orange: UIColor = .init(hex: 0xFF954B)

    static var allColors: [UIColor] {[
        Colors.green,
        Colors.lightBlue,
        Colors.darkBlue,
        Colors.yellow,
        Colors.red,
        Colors.purple,
        Colors.orange,
    ]}
    
    static func random() -> UIColor {
        allColors.randomElement()!
    }
}
 
extension UIColor {
    static let nijiColors = Colors.self
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(hex: Int) {
       self.init(
           red: (hex >> 16) & 0xFF,
           green: (hex >> 8) & 0xFF,
           blue: hex & 0xFF
       )
   }
}


