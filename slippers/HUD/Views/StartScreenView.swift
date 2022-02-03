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
    }
    
    func constraintSubviews() {
        logo.layout {
            $0.topAnchor.constraint(equalTo: topAnchor, constant: 100)
            $0.centerXAnchor.constraint(equalTo: centerXAnchor)
            $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6)
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor, multiplier: 169/515)
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
    
    func configureAdditionalSettings() {
        backgroundColor = .black.withAlphaComponent(0.5)
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
