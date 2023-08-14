
import Foundation
import RxSwift

protocol LaunchViewModelInputs {
    var viewDidAppearObserver: AnyObserver<Void> { get }
}

protocol LaunchViewModelOutputs {
    var title: Observable<String> { get }
    var viewDidAppear: Observable<Void> { get }
}

protocol LaunchViewModelType {
    var inputs: LaunchViewModelInputs { get }
    var outputs: LaunchViewModelOutputs { get }
}

class LaunchViewModel: LaunchViewModelType, LaunchViewModelInputs, LaunchViewModelOutputs {
        
    var inputs: LaunchViewModelInputs { return self }
    var outputs: LaunchViewModelOutputs { return self }
    
    //MARK: Inputs
    var viewDidAppearObserver: AnyObserver<Void> { viewDidAppearSubject.asObserver() }
    
    //MARK: Outputs
    var title: Observable<String> { titleSubject.asObservable() }
    var viewDidAppear: Observable<Void> { viewDidAppearSubject.asObservable() }
    
    
    private let disposeBag = DisposeBag()
    private let titleSubject: BehaviorSubject<String>
    private let viewDidAppearSubject = PublishSubject<Void>()
    
    init(_ title: String) {
        titleSubject = BehaviorSubject<String>(value: title)
    }
}

extension LaunchViewModel {
    
}
