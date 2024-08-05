//
//  BaseViewController.swift
//  MoonDuck
//
//  Created by suni on 6/10/24.
//

import UIKit

protocol BaseView: AnyObject {
    var isEditingText: Bool { get set }
    
    func createTouchEvent()
    func updateLoadingView(isLoading: Bool)
    func showToastMessage(_ message: String)
    func endEditing()
    func moveLogin(with presenter: LoginPresenter)
    func showAuthErrorAlert(with presenter: LoginPresenter)
    func showNetworkErrorAlert()
    func showSystemErrorAlert()
    func showErrorAlert(title: String, message: String)
}

class BaseViewController: UIViewController, Navigatable {
    lazy var throttler = Throttler(interval: 1.0)
    var navigator: Navigator?
    
    lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var isEditingText: Bool = false
    
    init(navigator: Navigator, nibName: String?, bundle: Bundle?) {
        self.navigator = navigator
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.loadingView)
        NSLayoutConstraint.activate([
            self.loadingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.loadingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.loadingView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        ])
        
        self.loadingView.isLoading = false
    }
    
    func updateLoadingView(isLoading: Bool) {
        DispatchQueue.main.async {
            self.loadingView.isLoading = isLoading
        }
    }
    
    func showToastMessage(_ message: String) {
        showToast(message: message)
    }
    /**
     # createTouchEvent
     - Author: suni
     - Date: 24.06.14
     - Note: ViewController 터치로 키보드를 숨기는 이벤트를 생성하는 함수
     */
    func createTouchEvent() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        recognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(recognizer)
    }
    
    @objc
    func endEditing() {
        if isEditingText {
            view.endEditing(true)
            isEditingText = false
        }
    }
    
    func moveLogin(with presenter: LoginPresenter) {
        DispatchQueue.main.async {
            self.navigator?.show(seque: .login(presenter: presenter), sender: nil, transition: .root, animated: false)
        }
    }
    
    func showAuthErrorAlert(with presenter: LoginPresenter) {
        if isRoot() {
            AppAlert.default.showAuthError(self) { [weak self] in
                self?.moveLogin(with: presenter)
            }
        }
    }
    
    func showNetworkErrorAlert() {
        if isRoot() {
            AnalyticsService.shared.logEvent(.ALERT_ERROR_NETWORK)
            AppAlert.default.showNetworkError(self)
        }
    }
    
    func showSystemErrorAlert() {
        if isRoot() {
            AnalyticsService.shared.logEvent(.ALERT_ERROR_SYSTEM)
            AppAlert.default.showSystemErrorAlert(self)
        }
    }
    
    func showErrorAlert(title: String = "", message: String = "") {
        if isRoot() {
            AppAlert.default.showDone(self, title: title, message: message)
        }
    }
    
    func isRoot() -> Bool {
        if let topVC = UIApplication.topViewController() {
            return topVC == self
        }
        return true
    }
}
extension UIApplication {
    class func topViewController(base: UIViewController? = {
        let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        return scene?.windows.first(where: { $0.isKeyWindow })?.rootViewController
    }()) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
