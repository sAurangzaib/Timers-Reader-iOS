

import Foundation
import RxSwift

class RxUICollectionViewCell: UICollectionViewCell, ConfigurableTableViewCell {
    
    private(set) public var disposeBag = DisposeBag()
    var indexPath: IndexPath!
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configure(with viewModel: Any) {
        fatalError("Configure with viewModel must be implemented.")
    }
    
    func setIndexPath(_ indexPath: IndexPath) {
        self.indexPath = indexPath
    }
}
