
import UIKit
import RxSwift
import RxCocoa

// MARK: - Alert view
extension UIViewController {
    func showAlert(title: String = "", message: String, defaultButtonTitle: String = "OK", secondayButtonTitle: String? = nil, defaultButtonHandler: ((UIAlertAction) -> Void)? = nil, secondaryButtonHandler: ((UIAlertAction) -> Void)? = nil, completion: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: defaultButtonTitle, style: .default, handler: defaultButtonHandler)
        alert.addAction(defaultAction)
        
        if secondayButtonTitle != nil {
            let secondaryAction = UIAlertAction(title: secondayButtonTitle, style: .cancel, handler: secondaryButtonHandler)
            alert.addAction(secondaryAction)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: completion)
        }
    }
    
    func hideAlertView() {
        (presentedViewController as? UIAlertController)?.dismiss(animated: true)
    }
}

extension Reactive where Base: UIViewController {
    var showErrorMessage: Binder<String> {
        return Binder(base) { viewController, error in
            viewController.showAlert(message: error)
        }
    }
}
