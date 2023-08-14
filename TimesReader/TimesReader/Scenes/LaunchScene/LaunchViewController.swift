

import UIKit
import RxSwift
import RxCocoa
import PDFKit

class LaunchViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let viewModel: LaunchViewModelType
    private let disposeBag = DisposeBag()
    
    init(viewModel: LaunchViewModelType) {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.viewModel.inputs.viewDidAppearObserver.onNext(())
        }
    }
    
}

extension LaunchViewController {
    
    private func setup() {
        setupViews()
        setupConstraints()
        bind(viewModel: viewModel)
    }
    
    private func setupViews() {
        view.backgroundColor = .cyan
        view.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
    }
}

extension LaunchViewController {
    
    private func bind(viewModel: LaunchViewModelType) {
        
        viewModel.outputs
            .title
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
