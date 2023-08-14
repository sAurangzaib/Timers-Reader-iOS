
import UIKit

class UITextfieldFactory {
    
    class func createUITextfield<T: UITextField>(with colorType: UIColor = .black, textStyle: UIFont = UIFont.systemFont(ofSize: 16), alignment: NSTextAlignment = .left, text: String? = nil, placeholder: String? = nil, delegate: UITextFieldDelegate? = nil, returnType: UIReturnKeyType = .default, autocorrectionType:UITextAutocorrectionType = .no, secureTextEntry: Bool = false) -> T {
        
        let field = T()
        field.delegate = delegate
        field.font = textStyle
        field.placeholder = placeholder
        field.textColor = colorType
        field.textAlignment = alignment
        field.returnKeyType = returnType
        field.autocorrectionType = autocorrectionType
        field.translatesAutoresizingMaskIntoConstraints = false
        field.isSecureTextEntry = secureTextEntry
        
        return field
    }
}
