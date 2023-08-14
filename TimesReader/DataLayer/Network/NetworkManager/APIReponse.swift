
import Foundation
struct APIResponse<T: Decodable> {
    let status: String
    let copyRight: String
    let meta: Meta?
    var data: [T]?
}

extension APIResponse: Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        status = (try? container.decode(String.self, forKey: .status)) ?? ""
        copyRight = (try? container.decode(String.self, forKey: .copyRight)) ?? ""
        meta    = try?   container.decode(Meta.self,     forKey: .meta)
        
        if let dataArray = try container.decodeIfPresent([T].self, forKey: .data) {
            data = dataArray
        } else if let singleObject = try container.decodeIfPresent(T.self, forKey: .data) {
            data = [singleObject]
        } else {
            data = nil
        }
        
    }
}
private enum CodingKeys: String, CodingKey {
    case status
    case copyRight = "copyright"
    case meta = "fault"
    case data = "results"
}
