import UIKit

final class StartScreenView: CodedView, CodedViewLifeCycle {
    
    struct Actions {
        let didTapOnAudioSettings: () -> Void
        let didTapOnStart: () -> Void
    }
    
    private lazy var logo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "niji-logo")
        return view
    }()
    
    private lazy var instructionMessage: UILabel = {
        let view = UILabel()
        view.font = .amatic(.bold, 24)
        view.textColor = .white
        view.textAlignment = .center
        view.text = "JUMP THROUGH AS MANY STARS AS YOU CAN"
        return view
    }()
    
    
    private lazy var startButton: UIButton = {
        let view = UIButton()
        view.configuration = .nijiCapsule(title: "START", imageName: "start-icon")
        view.addTarget(self, action: #selector(handleStartTap), for: .touchUpInside)
        return view
    }()
    
    private lazy var audioSettingsButton: UIButton = {
        let view = UIButton()
        view.configuration = .nijiCapsule(title: "AUDIO SETTINGS", imageName: "audio-settings-icon")
        view.addTarget(self, action: #selector(handleAudioSettingsTap), for: .touchUpInside)
        view.isHidden = true
        return view
    }()
    
    private let actions: Actions
    
    init(actions: Actions) {
        self.actions = actions
        super.init(frame: .zero)
    }
    
    func addSubviews() {
        addSubview(logo)
        addSubview(startButton)
        addSubview(audioSettingsButton)
        addSubview(instructionMessage)
    }
    
    func constraintSubviews() {
        logo.layout {
            $0.topAnchor.constraint(equalTo: topAnchor, constant: 150)
            $0.centerXAnchor.constraint(equalTo: centerXAnchor)
            $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6)
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor, multiplier: 169/515)
        }
        
        instructionMessage.layout {
            $0.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -20)
            $0.centerXAnchor.constraint(equalTo: centerXAnchor)
            $0.widthAnchor.constraint(equalTo: widthAnchor)
        }
        
        audioSettingsButton.layout {
            $0.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -20)
            $0.centerXAnchor.constraint(equalTo: centerXAnchor)
            $0.widthAnchor.constraint(equalTo: startButton.widthAnchor)
        }
        
        startButton.layout {
            $0.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -150)
            $0.centerXAnchor.constraint(equalTo: centerXAnchor)
            $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6)
        }
    }
    
    private var text: String {
        UUID().uuidString
    }
    
    func configureAdditionalSettings() {
        backgroundColor = .black.withAlphaComponent(0.5)
        fadeOut()
    }
    
    private func fadeOut() {
        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.fromValue = 1
        fadeIn.toValue = 0
        fadeIn.duration = 1
        fadeIn.delegate = self
        instructionMessage.layer.add(fadeIn, forKey: "fadeOut")
    }
    
    private func fadeIn() {
        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.fromValue = 0
        fadeIn.toValue = 1
        fadeIn.duration = 3
        fadeIn.delegate = self
        instructionMessage.layer.add(fadeIn, forKey: "fadeIn")
    }
    
    private var currentMessageIndex = 0
    private var messages: [String] = [
        "JUMP THROUGH AS MANY STARS AS YOU CAN",
        "USE THE COLOR PORTALS TO GET A SCORE BOOST",
        "SET NEW RECORDS GOING HIGHER EVERY TIME",
    ]
    private func changeMessage() {
        currentMessageIndex += 1
        if currentMessageIndex >= messages.count { currentMessageIndex = 0 }
        instructionMessage.text = messages[currentMessageIndex]
    }
    
    @objc
    private func handleStartTap() {
        actions.didTapOnStart()
    }
    
    @objc
    private func handleAudioSettingsTap() {
        actions.didTapOnAudioSettings()
    }
}

extension StartScreenView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let animation = anim as? CABasicAnimation,
              let fromValue = animation.fromValue as? Int
        else { return }
        if fromValue == 1 {
            changeMessage()
            fadeIn()
            return
        }
        
        if fromValue == 0 {
            fadeOut()
        }
    }
}
