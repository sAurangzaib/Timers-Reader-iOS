//
//  String+Extension.swift
//  TimesReader
//
//  Created by Aurangzaib on 12/08/2023.
//

import UIKit

extension String {
 
    var toURL: URL? {
        return URL(string: self)
    }
    
    var toImage: UIImage? {
        return UIImage(named: self)
    }
    
    var isEmptyOrNil: Bool {
        return self.isEmpty || self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
