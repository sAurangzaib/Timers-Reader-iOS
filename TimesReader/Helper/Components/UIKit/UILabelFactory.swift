
import UIKit

class UILabelFactory {

    class func createUILabel<T: UILabel>(with textColor: UIColor = .black, textStyle: UIFont = UIFont.systemFont(ofSize: 17), alignment: NSTextAlignment = .left,backgroundColor: UIColor = .clear, numberOfLines: Int = 1, lineBreakMode: NSLineBreakMode = .byTruncatingTail, text: String? = nil, alpha: CGFloat = 1.0, adjustFontSize: Bool = false, cornerRadius: CGFloat = 0) -> T {
        let label = T()
        label.font = textStyle
        label.backgroundColor = backgroundColor
        label.textColor = textColor
        label.textAlignment = alignment
        label.numberOfLines = numberOfLines
        label.lineBreakMode = lineBreakMode
        label.text = text
        label.alpha = alpha
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = adjustFontSize
        label.layer.cornerRadius = cornerRadius
        label.clipsToBounds = true
        return label
    }
}
