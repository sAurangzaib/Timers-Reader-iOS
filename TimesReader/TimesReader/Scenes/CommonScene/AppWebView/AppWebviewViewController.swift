
import UIKit
import WebKit
import RxSwift

class AppWebviewViewController: UIViewController {
    
    // MARK: - UI Components
    
    lazy var titleView: UILabel = UILabelFactory.createUILabel(with: .white, textStyle: UIFont.systemFont(ofSize: 16, weight: .bold), text: "Web link")
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate  = self
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private lazy var webContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Perperties
    private var disposeBag = DisposeBag()
    private var viewModel: AppWebviewViewModelType!
    
    // MARK: - Initializaiton
    
    init(with viewModel: AppWebviewViewModelType) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
}

// MARK: - View setup
private extension AppWebviewViewController {
    
    func commonInit() {
        navgationBarSetup()
        setupViews()
        setupConstraints()
        bindViews()
    }
    
    func navgationBarSetup() {
        self.navigationItem.titleView = titleView
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        view.backgroundColor = .white
    }
    
    func setupViews() {
        self.view.addSubview(self.webView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: webView.trailingAnchor, constant: 0),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: webView.bottomAnchor, constant: 0)
        ])
    }
    
    func bindViews() {
        
        viewModel.outputs
            .navigationTitleText
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        viewModel.outputs
            .webLink
            .unwrap()
            .subscribe(onNext: {[weak self] url in
                guard let self = self else { return }
                self.webView.load(URLRequest(url: url))
            }).disposed(by: disposeBag)
        
        viewModel.outputs
            .requestError
            .delay(.microseconds(0), scheduler: MainScheduler.instance)
            .bind(to: rx.showErrorMessage)
            .disposed(by: disposeBag)
    }
}

extension AppWebviewViewController: WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        ProgressHud.showProgressHud()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ProgressHud.hideProgressHud()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        viewModel.inputs.requestErrorObserver.onNext(error.localizedDescription)
    }
}
