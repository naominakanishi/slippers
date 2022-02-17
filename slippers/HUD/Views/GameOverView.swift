import UIKit

final class GameOverView: CodedView, CodedViewLifeCycle {
    
    struct Actions {
        let livesAction: () -> Void
        let watchAd: () -> Void
        let startOver: () -> Void
        let didTapOnBack: () -> Void
    }
    
    struct Model {
        let currentScore: Int
        let highScore: Int
        let livesButtonTitle: String
    }
    
    private lazy var currentScoreView = ScoreView()
    private lazy var highScoreView = ScoreView()
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 1
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    
    private lazy var playerImageView: UIImageView = {
        let view = UIImageView()
        view.image = .init(named: "player-falling")
        return view
    }()
    
    private lazy var scoresStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillProportionally
        return view
    }()
    
    private lazy var callToActionLabel: UILabel = {
        let view = UILabel()
        view.text = "DON'T WANNA LOSE YOUR SCORE?"
        view.font = .amatic(.bold, 28)
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    
    private lazy var buyLivesButton: UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(handleLivesTap), for: .touchUpInside)
        return view
    }()
    
    private lazy var watchAdButton: UIButton = {
        let view = UIButton()
        view.configuration = .nijiRoundedRectangle(title: "WATCH AD", imageName: "watch-ads-icon")
        view.addTarget(self, action: #selector(handleWatchAdTap), for: .touchUpInside)
        view.isHidden = true
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var startOverButton: UIButton = {
        let view = UIButton()
        view.configuration = .nijiCapsule(title: "START OVER", imageName: "restart-icon")
        view.addTarget(self, action: #selector(handleStartOverTap), for: .touchUpInside)
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let view = UIButton()
        view.configuration = .nijiText(
            title: "BACK TO MENU",
            leadingIcon: .init(systemName: "chevron.left"))
        view.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        return view
    }()
    
    
    private let actions: Actions
    
    init(actions: Actions) {
        self.actions = actions
        super.init(frame: .zero)
    }
    
    func addSubviews() {
        addSubview(cardView)
        addSubview(playerImageView)
        cardView.addSubview(scoresStackView)
        scoresStackView.addArrangedSubview(highScoreView)
        scoresStackView.addArrangedSubview(currentScoreView)
        cardView.addSubview(callToActionLabel)
        cardView.addSubview(watchAdButton)
        cardView.addSubview(buyLivesButton)
        cardView.addSubview(startOverButton)
        addSubview(backButton)
    }
    
    func constraintSubviews() {
        backButton.layout {
            $0.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20)
            $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        }
    
        cardView.layout {
            $0.centerXAnchor.constraint(equalTo: centerXAnchor)
            $0.centerYAnchor.constraint(equalTo: centerYAnchor)
            $0.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
        }
        
        playerImageView.layout {
            $0.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
            $0.centerYAnchor.constraint(equalTo: cardView.topAnchor)
            $0.heightAnchor.constraint(equalToConstant: 64)
            $0.widthAnchor.constraint(equalTo: $0.heightAnchor)
        }
        
        scoresStackView.layout {
            $0.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 30)
            $0.widthAnchor.constraint(equalTo: callToActionLabel.widthAnchor)
            $0.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
        }
        
        callToActionLabel.layout {
            $0.topAnchor.constraint(equalTo: scoresStackView.bottomAnchor, constant: 40).withPriority(.defaultLow)
            $0.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
        }
        
        buyLivesButton.layout {
            $0.topAnchor.constraint(equalTo: callToActionLabel.bottomAnchor, constant: 20)
            $0.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
            $0.widthAnchor.constraint(equalTo: callToActionLabel.widthAnchor)
        }
        
        watchAdButton.layout {
            $0.topAnchor.constraint(equalTo: buyLivesButton.bottomAnchor, constant: 20)
            $0.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
            $0.widthAnchor.constraint(equalTo: callToActionLabel.widthAnchor)
        }
        
        startOverButton.layout {
            $0.topAnchor.constraint(equalTo: watchAdButton.bottomAnchor, constant: 40)
            $0.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
            $0.bottomAnchor.constraint(
                greaterThanOrEqualTo: cardView.bottomAnchor,
                constant: -40)
        }
    }
    
    func configureAdditionalSettings() {
        backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    func configure(using model: Model) {
        highScoreView.configure(using: .init(
            title: "HIGH SCORE",
            score: .init(model.highScore)
        ))
        
        currentScoreView.configure(using: .init(
            title: "YOUR SCORE",
            score: .init(model.currentScore)))
        
        buyLivesButton.configuration = .nijiRoundedRectangle(title: model.livesButtonTitle,
                                                             imageName: "heart-icon")
    }
    
    @objc
    private func handleStartOverTap() {
        actions.startOver()
    }
    
    @objc func handleWatchAdTap() {
        actions.watchAd()
    }
    
    @objc
    private func handleLivesTap() {
        actions.livesAction()
    }
    
    @objc
    private func handleBackButton() {
        actions.didTapOnBack()
    }
}

extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> Self {
        self.priority = priority
        return self
    }
}
