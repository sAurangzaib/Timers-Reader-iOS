
import UIKit
import RxSwift

class AppDependancyContainer {
    
    init() { }
    
    func makeAppCoordinator(root: UIWindow) -> AppCoordinator {
        
        return AppCoordinator(root: root,
                              appFactory: self)
    }
    
    func makeLaunchViewModel() -> LaunchViewModelType {
        return LaunchViewModel("Times Reader")
    }
    
    func makeLaunchViewController(viewModel: LaunchViewModelType) -> LaunchViewController {
        return LaunchViewController(viewModel: viewModel)
    }
    
    func makeLaunchNavigationController(rootViewController: LaunchViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.isNavigationBarHidden = true
        return nav
    }
    
    func makeNewsCoordinator(root: UIWindow) -> NewsCoordinator {
        let newsDependancyContainer = self.makeNewsDependancyContainer()
        return newsDependancyContainer.makeNewsCoordinator(root: root)
    }
    
    func makeNewsDependancyContainer() -> NewsDependancyContainer {
        return NewsDependancyContainer()
    }
}

