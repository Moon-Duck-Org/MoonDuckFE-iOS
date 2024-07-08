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
        self.loadingView.isLoading = isLoading
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
        AppAlert.default.showAuthError(self) { [weak self] in
            self?.moveLogin(with: presenter)
        }
    }
    
    func showNetworkErrorAlert() {
        AppAlert.default.showNetworkError(self)
    }
    
    func showSystemErrorAlert() {
        AppAlert.default.showSystemErrorAlert(self)
    }
}
