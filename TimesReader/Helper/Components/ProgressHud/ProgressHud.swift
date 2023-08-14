

import UIKit
import RxSwift
import RxCocoa

class ProgressHud {
    
    // MARK: Properties
    
    private static var progressWindow: UIWindow?
    
    // MARK: Public function
    
    static func showProgressHud(toView view: UIView? = nil) {
        if let `view` = view {
            showHud(toView: view)
        } else {
            showHudToWindow()
        }
    }
    
    static func hideProgressHud(fromView view: UIView? = nil) {
        
        if let `view` = view {
            hideHud(fromView: view)
        } else {
            hideHudFromWindow()
        }
    }
    
    // MARK: Private functions
    
    private static func showHud(toView view: UIView) {
        hideHud(fromView: view)
        let hud = ProgressHudView(frame: view.bounds)
        view.addSubview(hud)
    }
    
    private static func showHudToWindow() {
        progressWindow = nil
        guard progressWindow == nil else { return }
        let windowScene = UIApplication.shared
                        .connectedScenes
                        .filter { $0.activationState == .foregroundActive }
                        .first
        if let windowScene = windowScene as? UIWindowScene {
            progressWindow = UIWindow(windowScene: windowScene)
            progressWindow?.backgroundColor = .clear
            progressWindow?.windowLevel = UIWindow.Level.statusBar + 1
            showHud(toView: progressWindow!)
            progressWindow?.makeKeyAndVisible()
        }
    }
    
    private static func hideHud(fromView view: UIView) {
        view.subviews.filter { $0 is ProgressHudView }.forEach { ($0 as? ProgressHudView)?.removeProgressHud() }
    }
    
    private static func hideHudFromWindow() {
        DispatchQueue.main.async {
            progressWindow?.resignKey()
            progressWindow?.removeFromSuperview()
            progressWindow = nil
        }
    }
}

private class ProgressHudView: UIView {
    
    // MARK: Initialization
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        isUserInteractionEnabled = false
        self.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.alpha = 0
        addIndicatorView()
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.alpha = 1
        }
    }
    
    fileprivate func removeProgressHud() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.alpha = 0
        }) { [weak self] (_) in
            self?.removeFromSuperview()
        }
    }
}

private extension ProgressHudView {
    func addIndicatorView() {
        let height: CGFloat = 90
        let indicator = LoaderIndicatorView(frame: CGRect(x: bounds.size.width/2, y: bounds.height/2, width: height, height: height))
        addSubview(indicator)
    }
}

// MAKR: Reactive

extension Reactive where Base: ProgressHud {
    static var showActivity: Binder<Bool> {
        return Binder(UIApplication.shared) { _, showActivity -> Void in
            showActivity ? ProgressHud.showProgressHud() : ProgressHud.hideProgressHud()
        }
    }
}
