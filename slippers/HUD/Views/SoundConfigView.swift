import UIKit

final class SoundConfig {
    
    private let soundFlagKey = "soundEnabled"
    private let musicFlagKey = "musicEnabled"
    
    private(set) var isSoundOn: Bool
    private(set) var isMusicOn: Bool
    
    init() {
        isSoundOn = UserDefaults.standard.bool(forKey: soundFlagKey)
        isMusicOn = UserDefaults.standard.bool(forKey: musicFlagKey)
    }
    
    func updateSoundState(_ isOn: Bool) {
        isSoundOn = isOn
        UserDefaults.standard.set(isOn, forKey: soundFlagKey)
    }
    
    func updateMusicState(_ isOn: Bool) {
        isMusicOn = isOn
        UserDefaults.standard.set(isOn, forKey: musicFlagKey)
    }
}

final class SoundConfigViewController: UIViewController {
    
    private let soundConfig: SoundConfig
    
    private var configView: SoundConfigView? { view as? SoundConfigView }
    
    init(soundConfig: SoundConfig) {
        self.soundConfig = soundConfig
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = SoundConfigView(
        actions: .init(
            didChangeSoundToggle: soundConfig.updateSoundState,
            didChangeMusicToggle: soundConfig.updateMusicState,
            didTapOnBack: { self.dismiss(animated: true, completion: nil)}
        ),
        model: .init(
            isSoundOn: soundConfig.isSoundOn,
            isMusicOn: soundConfig.isMusicOn)
        )
    }
}

final class SoundConfigView: CodedView, CodedViewLifeCycle {
    struct Actions {
        let didChangeSoundToggle: (Bool) -> Void
        let didChangeMusicToggle: (Bool) -> Void
        let didTapOnBack: () -> Void
    }
    
    struct Model {
        let isSoundOn: Bool
        let isMusicOn: Bool
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    private lazy var soundToggle: UISwitch = {
        let view = UISwitch()
        view.addTarget(self, action: #selector(handleToggle), for: .valueChanged)
        return view
    }()
    
    private lazy var soundEffectsLabel: UILabel = {
        let label = UILabel()
        label.text = "SOUND EFFECTS"
        configureLabelSettings(label: label)
        return label
    }()
    
    private lazy var musicToggle: UISwitch = {
        let view = UISwitch()
        view.addTarget(self, action: #selector(handleToggle), for: .valueChanged)
        return view
    }()
    
    private lazy var musicLabel: UILabel = {
        let label = UILabel()
        label.text = "BACKGROUND MUSIC"
        configureLabelSettings(label: label)
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let view = UIButton()
        view.configuration = .nijiText(
            title: "BACK TO MENU",
            leadingIcon: .init(systemName: "chevron.left"))
        backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        return view
    }()
    
    private let model: Model
    private let actions: Actions
    
    init(actions: Actions, model: Model) {
        self.actions = actions
        self.model = model
        super.init(frame: .zero)
    }
    
    func addSubviews() {
        addSubview(containerView)
        addSubview(backButton)
        containerView.addSubview(soundToggle)
        containerView.addSubview(musicToggle)
        containerView.addSubview(soundEffectsLabel)
        containerView.addSubview(musicLabel)
    }
    
    func constraintSubviews() {
        backButton.layout {
            $0.topAnchor.constraint(equalTo: topAnchor)
            $0.leadingAnchor.constraint(equalTo: leadingAnchor)
        }
        containerView.layout {
            $0.topAnchor.constraint(equalTo: soundToggle.topAnchor, constant: -10)
            $0.leadingAnchor.constraint(equalTo: soundToggle.leadingAnchor, constant: -10)
            $0.trailingAnchor.constraint(equalTo: musicLabel.trailingAnchor, constant: 10)
            $0.bottomAnchor.constraint(equalTo: musicToggle.bottomAnchor, constant: 10)
        }

        soundToggle.layout {
            $0.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -15)
            $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70)
        }
        
        soundEffectsLabel.layout {
            $0.centerYAnchor.constraint(equalTo: soundToggle.centerYAnchor)
            $0.leadingAnchor.constraint(equalTo: soundToggle.trailingAnchor, constant: 20)
        }
        
        musicToggle.layout {
            $0.topAnchor.constraint(equalTo: centerYAnchor, constant: 15)
            $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70)
        }
        
        musicLabel.layout {
            $0.centerYAnchor.constraint(equalTo: musicToggle.centerYAnchor)
            $0.leadingAnchor.constraint(equalTo: musicToggle.trailingAnchor, constant: 20)
        }
    }
    
    func configureAdditionalSettings() {
        backgroundColor = .nijiColors.black.withAlphaComponent(0.8)
        soundToggle.isOn = model.isSoundOn
        musicToggle.isOn = model.isMusicOn
    }
    
    func configureLabelSettings(label: UILabel) {
        label.font = .amatic(.bold, 28)
        label.textColor = .nijiColors.white
        label.textAlignment = .right
        backgroundColor = .clear
    }
    
    @objc
    private func handleToggle(_ sender: Any?) {
        guard let toggle = sender as? UISwitch
        else { return }
        switch toggle {
        case soundToggle:
            actions.didChangeSoundToggle(toggle.isOn)
        case musicToggle:
            actions.didChangeMusicToggle(toggle.isOn)
        default:
            break
        }
    }
    
    @objc
    private func handleBackButton() {
       // actions.didTapOnBack
    }
}

