
import Foundation
import RxSwift

protocol MediaCVCViewModelInputs {
    var imageDownloadErrorObserver: AnyObserver<Error?> { get }
}

protocol MediaCVCViewModelOutputs {
    var metaData: Observable<MediaMeta?> { get }
    var subline: Observable<String> { get }
    var errorMessage: Observable<String> { get }
}

protocol MediaCVCViewModelType: ReusableCollectionViewCellViewModelType {
    var inputs: MediaCVCViewModelInputs { get }
    var outputs: MediaCVCViewModelOutputs { get }
}

class MediaCVCViewModel: MediaCVCViewModelType, MediaCVCViewModelInputs, MediaCVCViewModelOutputs {
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    var reusableIdentifier: String = MediaCollectionViewCell.reuseIdentifier
    var inputs: MediaCVCViewModelInputs { return self }
    var outputs: MediaCVCViewModelOutputs { return self }
    
    //MARK: Inputs
    var imageDownloadErrorObserver: AnyObserver<Error?> { imageDownloadErrorSubject.asObserver() }
    
    //MARK: Outputs
    var metaData: Observable<MediaMeta?> { metaDataSubject.asObservable() }
    var subline: Observable<String> { sublineSubject.asObservable() }
    var errorMessage: Observable<String> { errorMessageSubject.asObservable() }
    
    //MARK: Subjects
    private let metaDataSubject: BehaviorSubject<MediaMeta?>
    private let sublineSubject: BehaviorSubject<String>
    private let imageDownloadErrorSubject = BehaviorSubject<Error?>(value: nil)
    private let errorMessageSubject = BehaviorSubject<String>(value: "")
    
    init(_ media: NewsMedia) {
        let meta = media.metaData?.first(where: {$0.format == .threeByTow440}) ?? media.metaData?.first
        metaDataSubject = BehaviorSubject<MediaMeta?>(value: meta)
        sublineSubject = BehaviorSubject<String>(value: "")
        bindSubjects()
    }
}

extension MediaCVCViewModel {
    func bindSubjects() {
        
    }
}
