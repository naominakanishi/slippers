import UIKit

final class StartScreenView: CodedView, CodedViewLifeCycle {
    
    struct Actions {
        let didTapOnAudioSettings: () -> Void
        let didTapOnStart: () -> Void
        let didTapOnRanking: () -> Void
    }
    
    private lazy var background: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "background-home")
        return view
    }()
    
    private lazy var logo: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "niji-logo")
        return view
    }()
    
    private lazy var island: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "island-character")
        return view
    }()
    
    private lazy var rectangleSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var currentLives: UIView = {
        let view = UIView()
        setupInfoViews(view: view)
        return view
    }()
    
    private lazy var highestScore: UIView = {
        let view = UIView()
        setupInfoViews(view: view)
        return view
    }()
    
    private lazy var currentLivesLabel: UILabel = {
        let label = UILabel()
        label.text = "Current Lives"
        configureInfoViewText(title: label)
        return label
    }()
    
    private lazy var highestScoreTitle: UILabel = {
        let label = UILabel()
        label.text = "Highest Score"
        configureInfoViewText(title: label)
        return label
    }()
    
    private lazy var highestScoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Highest Score"
        configureInfoViewText(title: label)
        return label
    }()
    
    private lazy var startButton: UIButton = {
        let view = UIButton()
        view.configuration = .nijiCapsule(title: "START GAME", imageName: "start-icon")
        view.configuration?.baseBackgroundColor = .nijiColors.darkGray
        view.configuration?.attributedTitle?.foregroundColor = .white
        view.addTarget(self, action: #selector(handleStartTap), for: .touchUpInside)
        return view
    }()
    
    private lazy var audioSettingsButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "sound-config"), for: .normal)
        view.addTarget(self, action: #selector(handleAudioSettingsTap), for: .touchUpInside)
        return view
    }()
    
    private lazy var rankingButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(UIImage(named: "ranking"), for: .normal)
        view.addTarget(self, action: #selector(handleRankingTap), for: .touchUpInside)
        return view
    }()
    
    
    private let actions: Actions
    
    init(actions: Actions) {
        self.actions = actions
        super.init(frame: .zero)
    }
    
    func addSubviews() {
        addSubview(background)
        addSubview(logo)
        addSubview(island)
        addSubview(rectangleSeparator)
        
        addSubview(currentLives)
        currentLives.addSubview(currentLivesLabel)
        addSubview(highestScore)
        highestScore.addSubview(highestScoreTitle)
        highestScore.addSubview(highestScoreLabel)
        
        addSubview(startButton)
        addSubview(audioSettingsButton)
        addSubview(rankingButton)
    }
    
    func constraintSubviews() {
        background.layout {
            $0.topAnchor.constraint(equalTo: topAnchor)
            $0.leadingAnchor.constraint(equalTo: leadingAnchor)
            $0.trailingAnchor.constraint(equalTo: trailingAnchor)
            $0.bottomAnchor.constraint(equalTo: bottomAnchor)
        }
        
        logo.layout {
            $0.topAnchor.constraint(equalTo: topAnchor, constant: 65)
            $0.centerXAnchor.constraint(equalTo: centerXAnchor)
            $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6)
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor, multiplier: 106/322)
        }
        
        island.layout {
            $0.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 50)
            $0.centerXAnchor.constraint(equalTo: centerXAnchor)
            $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor, multiplier: 500/754)
        }
        
        rectangleSeparator.layout {
            $0.topAnchor.constraint(equalTo: island.centerYAnchor)
            $0.leadingAnchor.constraint(equalTo: leadingAnchor)
            $0.trailingAnchor.constraint(equalTo: trailingAnchor)
            $0.bottomAnchor.constraint(equalTo: bottomAnchor)
        }
        
        currentLives.layout {
            $0.topAnchor.constraint(equalTo: island.bottomAnchor, constant: 30)
            $0.centerXAnchor.constraint(equalTo: centerXAnchor)
            $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65)
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor, multiplier: 113/271)
        }
        highestScore.layout {
            $0.topAnchor.constraint(equalTo: currentLives.bottomAnchor, constant: 30)
            $0.centerXAnchor.constraint(equalTo: centerXAnchor)
            $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65)
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor, multiplier: 113/271)
        }
        
        currentLivesLabel.layout {
            $0.topAnchor.constraint(equalTo: currentLives.topAnchor, constant: 20)
            $0.centerXAnchor.constraint(equalTo: currentLives.centerXAnchor)
            $0.widthAnchor.constraint(equalTo: currentLives.widthAnchor)
        }
        
        highestScoreTitle.layout {
            $0.topAnchor.constraint(equalTo: highestScore.topAnchor, constant: 20)
            $0.centerXAnchor.constraint(equalTo: highestScore.centerXAnchor)
            $0.widthAnchor.constraint(equalTo: highestScore.widthAnchor)
        }
        
        highestScoreLabel.layout {
            $0.bottomAnchor.constraint(equalTo: highestScore.bottomAnchor, constant: -20)
            $0.centerXAnchor.constraint(equalTo: highestScore.centerXAnchor)
            $0.widthAnchor.constraint(equalTo: highestScore.widthAnchor)
        }
        
        
        startButton.layout {
            $0.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40)
            $0.centerXAnchor.constraint(equalTo: centerXAnchor)
            $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)
            $0.heightAnchor.constraint(equalToConstant: 60)
        }
        
        audioSettingsButton.layout {
            $0.centerYAnchor.constraint(equalTo: startButton.centerYAnchor)
            $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
            $0.trailingAnchor.constraint(equalTo: startButton.leadingAnchor, constant: -20)
            $0.heightAnchor.constraint(equalTo: startButton.heightAnchor)
        }

        rankingButton.layout {
            $0.centerYAnchor.constraint(equalTo: startButton.centerYAnchor)
            $0.leadingAnchor.constraint(equalTo: startButton.trailingAnchor, constant: 20)
            $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            
            $0.heightAnchor.constraint(equalTo: startButton.heightAnchor)
        }
    }
    
    
    func setupInfoViews(view: UIView) {
        view.backgroundColor = .nijiColors.lightGray
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 20
    }
    
    func configureInfoViewText(title: UILabel) {
        title.font = .depot(24)
        title.textAlignment = .center
        title.textColor = .black
    }
    
    func configureAdditionalSettings() {
        backgroundColor = .black
        self.bringSubviewToFront(island)
    }
    
    
    func configure(highScore: Int) {
        highestScoreLabel.text = String(highScore)
    }
    
    @objc
    private func handleStartTap() {
        actions.didTapOnStart()
    }
    
    @objc
    private func handleAudioSettingsTap() {
        actions.didTapOnAudioSettings()
    }
    
    @objc func handleRankingTap() {
        actions.didTapOnRanking()
    }
}
