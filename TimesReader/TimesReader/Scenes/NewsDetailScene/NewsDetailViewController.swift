
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class NewsDetailViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: UIcomponents
    
    lazy var titleView: UILabel = UILabelFactory.createUILabel(with: .white, textStyle: UIFont.systemFont(ofSize: 16, weight: .bold), text: "News Detail")
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: setLayout())
        collectionView.bounces = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .lightText
        collectionView.isDirectionalLockEnabled = true
        collectionView.configureForPeekingDelegate()
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: MediaCollectionViewCell.reuseIdentifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    lazy var titleLabel: UILabel = UILabelFactory.createUILabel(textStyle: UIFont.systemFont(ofSize: 16, weight: .bold), numberOfLines: 0)
    
    lazy var detailTitleLabel: UILabel = UILabelFactory.createUILabel(textStyle: UIFont.systemFont(ofSize: 14, weight: .bold), text: "News detail:")
    
    lazy var detailLabel: UILabel = UILabelFactory.createUILabel(textStyle: UIFont.systemFont(ofSize: 14, weight: .regular), numberOfLines: 0)
    
    lazy var visitWeb: UIButton = UIButtonFactory.createButton(image: "web_icon".toImage)
  
    lazy var stackView: UIStackView = UIStackViewFactory.createStackView(with: .vertical, distribution: .fill, spacing: 10)
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        scrollView.contentSize = self.view.frame.size
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let viewModel: NewsDetailVCViewModelType
    private let disposeBag = DisposeBag()
    private var dataSource: RxCollectionViewSectionedReloadDataSource<SectionModel<Int, ReusableCollectionViewCellViewModelType>>!

    
    init(viewModel: NewsDetailVCViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = contentView.frame.size
    }
}

extension NewsDetailViewController {
    
    private func setup() {
        setupViews()
        setupConstraints()
        bind(viewModel: viewModel)
    }
    
    private func setupViews() {
        self.navigationItem.titleView = titleView
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.view.backgroundColor = .white

        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
                
        [titleLabel, collectionView, detailTitleLabel, detailLabel, visitWeb, stackView].forEach(contentView.addSubview)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            // Add other constraints for the content inside contentView
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: 10),
            collectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            detailTitleLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 5),
            detailTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            detailTitleLabel.widthAnchor.constraint(equalToConstant: 110),
            detailTitleLabel.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            detailLabel.topAnchor.constraint(equalTo: detailTitleLabel.bottomAnchor, constant: 5),
            detailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            contentView.trailingAnchor.constraint(equalTo: detailLabel.trailingAnchor, constant: 10),
            detailLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 45)
        ])
        
        NSLayoutConstraint.activate([
            visitWeb.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 5),
            contentView.trailingAnchor.constraint(equalTo: visitWeb.trailingAnchor, constant: 15),
            visitWeb.widthAnchor.constraint(equalToConstant: 35),
            visitWeb.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10)
        ])
    }
    
    func setLayout() -> UICollectionViewFlowLayout{
        let flowLayout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        flowLayout.itemSize = CGSize(width: screenWidth, height: 200)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        return flowLayout
    }
}

extension NewsDetailViewController {
    
    private func bind(viewModel: NewsDetailVCViewModelType) {
        
        visitWeb.rx.tap
            .bind(to: viewModel.inputs.navigateToWeb)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .headline
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .subline
            .bind(to: detailLabel.rx.text)
            .disposed(by: disposeBag)
                
        viewModel.outputs
            .newsFacets.subscribe(onNext: {[weak self] fectes in
                self?.generateExpandableDetails(from: fectes)
            }).disposed(by: disposeBag)
        
        bindCollectionView()
    }
    
    func bindCollectionView() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        dataSource = RxCollectionViewSectionedReloadDataSource(configureCell: { (_, collection, indexPath, viewModel) in
            guard let cell = collection.dequeueReusableCell(withReuseIdentifier:
                                                                viewModel.reusableIdentifier, for: indexPath) as? RxUICollectionViewCell
            else { return UICollectionViewCell() }
            cell.configure(with: viewModel)
            return cell
        })
        
        viewModel.outputs.dataSource.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
}

extension NewsDetailViewController {
    
    func generateExpandableDetails(from fectes: [String: [String]]) {
        
        for fect in fectes {
            let view = ExpandableDetailView(title: fect.key, details: fect.value)
            stackView.addArrangedSubview(view)
        }
        
        DispatchQueue.main.async {
            self.view.layoutSubviews()
        }
    }
}
