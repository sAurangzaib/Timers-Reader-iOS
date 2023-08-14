
import Foundation
import RxSwift

protocol NewsTVCViewModelInputs {
    var imageDownloadErrorObserver: AnyObserver<Error?> { get }
}

protocol NewsTVCViewModelOutputs {
    var headline: Observable<String> { get }
    var userImage: Observable<URL?> { get }
    var subline: Observable<String> { get }
    var category: Observable<String> { get }
    var publishedDate: Observable<String> { get }
    var errorMessage: Observable<String> { get }
}

protocol NewsTVCViewModelType: ReusableTableViewCellViewModelType {
    var inputs: NewsTVCViewModelInputs { get }
    var outputs: NewsTVCViewModelOutputs { get }
}

class NewsTVCViewModel: NewsTVCViewModelType, NewsTVCViewModelInputs, NewsTVCViewModelOutputs, ReusableTableViewCellViewModelType {
    
    var reusableIdentifier: String = NewsTableViewCell.reuseIdentifier
    
    var inputs: NewsTVCViewModelInputs { return self }
    var outputs: NewsTVCViewModelOutputs { return self }
    
    //MARK: Inputs
    var imageDownloadErrorObserver: AnyObserver<Error?> { imageDownloadErrorSubject.asObserver() }
    
    //MARK: Outputs
    var headline: Observable<String> { headlineSubject.asObservable() }
    var userImage: Observable<URL?> { newsImageSubject.asObservable() }
    var subline: Observable<String> { sublineSubject.asObservable() }
    var category: Observable<String> { categorySubject.asObservable() }
    var publishedDate: Observable<String> { dateSubject.asObservable() }
    var errorMessage: Observable<String> { errorMessageSubject.asObservable() }
    
    //MARK: Subjects
    private let headlineSubject: BehaviorSubject<String>
    private let newsImageSubject: BehaviorSubject<URL?>
    private let sublineSubject: BehaviorSubject<String>
    private let categorySubject: BehaviorSubject<String>
    private let dateSubject: BehaviorSubject<String>
    private let imageDownloadErrorSubject = BehaviorSubject<Error?>(value: nil)
    private let errorMessageSubject = BehaviorSubject<String>(value: "")
    
    private let disposeBag = DisposeBag()
    private var images = NSCache<NSString, NSData>()
    var action: News
    init(_ news: News) {
        action = news
        headlineSubject = BehaviorSubject<String>(value: news.title ?? "")
        sublineSubject = BehaviorSubject<String>(value: news.byline ?? "")
        categorySubject = BehaviorSubject<String>(value: news.source ?? "")
        dateSubject = BehaviorSubject<String>(value: news.publishedDate ?? "")
        newsImageSubject = BehaviorSubject<URL?>(value: news.media?.first?.metaData?.first?.mediaURL)
        bindSubjects(news)
    }
}

extension NewsTVCViewModel {
    func bindSubjects(_ news: News) {
        imageDownloadErrorSubject.unwrap()
            .map { $0.localizedDescription}
            .bind(to: errorMessageSubject)
            .disposed(by: disposeBag)
    }
}
