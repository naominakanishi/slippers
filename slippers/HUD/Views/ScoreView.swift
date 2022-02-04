import UIKit

final class ScoreView: CodedView, CodedViewLifeCycle {

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
            $0.leadingAnchor.constraint(equalTo: leadingAnchor)
            $0.trailingAnchor.constraint(equalTo: trailingAnchor)
        }
        
        scoreLabel.layout {
            $0.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12)
            $0.leadingAnchor.constraint(equalTo: leadingAnchor)
            $0.trailingAnchor.constraint(equalTo: trailingAnchor)
            $0.bottomAnchor.constraint(equalTo: bottomAnchor)
        }
    }
    
    func configureAdditionalSettings() {}
    
    func configure(using model: Model) {
        titleLabel.text = model.title
        scoreLabel.text = model.score
    }
}
