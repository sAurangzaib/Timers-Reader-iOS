

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class NewsTableViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - UIComponents
    lazy var titleView: UILabel = UILabelFactory.createUILabel(with: .white, textStyle: UIFont.systemFont(ofSize: 16, weight: .bold), text: "NY Times Most Popular")
    
    lazy var searchbar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    lazy var popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .placeholderText
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var seachBarButton: UIBarButtonItem = UIBarButtonItemFactory.createBarButtonButton(image: "search-icon".toImage, targetIn: self, target: #selector(searchbarButtonTapped))
    
    lazy var tableView: UITableView = UITableViewFactory.createUITableView()
    
    lazy var copyrightLabel: UILabel = UILabelFactory.createUILabel(with: .placeholderText, textStyle: UIFont.systemFont(ofSize: 11, weight: .regular), alignment: .center, numberOfLines: 2)
    
    // MARK: - Properties
    let viewModel: NewsTableViewModelType
    private let disposeBag = DisposeBag()
    private var popViewHeightConstraint: NSLayoutConstraint!
    
    private var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<Int, ReusableTableViewCellViewModelType>>!
    
    
    init(viewModel: NewsTableViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension NewsTableViewController {
    
    private func setup() {
        setupViews()
        setupConstraints()
        bind(viewModel: viewModel)
    }
    
    private func setupViews() {
        popupView.addSubview(searchbar)
        [tableView, popupView, copyrightLabel].forEach(view.addSubview)
        
        self.view.backgroundColor = .white
        
        searchbar.delegate = self
        tableView.register(NewsTableViewCell.self,
                           forCellReuseIdentifier: NewsTableViewCell.reuseIdentifier)
        
        tableView.setupEmptyView(emptyView: CustomView(frame: tableView.bounds, message: "No record found."))
    }
    
    private func configureNavigationBar() {
        self.navigationItem.titleView = titleView
        navigationItem.setRightBarButton(seachBarButton, animated: true)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            popupView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: 0),
            popupView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            
            searchbar.topAnchor.constraint(equalTo: popupView.topAnchor),
            searchbar.leadingAnchor.constraint(equalTo: popupView.leadingAnchor),
            popupView.trailingAnchor.constraint(equalTo: searchbar.trailingAnchor),
            searchbar.bottomAnchor.constraint(equalTo: popupView.safeAreaLayoutGuide.bottomAnchor)
        ])
        // To handle hight
        popViewHeightConstraint = popupView.heightAnchor.constraint(equalToConstant: 0)
        popViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 10),
        ])
        
        NSLayoutConstraint.activate([
            copyrightLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 5),
            copyrightLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            view.trailingAnchor.constraint(equalTo: copyrightLabel.trailingAnchor, constant: 10),
            copyrightLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            copyrightLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

private extension NewsTableViewController {
    
    @objc func searchbarButtonTapped() {
        self.showPopupTextField(placeholder: "Search here...", value: "")
        self.setSearchbarHight(newHeight: 45)
    }
    
    func showPopupTextField(placeholder: String = "", value: String = "") {
        searchbar.placeholder = placeholder
        searchbar.text = value
        searchbar.becomeFirstResponder()
    }
    
    func hidePopupTextField() {
        setSearchbarHight(newHeight: 0)
        viewModel.inputs.searchTextObserver.onNext(searchbar.text)
        DispatchQueue.main.async {
            self.searchbar.text = nil
            self.view.endEditing(true)
        }
        
    }
    
    func setSearchbarHight(newHeight: CGFloat) {
        
        // Update the height constraint's constant to the new desired height
        popViewHeightConstraint.constant = newHeight
        
        // Trigger layout update to reflect the changes
        UIView.animate(withDuration: 0.3) {
            self.popupView.layoutIfNeeded()
        }
    }
    
    func emptyListView(shouldShow: Bool) {
        if shouldShow {
            tableView.showEmptyView()
        } else {
            tableView.hideEmptyView()
        }
    }
}

extension NewsTableViewController {
    
    private func bind(viewModel: NewsTableViewModelType) {
        viewModel.inputs.viewDidLoadObserver.onNext(())
        
        viewModel.outputs.shouldDisplayEmpty
            .subscribe(onNext: {[weak self] shouldShow in
                self?.emptyListView(shouldShow: shouldShow)
            }).disposed(by: disposeBag)
        
        
        viewModel.outputs
            .errorMessage
            .filter{ !$0.isEmpty }
            .bind(to: rx.showErrorMessage)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .copyrights
            .bind(to: copyrightLabel.rx.text)
            .disposed(by: disposeBag)
        
        bindTableView()
    }
    
    func bindTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        dataSource = RxTableViewSectionedReloadDataSource(configureCell: { (_, tableView, _, viewModel) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier:
                                                            viewModel.reusableIdentifier) as? RxUITableViewCell
            else { return UITableViewCell() }
            cell.configure(with: viewModel)
            return cell
        })
        
        
        viewModel.outputs.dataSource.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(NewsTVCViewModel.self)
            .map { $0.action }
            .bind(to: viewModel.inputs.newsDidSelectObserver)
            .disposed(by: disposeBag)
    }
}

extension NewsTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            hidePopupTextField()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputs.searchTextObserver.onNext(searchbar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        hidePopupTextField()
    }
}
