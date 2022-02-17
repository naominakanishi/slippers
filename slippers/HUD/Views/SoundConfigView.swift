import UIKit
import AVFoundation

final class SoundConfigViewController: UIViewController {
    
    private let soundConfig: SoundConfigService
    
    init(soundConfig: SoundConfigService) {
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
        view.backgroundColor = .init(hex: 0x0F0F0F).withAlphaComponent(0.5)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
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
        view.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        return view
    }()
    
    private lazy var titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0x454545)
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "AUDIO SETTINGS"
        view.font = .amatic(.bold, 28)
        view.textColor = .white
        return view
    }()
    
    private lazy var titleIconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "audio-settings-icon")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .white
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
        addSubview(titleView)
        containerView.addSubview(soundToggle)
        containerView.addSubview(musicToggle)
        containerView.addSubview(soundEffectsLabel)
        containerView.addSubview(musicLabel)
        titleView.addSubview(titleLabel)
        titleView.addSubview(titleIconImageView)
    }
    
    func constraintSubviews() {
        backButton.layout {
            $0.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20)
            $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        }
    
        containerView.layout {
            $0.widthAnchor.constraint(equalTo: $0.heightAnchor, multiplier: 362/200)
            $0.centerXAnchor.constraint(equalTo: centerXAnchor)
            $0.centerYAnchor.constraint(equalTo: centerYAnchor)
        }

        titleView.layout {
            $0.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
            $0.centerYAnchor.constraint(equalTo: containerView.topAnchor)
        }
        
        titleLabel.layout {
            $0.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 8)
            $0.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -8)
            $0.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -24)
        }
        
        titleIconImageView.layout {
            $0.leadingAnchor.constraint(equalTo: titleView.leadingAnchor,
                                        constant: 24)
            $0.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -12)
            $0.heightAnchor.constraint(equalToConstant: 24)
            $0.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
            $0.widthAnchor.constraint(equalTo: $0.heightAnchor, multiplier: 1)
        }
        
        soundToggle.layout {
            $0.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 32)
            $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70)
        }
        
        soundEffectsLabel.layout {
            $0.centerYAnchor.constraint(equalTo: soundToggle.centerYAnchor)
            $0.leadingAnchor.constraint(equalTo: soundToggle.trailingAnchor, constant: 20)
        }
        
        musicToggle.layout {
            $0.topAnchor.constraint(equalTo: soundToggle.bottomAnchor, constant: 32)
            $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70)
            $0.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -32)
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
        let gesture = UITapGestureRecognizer(
            target: self, action: #selector(handleBackButton))
        gesture.numberOfTapsRequired = 1
        addGestureRecognizer(gesture)
        titleView.layer.cornerRadius = 24
        containerView.layer.cornerRadius = 16
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
        actions.didTapOnBack()
    }
}

