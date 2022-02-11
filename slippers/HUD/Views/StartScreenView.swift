import UIKit

final class StartScreenView: CodedView, CodedViewLifeCycle {
    
    struct Actions {
        let didTapOnAudioSettings: () -> Void
        let didTapOnStart: () -> Void
        let didTapOnRanking: () -> Void
        let didTapOnBuyLives: () -> Void
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
    
    private lazy var buyLivesButton: UIButton = {
        let view = UIButton()
        view.configuration = .nijiText(title: "Buy lives", leadingIcon: UIImage(named: "heart-icon"))
        view.configuration?.baseForegroundColor = .black
        view.configuration?.attributedTitle?.foregroundColor = .black
        view.addTarget(self, action: #selector(handleBuyLivesTap), for: .touchUpInside)
        view.isHidden = true
        return view
    }()
    
    private lazy var heartsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.addArrangedSubview(UIImageView(image: UIImage(named: "heart-icon")))
        view.addArrangedSubview(UIImageView(image: UIImage(named: "heart-icon")))
        view.addArrangedSubview(UIImageView(image: UIImage(named: "heart-icon")))
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
        currentLives.addSubview(buyLivesButton)
        currentLives.addSubview(heartsStackView)
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
            $0.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 30)
            $0.centerXAnchor.constraint(equalTo: centerXAnchor)
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor, multiplier: 500/754)
            island.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).withPriority(.defaultLow)
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
            $0.topAnchor.constraint(equalTo: currentLives.bottomAnchor, constant: 16)
            $0.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -30)
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
            $0.heightAnchor.constraint(equalToConstant: 60)
        }
        
        audioSettingsButton.layout {
            $0.centerYAnchor.constraint(equalTo: startButton.centerYAnchor)
            $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
            $0.trailingAnchor.constraint(equalTo: startButton.leadingAnchor, constant: -20)
            $0.heightAnchor.constraint(equalTo: startButton.heightAnchor)
            $0.widthAnchor.constraint(equalTo: rankingButton.heightAnchor)
        }

        rankingButton.layout {
            $0.centerYAnchor.constraint(equalTo: startButton.centerYAnchor)
            $0.leadingAnchor.constraint(equalTo: startButton.trailingAnchor, constant: 20)
            $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            $0.widthAnchor.constraint(equalTo: rankingButton.heightAnchor)
            $0.heightAnchor.constraint(equalTo: startButton.heightAnchor)
        }
        
        buyLivesButton.layout {
            $0.bottomAnchor.constraint(equalTo: currentLives.bottomAnchor, constant: -20)
            $0.centerXAnchor.constraint(equalTo: currentLivesLabel.centerXAnchor)
        }
        
        heartsStackView.layout {
            $0.bottomAnchor.constraint(equalTo: currentLives.bottomAnchor, constant: -20)
            $0.centerXAnchor.constraint(equalTo: currentLives.centerXAnchor)
        }
        
        heartsStackView.arrangedSubviews.forEach {
            $0.layout {
                $0.widthAnchor.constraint(equalToConstant: 32)
                $0.heightAnchor.constraint(equalTo: $0.widthAnchor)
            }
        }
    }
    
    func setupInfoViews(view: UIView) {
        view.backgroundColor = .nijiColors.lightGray
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 20
    }
    
    func configureAdditionalSettings() {
        backgroundColor = .black
        self.bringSubviewToFront(island)
    }
    
    func configure(highScore: Int, livesCount: Int) {
        highestScoreLabel.text = String(highScore)
        
        [buyLivesButton, heartsStackView].forEach { $0.isHidden = true }
        if livesCount == 0 {
            renderBuyLivesButton()
            return
        }
        renderHearts(livesCount: livesCount)
    }
    
    private func renderBuyLivesButton() {
        buyLivesButton.isHidden = false
    }
    
    private func renderHearts(livesCount: Int) {
        heartsStackView.isHidden = false
        heartsStackView.arrangedSubviews
            .enumerated()
            .forEach {
                if $0 + 1 <= livesCount {
                    $1.alpha = 1
                } else {
                    $1.alpha = 0.3
                }
            }
    }
    
    private func configureInfoViewText(title: UILabel) {
        title.font = .depot(24)
        title.textAlignment = .center
        title.textColor = .black
    }
    
    @objc
    private func handleStartTap() {
        actions.didTapOnStart()
    }
    
    @objc
    private func handleAudioSettingsTap() {
        actions.didTapOnAudioSettings()
    }
    
    @objc
    private func handleRankingTap() {
        actions.didTapOnRanking()
    }
 
    @objc
    private func handleBuyLivesTap() {
        actions.didTapOnBuyLives()
    }
}
