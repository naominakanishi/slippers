import UIKit

extension UIButton.Configuration {
    static func nijiCapsule(title: String, imageName: String) -> Self {
        var configuration: Self = .filled()
        configuration.cornerStyle = .capsule
        configuration.imagePadding = 20
        configuration.baseBackgroundColor = .white
        var text: AttributedString = .init(stringLiteral: title)
        text.font = .amatic(.bold, 28)
        text.foregroundColor = .black
        configuration.attributedTitle = text
        configuration.image = UIImage(named: imageName)
        return configuration
    }
    
    static func nijiRoundedRectangle(title: String, imageName: String) -> Self {
        var configuration: Self = .filled()
        configuration.cornerStyle = .medium
        configuration.imagePadding = 10
        configuration.baseBackgroundColor = .white
        var text: AttributedString = .init(stringLiteral: title)
        text.font = .amatic(.bold, 28)
        text.foregroundColor = .black
        configuration.attributedTitle = text
        configuration.image = UIImage(named: imageName)
        return configuration
    }
}
