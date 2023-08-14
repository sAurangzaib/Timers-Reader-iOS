

import Foundation
import RxSwift
import RxSwiftExt
import RxDataSources
import RxCocoa

protocol NewsTableViewModelInputs {
    var viewDidLoadObserver: AnyObserver<Void> { get }
    var newsDidSelectObserver: AnyObserver<News> { get }
    var searchTextObserver: AnyObserver<String?> { get }
    var filtersObserver: AnyObserver<[String]> { get }
}

protocol NewsTableViewModelOutputs {
    var dataSource: Observable<[SectionModel<Int, ReusableTableViewCellViewModelType>]> { get }
    var copyrights: Observable<String> { get }
    var shouldDisplayEmpty: Observable<Bool> { get }
    var newsDidSelect: Observable<News> { get }
    var errorMessage: Observable<String> { get }
}

protocol NewsTableViewModelType {
    var inputs: NewsTableViewModelInputs { get }
    var outputs: NewsTableViewModelOutputs { get }
}

class NewsTableViewModel: NewsTableViewModelType, NewsTableViewModelInputs, NewsTableViewModelOutputs {
    
    var inputs: NewsTableViewModelInputs { self }
    var outputs: NewsTableViewModelOutputs { self }
    
    //MARK: Inputs
    var viewDidLoadObserver: AnyObserver<Void> { viewDidLoadSubject.asObserver() }
    var newsDidSelectObserver: AnyObserver<News> { newsDidSelectSubject.asObserver() }
    var searchTextObserver: AnyObserver<String?> { searchTextSubject.asObserver() }
    var filtersObserver: AnyObserver<[String]> { newsFiltersSubject.asObserver() }
    
    //MARK: Outputs
    var dataSource: Observable<[SectionModel<Int, ReusableTableViewCellViewModelType>]> { dataSourceSubject.asObservable() }
    var shouldDisplayEmpty: Observable<Bool> { shouldDisplayEmptySubject.asObservable() }
    var newsDidSelect: Observable<News> { newsDidSelectSubject.asObservable() }
    var copyrights: Observable<String> { copyrightsSubject.asObservable() }
    var errorMessage: Observable<String> { errorSubject.asObservable() }
    
    //MARK: Properties
    private let disposeBag = DisposeBag()
    private let viewDidLoadSubject = PublishSubject<Void>()
    private let searchTextSubject = PublishSubject<String?>()
    private let dataSourceSubject = BehaviorSubject<[SectionModel<Int, ReusableTableViewCellViewModelType>]>(value: [])
    private let shouldDisplayEmptySubject = BehaviorSubject<Bool>(value: false)
    private let errorSubject = PublishSubject<String>()
    private let newsSubject = PublishSubject<[News]>()
    private let newsDidSelectSubject = PublishSubject<News>()
    private let newsFiltersSubject = BehaviorSubject<[String]>(value: ["mostviewed", "all-sections", "7"])
    private let copyrightsSubject = PublishSubject<String>()
    
    private var newsList = [News]()
    private let service: APIServiceType
    
    init(service: APIServiceType) {
        self.service = service
        fetchNews()
        bindTiles()
    }
}

extension NewsTableViewModel {
    
    func bindTiles() {
                
        newsSubject.filter({$0.isEmpty})
            .map({$0.isEmpty})
            .do(onNext: {[weak self] _ in self?.dataSourceSubject.onNext([])})
            .bind(to: shouldDisplayEmptySubject)
            .disposed(by: disposeBag)
        
        newsSubject
            .filter({!$0.isEmpty})
            .do(onNext: {[weak self] _ in self?.shouldDisplayEmptySubject.onNext(false)})
            .map { news -> [ReusableTableViewCellViewModelType] in
                    news.map { NewsTVCViewModel($0) }
            }.map({ vm -> [SectionModel] in
                [SectionModel(model: 0, items: vm)]
            }).bind(to: dataSourceSubject)
            .disposed(by: disposeBag)
        

        searchTextSubject.subscribe(onNext: {[unowned self] text in
            if (text?.isEmptyOrNil ?? false) {
                self.newsSubject.onNext(self.newsList)
            } else {
                let nonOptional = text ?? ""
                let filteredNews = self.newsList.filter({$0.adxKeywords?.contains(nonOptional) ?? false})
                self.newsSubject.onNext(filteredNews)
            }
        }).disposed(by: disposeBag)
    }
    
    private func fetchNews() {

        let request = viewDidLoadSubject
            .withLatestFrom(newsFiltersSubject)
            .do(onNext: { _ in ProgressHud.showProgressHud() })
            .map({ NewsEndPoints.fetchNews(segments: $0)})
            .flatMap { [unowned self] in service.makeRequest($0, dataReturnType: News.self) }
            .do(onNext: { _ in ProgressHud.hideProgressHud() })
            .share()

            request.debug("Mock reposne").filter({$0.status.lowercased() == "ok"})
                .do(onNext: {[weak self] value in self?.copyrightsSubject.onNext(value.copyRight) })
                .map({$0.data}).unwrap()
                .do(onNext: {[weak self] value in self?.newsList = value })
                .bind(to: newsSubject)
                .disposed(by: disposeBag)
        
            request.filter({$0.status.lowercased() != "ok"})
                .map { $0.meta?.message ?? "Something went worng" }
                .bind(to: errorSubject)
                .disposed(by: disposeBag)
    }
}
