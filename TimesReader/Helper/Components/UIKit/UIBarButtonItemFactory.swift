

import UIKit

class UIBarButtonItemFactory {
    
    class func createBarButtonButton(title: String = String(), backgroundColor: UIColor = .clear, image: UIImage? = nil, textColor: UIColor =  UIColor.white,width: CGFloat = 30, height: CGFloat = 30, targetIn: UIViewController, target: Selector) -> UIBarButtonItem {
        let button = UIButtonFactory.createButton(title: title, backgroundColor: backgroundColor, image: image, textColor: textColor)
        button.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
        button.addTarget(targetIn, action: target, for: .touchUpInside)
        return UIBarButtonItem.init(customView: button)
    }
}


