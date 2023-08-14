

import Foundation
import RxSwift
import AVKit

class NewsCoordinator: Coordinator<CoordinationResultType<Void>> {
    
    private let result = PublishSubject<CoordinationResultType<Void>>()
    private var root: UINavigationController!
    private let window: UIWindow
    private let newsDependancyContainer: NewsDependancyContainerType
    
    init(window: UIWindow,
         newsDependancyContainer: NewsDependancyContainerType) {
        
        self.window = window
        self.newsDependancyContainer = newsDependancyContainer
    }
    
    override func start() -> Observable<CoordinationResultType<Void>> {
        let viewModel = newsDependancyContainer.makeNewsViewModel()
        let viewController = newsDependancyContainer.makeNewsViewController(viewModel: viewModel)
        root = newsDependancyContainer.makeNewsNavigationController(rootViewController: viewController)
        self.window.rootViewController = root
        
        
        viewModel
            .outputs
            .newsDidSelect
            .subscribe(onNext: {[weak self] news in
                self?.navigateToNewsDetails(news: news, parentVC: viewController)
            }).disposed(by: disposeBag)
        
        
        return result
    }
    
    func navigateToNewsDetails(news: News, parentVC: UIViewController) {
        let viewModel = newsDependancyContainer.makeNewsDetailVCViewModel(news)
        let viewController = newsDependancyContainer.makeNewsDetailViewController(viewModel: viewModel)

        
        viewModel.outputs.showWeblink
            .subscribe(onNext: {[weak self] (title, url) in
                self?.navigateToAppWebView(title: title, webLink: url, parentVC: viewController)
        }).disposed(by: disposeBag)
        
        parentVC.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func navigateToAppWebView(title: String, webLink: URL?, parentVC: UIViewController) {
        let viewModel = newsDependancyContainer.makeAppWebViewVCViewModel(title, webLink: webLink)
        let viewController = newsDependancyContainer.makeAppWebViewController(viewModel: viewModel)
        parentVC.navigationController?.pushViewController(viewController, animated: true)
    }
}


protocol NewsDependancyContainerType {
    func makeNewsViewModel() -> NewsTableViewModelType
    func makeNewsViewController(viewModel: NewsTableViewModelType) -> NewsTableViewController
    func makeNewsNavigationController(rootViewController: NewsTableViewController) -> UINavigationController
    func makeNewsDetailVCViewModel(_ news: News) -> NewsDetailVCViewModelType
    func makeNewsDetailViewController(viewModel: NewsDetailVCViewModelType) -> NewsDetailViewController
    func makeAppWebViewVCViewModel(_ title: String, webLink: URL?) -> AppWebviewViewModelType
    func makeAppWebViewController(viewModel: AppWebviewViewModelType) -> AppWebviewViewController
}
