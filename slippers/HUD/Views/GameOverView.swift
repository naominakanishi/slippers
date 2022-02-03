import UIKit

final class GameOverView: UIView, CodedViewLifeCycle {
    
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
        view.configuration = .nijiRoundedRectangle(title: "WATCH AD", imageName: "watch-ad-icon")
        return view
    }()
    
    private lazy var startOverButton: UIButton = {
        let view = UIButton()
        view.configuration = .nijiCapsule(title: "START OVER", imageName: "restart-icon")
        return view
    }()
    
    func addSubviews() {
        scoresStackView.addArrangedSubview(currentScoreView)
        scoresStackView.addArrangedSubview(highScoreView)
    }
    
    func constraintSubviews() {
            
    }
    
    func configureAdditionalSettings() {
        
    }
    
    
}

final class ScoreView: UIView, CodedViewLifeCycle {

    struct Model {
        let title: String
        let score: String
    }
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.font = .amatic(.bold, 36)
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    
    private lazy var scoreLabel: UILabel = {
        let view = UILabel()
        view.font = .amatic(.bold, 36)
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    
    func addSubviews() {
        addSubview(titleLabel)
        addSubview(scoreLabel)
    }
    
    func constraintSubviews() {
        titleLabel.layout {
            $0.topAnchor.constraint(equalTo: topAnchor)
            $0.centerXAnchor.constraint(equalTo: centerXAnchor)
        }
        
        scoreLabel.layout {
            $0.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12)
            $0.centerXAnchor.constraint(equalTo: centerXAnchor)
            $0.bottomAnchor.constraint(equalTo: bottomAnchor)
        }
    }
    
    func configureAdditionalSettings() {
        
    }
    
    
    func configure(using model: Model) {
        titleLabel.text = model.title
        scoreLabel.text = model.score
    }
}
