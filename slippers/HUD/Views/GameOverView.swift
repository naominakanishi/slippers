import UIKit

final class GameOverView: CodedView, CodedViewLifeCycle {
    struct Model {
        let currentScore: Int
        let highScore: Int
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
        view.axis = .horizontal
        view.distribution = .equalCentering
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
        view.configuration = .nijiRoundedRectangle(title: "BUY LIVES", imageName: "heart-icon")
        return view
    }()
    
    private lazy var watchAdButton: UIButton = {
        let view = UIButton()
        view.configuration = .nijiRoundedRectangle(title: "WATCH AD", imageName: "watch-ads-icon")
        return view
    }()
    
    private lazy var startOverButton: UIButton = {
        let view = UIButton()
        view.configuration = .nijiCapsule(title: "START OVER", imageName: "restart-icon")
        return view
    }()
    
    func addSubviews() {
        addSubview(cardView)
        cardView.addSubview(playerImageView)
        cardView.addSubview(scoresStackView)
        scoresStackView.addArrangedSubview(currentScoreView)
        scoresStackView.addArrangedSubview(highScoreView)
        cardView.addSubview(callToActionLabel)
        cardView.addSubview(watchAdButton)
        cardView.addSubview(buyLivesButton)
        cardView.addSubview(startOverButton)
    }
    
    func constraintSubviews() {
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
            $0.topAnchor.constraint(equalTo: playerImageView.bottomAnchor, constant: 20)
            $0.widthAnchor.constraint(equalTo: callToActionLabel.widthAnchor)
            $0.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
        }
        
        callToActionLabel.layout {
            $0.topAnchor.constraint(equalTo: scoresStackView.bottomAnchor, constant: 30)
            $0.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
        }
        
        buyLivesButton.layout {
            $0.topAnchor.constraint(equalTo: callToActionLabel.bottomAnchor, constant: 30)
            $0.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
            $0.widthAnchor.constraint(equalTo: callToActionLabel.widthAnchor)
        }
        
        watchAdButton.layout {
            $0.topAnchor.constraint(equalTo: buyLivesButton.bottomAnchor, constant: 30)
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
    }
}
