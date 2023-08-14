
import Foundation
import UIKit
import RxSwift

class NewsDependancyContainer {
    
    init() {
    }
    
    func makeNewsViewModel() -> NewsTableViewModelType {
        return NewsTableViewModel(service: APIService())
    }
    
    func makeNewsViewController(viewModel: NewsTableViewModelType) -> NewsTableViewController {
        return NewsTableViewController(viewModel: viewModel)
    }
    
    func makeNewsNavigationController(rootViewController: NewsTableViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.navigationBar.backgroundColor = appThemeColor
        return nav
    }
    
    func makeNewsCoordinator(root: UIWindow) -> NewsCoordinator {
        
        return NewsCoordinator(window: root,
                               newsDependancyContainer: self)
    }
    
    func makeNewsDetailVCViewModel(_ news: News) -> NewsDetailVCViewModelType {
        return NewsDetailVCViewModel(news)
    }
    
    func makeNewsDetailViewController(viewModel: NewsDetailVCViewModelType) -> NewsDetailViewController {
        return NewsDetailViewController(viewModel: viewModel)
    }
    
    func makeAppWebViewVCViewModel(_ title: String, webLink: URL?) -> AppWebviewViewModelType {
        return AppWebviewViewModel(with: title, webURL: webLink)
    }
    
    func makeAppWebViewController(viewModel: AppWebviewViewModelType) -> AppWebviewViewController {
        return AppWebviewViewController(with: viewModel)
    }
}

extension NewsDependancyContainer: NewsDependancyContainerType {}
