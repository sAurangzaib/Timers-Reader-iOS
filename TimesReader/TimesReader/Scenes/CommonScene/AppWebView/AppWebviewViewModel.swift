

import Foundation
import RxSwift

protocol AppWebviewViewModelInput {
    var requestErrorObserver: AnyObserver<String> { get }
}

protocol AppWebviewViewModelOutput {
    var navigationTitleText: Observable<String> { get }
    var webLink: Observable<URL?> { get }
    var requestError: Observable<String> { get }
}

protocol AppWebviewViewModelType {
    var inputs: AppWebviewViewModelInput { get }
    var outputs: AppWebviewViewModelOutput { get }
}

class AppWebviewViewModel: AppWebviewViewModelInput, AppWebviewViewModelOutput, AppWebviewViewModelType {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    
    var inputs: AppWebviewViewModelInput { self }
    var outputs: AppWebviewViewModelOutput { self}
    
    // MARK: - Subjects
    private var navigationTitleTextSubject: BehaviorSubject<String>
    private var webLinkSubject = BehaviorSubject<URL?>(value: nil)
    private var requestErrorSubject = PublishSubject<String>()
    
    // MARK: - Inputs
    var requestErrorObserver: AnyObserver<String> { requestErrorSubject.asObserver() }
    
    // MARK: - Outputs
    var navigationTitleText: Observable<String> { navigationTitleTextSubject.asObservable() }
    var webLink: Observable<URL?> { webLinkSubject.asObservable() }
    var requestError: Observable<String> { requestErrorSubject.asObservable() }
    
    init(with title: String, webURL: URL?) {
        navigationTitleTextSubject = BehaviorSubject<String>(value: title)
        webLinkSubject.onNext(webURL)
    }
    
}
