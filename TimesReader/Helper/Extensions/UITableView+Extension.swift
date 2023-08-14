//
//  UITableView+Extension.swift
//  TimesReader
//
//  Created by Aurangzaib on 13/08/2023.
//

import UIKit

extension UITableView {
    
    func setupEmptyView(emptyView: CustomView) {
        DispatchQueue.main.async {
            self.backgroundView = emptyView
            self.backgroundView?.isHidden = true
        }
    }
    
    func showEmptyView() {
        DispatchQueue.main.async {
            guard let emptyView = self.backgroundView as? CustomView else { return }
            self.backgroundView?.bringSubviewToFront(emptyView)
            emptyView.isHidden  = false
        }
    }
    
    func hideEmptyView() {
        DispatchQueue.main.async {
            self.backgroundView?.isHidden = true
        }
    }
}
