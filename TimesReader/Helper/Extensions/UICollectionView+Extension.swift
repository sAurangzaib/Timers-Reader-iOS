//
//  UICollectionView+Extension.swift
//  TimesReader
//
//  Created by Aurangzaib on 13/08/2023.
//

import UIKit

extension UICollectionView {
    func configureForPeekingDelegate(scrollDirection: UICollectionView.ScrollDirection = .horizontal) {
        self.decelerationRate = .fast
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.isPagingEnabled = false
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = scrollDirection
    }
}
