

import UIKit
import RxSwift
import RxCocoa
public protocol URLRequestConvertible {
    /// Returns a `URLRequest` or throws if an `Error` was encountered.
    ///
    /// - Returns: A `URLRequest`.
    /// - Throws:  Any error thrown while constructing the `URLRequest`.
    func asURLRequest() throws -> URLRequest
}

extension URLRequestConvertible {
    /// The `URLRequest` returned by discarding any `Error` encountered.
    public var urlRequest: URLRequest? { try? asURLRequest() }
}

extension URLRequest: URLRequestConvertible {
    /// Returns `self`.
    public func asURLRequest() throws -> URLRequest { self }
}

extension URLRequest {
    /// Returns the `httpMethod` as Alamofire's `HTTPMethod` type.
    public var method: HTTPMethod? {
        get { httpMethod.flatMap(HTTPMethod.init) }
        set { httpMethod = newValue?.rawValue }
    }

    public func validate() throws {
        if method == .get, let bodyData = httpBody {
            throw NSError(domain: "URL resuest failed\(bodyData)", code: 404, userInfo: [:])
        }
    }
}

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var queryParameters: Parameters? { get }
    var parameters: Parameters? { get }
}

enum ContentType: String {
    case json = "application/json"
}



enum NewsEndPoints: APIConfiguration {
    
    case fetchNews(segments: [String])
    
    // MARK: HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .fetchNews:
            return .get
        }
    }
    
    // MARK: Path
    var path: String {
        switch self {
        case .fetchNews(let segments):
            let values = segments.joined(separator: "/")
            return "\(values).json"
        }
    }
    
    // MARK: Query Parameters
    var queryParameters: [String: Any]? {
        switch self {
        case .fetchNews:
            var params: [String: Any] = [:]
            params["api-key"] = apiKey
            return params
        }
    }
    
    
    // MARK: Parameters
    var parameters: [String: Any]? {
        switch self {
        case .fetchNews:
            let params: [String: Any] = [:]
            return params
        }
    }
    
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: baseURL) else {
            throw NSError(domain: "API", code: 404, userInfo: nil)
        }
        var urlComponents = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: false)

        
        if let queryParameters = queryParameters {
            urlComponents?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value as? String) }
        }
        
        guard let composedURL = urlComponents?.url else {
            throw NSError(domain: "InvalidURL", code: 404, userInfo: nil)
        }
        
        var urlRequest = URLRequest(url: composedURL)
        urlRequest.httpMethod = method.rawValue
        
        if let parameters = parameters {
            do {
                debugPrint("--------- Request --------")
                debugPrint("URL: \(composedURL)")
                debugPrint("Parmas: \(parameters)")
                debugPrint("Type: \(method.rawValue)")
                debugPrint("--------------------------")
                
                if method.rawValue != "GET" {
                    urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
                } else {
                    urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
                }
            } catch {
                throw NSError(domain: "Encoding fail", code: 404, userInfo: nil)
            }
        }
        return urlRequest
    }
}
