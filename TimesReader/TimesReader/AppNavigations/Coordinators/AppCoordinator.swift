

import Foundation
import RxSwift

class AppCoordinator: Coordinator<CoordinationResultType<Void>> {
    
    private let result = PublishSubject<CoordinationResultType<Void>>()
    private let root: UIWindow
    private let appFactory: AppDependancyContainer
    
    init(root: UIWindow,
         appFactory: AppDependancyContainer) {
        
        self.root = root
        self.appFactory = appFactory
    }
    
    override func start() -> Observable<CoordinationResultType<Void>> {
    
        let viewModel = self.appFactory.makeLaunchViewModel()
        let viewController = self.appFactory.makeLaunchViewController(viewModel: viewModel)
        let nav = self.appFactory.makeLaunchNavigationController(rootViewController: viewController)
        self.root.rootViewController = nav
        
        viewModel.outputs.viewDidAppear.subscribe(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.navigateToNewsList(root: self.root)
        }).disposed(by: disposeBag)
        
        return result
    }
}

extension AppCoordinator {
    
    func navigateToNewsList(root: UIWindow) {
        let coordinator = self.appFactory.makeNewsCoordinator(root: root)
        self.coordinate(to: coordinator)
            .subscribe()
            .disposed(by: disposeBag)
    }
}
