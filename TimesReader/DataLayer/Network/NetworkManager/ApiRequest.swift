

import Foundation
import RxSwift

enum APIError: Error {
    case requestFailed
    case invalidData
    case unknown
}

protocol APIServiceType {
    func makeRequest<ReturnedObject: Decodable>(_ request: APIConfiguration, dataReturnType: ReturnedObject.Type) -> Observable<APIResponse<ReturnedObject>>
}

class APIService: APIServiceType {
    
    func makeRequest<ReturnedObject: Decodable>(_ request: APIConfiguration, dataReturnType: ReturnedObject.Type) -> Observable<APIResponse<ReturnedObject>> {
        
        return Observable.create { observer in
            do {
                let apiService = try request.asURLRequest()
                let task = URLSession.shared.dataTask(with: apiService) { data, response, error in
                    guard let data = data, error == nil else {
                        observer.onError(APIError.requestFailed)
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let apiResponse = try decoder.decode(APIResponse<ReturnedObject>.self, from: data)
                        observer.onNext(apiResponse)
                        observer.onCompleted()
                    } catch(let error) {
                        print(error)
                        let errorMeta = Meta(code: 0, message: error.localizedDescription)
                        let apiResponse = APIResponse<ReturnedObject>(status: "Fail", copyRight: "", meta: errorMeta, data: nil)
                        observer.onNext(apiResponse)
                        observer.onCompleted()
                    }
                }
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
            }catch {
                observer.onError(error)
                return Disposables.create()
            }
        }
    }
}
