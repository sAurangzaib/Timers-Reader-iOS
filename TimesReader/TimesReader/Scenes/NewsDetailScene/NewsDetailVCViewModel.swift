

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol NewsDetailVCViewModelInputs {
    var navigateToWeb: AnyObserver<Void> { get }
}

protocol NewsDetailVCViewModelOutputs {
    var headline: Observable<String> { get }
    var subline: Observable<String> { get }
    var dataSource: Observable<[SectionModel<Int, ReusableCollectionViewCellViewModelType>]> { get }
    var newsFacets: Observable<[String: [String]]> { get }
    var showWeblink: Observable<(String, URL?)> { get }
}

protocol NewsDetailVCViewModelType {
    var inputs: NewsDetailVCViewModelInputs { get }
    var outputs: NewsDetailVCViewModelOutputs { get }
}

class NewsDetailVCViewModel: NewsDetailVCViewModelType, NewsDetailVCViewModelInputs, NewsDetailVCViewModelOutputs {
    
    var inputs: NewsDetailVCViewModelInputs { self }
    var outputs: NewsDetailVCViewModelOutputs { self }
    
    //MARK: Inputs
    var navigateToWeb: AnyObserver<Void> { navigateToWebSubject.asObserver() }
    
    //MARK: Outputs
    var headline: Observable<String> { headlineSubject.asObservable() }
    var subline: Observable<String> { sublineSubject.asObservable() }
    var dataSource: Observable<[SectionModel<Int, ReusableCollectionViewCellViewModelType>]> { dataSourceSubject.asObservable() }
    var newsFacets: Observable<[String: [String]]> { newsFacetsSubject.asObservable() }
    var showWeblink: Observable<(String, URL?)> { webLinkSubject.asObservable() }
    
    //MARK: Subjects
    private let headlineSubject = BehaviorSubject<String>(value: "")
    private let sublineSubject = BehaviorSubject<String>(value: "")
    private let newsFacetsSubject = BehaviorSubject<[String: [String]]>(value: [:])
    private let dataSourceSubject = BehaviorSubject<[SectionModel<Int, ReusableCollectionViewCellViewModelType>]>(value: [])
    private var navigateToWebSubject = PublishSubject<Void>()
    private var webLinkSubject = BehaviorSubject<(String, URL?)>(value: ("Web detail", nil))
        
    private let disposeBag = DisposeBag()
    
    init(_ news: News) {
        headlineSubject.onNext(news.title ?? "")
        sublineSubject.onNext(news.abstract ?? "")
        bindSubjects(news)
    }
}

private extension NewsDetailVCViewModel {
    
    func bindSubjects(_ news: News) {
        prepareMedia(news)
        prepareFectes(news)
        
        navigateToWebSubject.subscribe(onNext: {[weak self] _ in
            self?.webLinkSubject.onNext(("Web detail", news.webLink))
        }).disposed(by: disposeBag)
    }
    
    func prepareMedia(_ news: News) {
        var cellsViewModel = [ReusableCollectionViewCellViewModelType]()
        
        if let mediaList = news.media {
            for media in mediaList {
                let cellVM = MediaCVCViewModel(media)
                cellsViewModel.append(cellVM)
            }
        }
        if !cellsViewModel.isEmpty {
            dataSourceSubject.onNext([SectionModel(model: 0, items: cellsViewModel)])
        } else {
            // NO image found
        }
    }
    
    func prepareFectes(_ news: News) {
        var fectes: [String: [String]] = [:]
        
        if let desFacet = news.desFacets, !desFacet.isEmpty {
            fectes["Descriptive Facets"] = desFacet
        }
        
        if let orgFacets = news.orgFacets, !orgFacets.isEmpty {
            fectes["Organizational Facets"] = orgFacets
        }
        
        if let perFacets = news.perFacets, !perFacets.isEmpty {
            fectes["Person Facets"] = perFacets
        }
        
        if let geoFacets = news.geoFacets, !geoFacets.isEmpty {
            fectes["Person Facets"] = geoFacets
        }
        
        if !fectes.isEmpty {
            newsFacetsSubject.onNext(fectes)
        }
    }
}
