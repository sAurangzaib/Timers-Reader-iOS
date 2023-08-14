//
//  NewsListViewModelTests.swift
//  TimesReaderTests
//
//  Created by Aurangzaib on 14/08/2023.
//

import XCTest
import RxSwift
import RxCocoa
import RxDataSources
import RxTest

@testable import TimesReader

final class NewsListViewModelTests: XCTestCase {

    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchNewSuccessAndSetDatasourceCase() {
        // Setup Mock API response and Service
        let mockNews = News.mock()
        let mockResponse: APIResponse<News> = APIResponse(status: "ok", copyRight: "", meta: nil, data: [mockNews])
        let mockService = MockAPIService()
        mockService.mockResponse = .success(mockResponse)

        // Setup ViewModel with the mock service
        let viewModel = NewsTableViewModel(service: mockService)

        // Trigger viewDidLoad
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: viewModel.inputs.viewDidLoadObserver)
            .disposed(by: disposeBag)

        // Expected values
        let expectedDataSource: [SectionModel<Int, ReusableTableViewCellViewModelType>] = [
            // Assuming NewsTVCViewModel is used in the data source
            SectionModel(model: 0, items: [NewsTVCViewModel(mockNews)])
        ]

        // Create an observer to record emitted events
        let observer = scheduler.createObserver([SectionModel<Int, ReusableTableViewCellViewModelType>].self)

        // Bind the viewModel's dataSource output to the observer
        viewModel.outputs.dataSource
            .bind(to: observer)
            .disposed(by: disposeBag)

        // Start the scheduler
        scheduler.start()

        // Assert the expected outputs
        let recordedEvents = observer.events.last

        // Assert the expected outputs
        let recordedDataSource = recordedEvents?.value.element ?? []
        XCTAssertEqual(recordedDataSource.count, expectedDataSource.count)
    }
    
    func testNewsAPIFailureAndErrorHandlingCase() {
        // Setup Mock API response and Service
        let mockError = APIError.requestFailed
        let mockService = MockAPIService()
        mockService.mockResponse = .failure(mockError)

        // Setup ViewModel with the mock service
        let viewModel = NewsTableViewModel(service: mockService)

        // Trigger an event that would lead to the error scenario
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: viewModel.inputs.viewDidLoadObserver)
            .disposed(by: disposeBag)

        // Expected error
        let expectedError = mockError

        // Create an observer to record emitted error events
        let observer = scheduler.createObserver(APIError.self)

        // Bind the viewModel's errorMessage output to the observer
        viewModel.outputs.errorMessage
            .map { _ in mockError } // Map the error message to a common error for comparison
            .bind(to: observer)
            .disposed(by: disposeBag)

        // Start the scheduler
        scheduler.start()

        // Assert the expected error
        let recordedEvents = observer.events.last
        XCTAssertEqual(recordedEvents?.value.element, expectedError)
    }

}


class MockAPIService: APIServiceType {
    var mockResponse: Result<Any, Error>?

    func makeRequest<ReturnedObject: Decodable>(_ request: APIConfiguration, dataReturnType: ReturnedObject.Type) -> Observable<APIResponse<ReturnedObject>>{
        return Observable.create { observer in
            guard let mockResponse = self.mockResponse else {
                observer.onError(APIError.requestFailed)
                return Disposables.create()
            }
            switch mockResponse {
            case .success(let value):
                print("Mock success")
                if let response = value as? APIResponse<ReturnedObject> {
                    observer.onNext(response)
                    observer.onCompleted()
                } else {
                    observer.onError(APIError.requestFailed)
                    observer.onCompleted()
                }
            case .failure(let error):
                print("Mock failure \(error)")
                let errorMeta = Meta(code: 0, message: error.localizedDescription)
                let apiResponse = APIResponse<ReturnedObject>(status: "Fail", copyRight: "", meta: errorMeta, data: nil)
                observer.onNext(apiResponse)
                observer.onCompleted()
            }

            return Disposables.create()
        }
    }
}
