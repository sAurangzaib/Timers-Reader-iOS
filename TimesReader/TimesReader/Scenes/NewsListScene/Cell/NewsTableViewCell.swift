
import UIKit
import RxCocoa
import RxSwift

class NewsTableViewCell: RxUITableViewCell {
    
    lazy var imageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var userImageView: UIImageView = UIImageViewFactory.createImageView()
    
    lazy var headlineLabel: UILabel = UILabelFactory.createUILabel(textStyle: UIFont.systemFont(ofSize: 16, weight: .bold), numberOfLines: 2)
    
    lazy var sublineLabel: UILabel = UILabelFactory.createUILabel(textStyle: UIFont.systemFont(ofSize: 16, weight: .regular), numberOfLines: 0)
    
    lazy var categoryLabel: UILabel = UILabelFactory.createUILabel(with: .lightGray, textStyle: UIFont.systemFont(ofSize: 14, weight: .regular))
    
    lazy var canlenderIcon: UIImageView = UIImageViewFactory.createImageView(image: "calendar-icon".toImage)
    
    lazy var dateLabel: UILabel = UILabelFactory.createUILabel(textStyle: UIFont.systemFont(ofSize: 13, weight: .regular))
    
    lazy var dateStackView: UIStackView = UIStackViewFactory.createStackView(with: .horizontal, alignment: .fill, distribution: .fill, spacing: 5, arrangedSubviews: [canlenderIcon, dateLabel])
    
    // MARK: Properties
    private var viewModel: NewsTVCViewModelType?
    
    // MARK: Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func commonInit() {
        setupViews()
        setupConstraints()
    }
    
    // MARK: Configuration
    override func configure(with viewModel: Any) {
        guard let viewModel = viewModel as? NewsTVCViewModelType else { return }
        self.viewModel = viewModel
        bind(viewModel: viewModel)
    }
    
}

// MARK: View setup
extension NewsTableViewCell {
    
    func setupViews() {
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        contentView.backgroundColor = .white
        imageContainerView.addSubview(userImageView)
        [imageContainerView, headlineLabel, sublineLabel, categoryLabel, dateStackView].forEach(contentView.addSubview)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            imageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imageContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            imageContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            imageContainerView.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            userImageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            userImageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            userImageView.heightAnchor.constraint(equalToConstant: 50),
            userImageView.widthAnchor.constraint(equalToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            headlineLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            headlineLabel.leadingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: headlineLabel.trailingAnchor, constant: 5),
            headlineLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 45)
        ])

        NSLayoutConstraint.activate([
            sublineLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 5),
            sublineLabel.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor),
            sublineLabel.trailingAnchor.constraint(equalTo: headlineLabel.trailingAnchor),
            sublineLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 45)
        ])

        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: sublineLabel.bottomAnchor, constant: 5),
            categoryLabel.leadingAnchor.constraint(equalTo: sublineLabel.leadingAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: 10),
            categoryLabel.heightAnchor.constraint(equalToConstant: 25)
        ])

        NSLayoutConstraint.activate([
            dateStackView.topAnchor.constraint(equalTo: sublineLabel.bottomAnchor, constant: 5),
            dateStackView.trailingAnchor.constraint(equalTo: sublineLabel.trailingAnchor),
            dateStackView.heightAnchor.constraint(equalToConstant: 15),

            canlenderIcon.widthAnchor.constraint(equalToConstant: 15)
        ])

        DispatchQueue.main.async {
            self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2
            self.contentView.layoutIfNeeded()
        }
    }
    
}

// MARK: Binding
private extension NewsTableViewCell {
    func bind(viewModel: NewsTVCViewModelType) {
        
        viewModel.outputs
            .headline
            .bind(to: headlineLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .userImage.subscribe(onNext: {[weak self] url in
                self?.userImageView.loadImage(with: url, placeholder: "image-placeholder".toImage, showsIndicator: true)
            }).disposed(by: disposeBag)
        
        viewModel.outputs
            .subline
            .bind(to: sublineLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .category
            .bind(to: categoryLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .publishedDate
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
