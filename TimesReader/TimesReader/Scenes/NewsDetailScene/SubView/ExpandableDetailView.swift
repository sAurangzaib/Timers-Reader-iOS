

import Foundation
import UIKit
import RxSwift


class ExpandableDetailView: UIView {
    
    // MARK: UIComponents
    
    private lazy var titleLabel: UILabel = UILabelFactory.createUILabel(textStyle: UIFont.systemFont(ofSize: 16, weight: .bold), numberOfLines: 0)
    
    private lazy var subTitleLabel: UILabel = UILabelFactory.createUILabel(textStyle: UIFont.systemFont(ofSize: 16, weight: .regular), numberOfLines: 0)
    
    private lazy var stackView: UIStackView = UIStackViewFactory.createStackView(with: .vertical, distribution: .fill, spacing: 5)
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    convenience init(title: String, details: [String] = []) {
        self.init(frame: .zero)
        self.titleLabel.text = title
        self.addSubViews(for: details)
        
    }
    
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        setupViews()
        setupConstraints()
    }
    
    private func addSubViews(for details: [String]) {
        for detail in details {
            let titleLabel: UILabel = UILabelFactory.createUILabel(textStyle: UIFont.systemFont(ofSize: 12, weight: .regular), numberOfLines: 0, text: "• \(detail)")
            stackView.addArrangedSubview(titleLabel)
        }
    }
}

// MARK: - View setup
private extension ExpandableDetailView {
    func setupViews() {
        [titleLabel, stackView].forEach(addSubview)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            self.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 5),
            titleLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 45)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])
    }
}

