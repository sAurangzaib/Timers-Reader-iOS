
import UIKit

class UICollectionViewFactory {
    
   static func createCollectionView(layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout(), backgroundColor: UIColor = .white, scrollDirection: UICollectionView.ScrollDirection = .vertical, showScrollIndicators: Bool = false) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = backgroundColor
        collectionView.showsVerticalScrollIndicator = showScrollIndicators
        collectionView.showsHorizontalScrollIndicator = showScrollIndicators
        collectionView.translatesAutoresizingMaskIntoConstraints = false
       
        return collectionView
    }
    
}
