//
//  UIImageView+Extension.swift
//  TimesReader
//
//  Created by Aurangzaib on 13/08/2023.
//

import Foundation
import SDWebImage


extension UIImageView {
    func loadImage(with url: URL?, placeholder: UIImage? = nil, showsIndicator: Bool = false) {
        self.sd_imageIndicator = showsIndicator ? SDWebImageActivityIndicator.gray : nil
        sd_setImage(with: url, placeholderImage: placeholder)
    }
}
