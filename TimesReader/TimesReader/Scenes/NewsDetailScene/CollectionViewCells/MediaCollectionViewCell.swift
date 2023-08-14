
import UIKit
import RxCocoa
import RxSwift

class MediaCollectionViewCell: RxUICollectionViewCell {
    
    //MARK: UI Components
    
    lazy var newsImageView: UIImageView = UIImageViewFactory.createImageView(backgroundColor: .systemGroupedBackground, cornerRadius: 5)
    
    // MARK: Properties
    private var viewModel: MediaCVCViewModelType?
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        guard let viewModel = viewModel as? MediaCVCViewModelType else { return }
        self.viewModel = viewModel
        bind(viewModel: viewModel)
    }
    
}

// MARK: View setup
extension MediaCollectionViewCell {
    
    func setupViews() {
        contentView.backgroundColor = .white
        [newsImageView].forEach(contentView.addSubview)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            contentView.trailingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 5),
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            contentView.bottomAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 5)
        ])
    }
    
}

// MARK: Binding
private extension MediaCollectionViewCell {
    func bind(viewModel: MediaCVCViewModelType) {
        viewModel.outputs
            .metaData.subscribe(onNext: {[weak self] meta in
                self?.newsImageView.loadImage(with: meta?.mediaURL, placeholder: "image-placeholder".toImage, showsIndicator: true)
            }).disposed(by: disposeBag)
    }
}
