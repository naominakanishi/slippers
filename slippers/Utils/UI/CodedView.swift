import UIKit

class CodedView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        if let self = self as? CodedViewLifeCycle {
            self.setupLifeCycle()
        }
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol CodedViewLifeCycle {
    func addSubviews()
    func constraintSubviews()
    func configureAdditionalSettings()
}

extension CodedViewLifeCycle {
    func setupLifeCycle() {
        addSubviews()
        constraintSubviews()
        configureAdditionalSettings()
    }
}
