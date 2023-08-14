

import Foundation
import UIKit

protocol DequeueInitializable {
    static var reuseIdentifier: String { get }
}

extension DequeueInitializable where Self: UITableViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension DequeueInitializable where Self: UICollectionViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}


extension UITableViewCell: DequeueInitializable { }
extension UICollectionViewCell: DequeueInitializable { }
