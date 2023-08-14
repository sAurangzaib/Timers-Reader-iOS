

import Foundation

enum CoordinationResultType<T> {
    case success(T)
    case cancel
    
    var isCancel: Bool {
        if case CoordinationResultType.cancel = self {
            return true
        }
        return false
    }
    
    var isSuccess: T? {
        guard !isCancel else { return nil }
        if case let CoordinationResultType.success(value) = self {
            return value
        }
        return nil
    }
}
