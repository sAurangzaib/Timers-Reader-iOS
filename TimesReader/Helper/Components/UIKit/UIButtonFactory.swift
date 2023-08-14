

import UIKit

class UIButtonFactory {
    
    class func createButton(title: String = String(), backgroundColor: UIColor = UIColor.clear, image: UIImage? = nil, textColor: UIColor =  UIColor.white, tintColor: UIColor =  UIColor.clear, cornerRadius: CGFloat = 0.0) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = cornerRadius
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }
}


