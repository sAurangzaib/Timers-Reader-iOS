

import Foundation
import UIKit

class UICollectionViewFlowLayoutFactory {
    static func createCollectionViewLayout(scrollDirection: UICollectionView.ScrollDirection,headerSize: CGSize = CGSize.zero,pinHeader: Bool = true, cellSize: CGSize, interIterSpacing: CGFloat, lineSpacing: CGFloat, edgeInsets: (top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat)) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        layout.headerReferenceSize = headerSize
        layout.sectionHeadersPinToVisibleBounds = pinHeader
        layout.itemSize = cellSize
        layout.minimumInteritemSpacing = interIterSpacing
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = UIEdgeInsets.init(top: edgeInsets.top, left: edgeInsets.left, bottom: edgeInsets.bottom, right: edgeInsets.right)
        return layout
    }
}

