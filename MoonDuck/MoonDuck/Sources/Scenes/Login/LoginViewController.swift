//
//  LoginViewController.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import UIKit

protocol LoginView: AnyObject {
    func moveNameSetting(with presenter: NameSettingViewPresenter)
    
    func showToast(_ message: String)
}

class LoginViewController: UIViewController, LoginView, Navigatable {
    
    var navigator: Navigator!
    let presenter: LoginPresenter
    
    @IBAction private func kakaoLoginButtonTap(_ sender: Any) {
        presenter.kakaoLoginButtonTap()
    }
    @IBAction private func googleLoginButtonTap(_ sender: Any) {
        presenter.googleLoginButtonTap()
    }
    @IBAction private func appleLoginButtonTap(_ sender: Any) {
        presenter.appleLoginButtonTap()
    }
    
    init(navigator: Navigator,
         presenter: LoginPresenter) {
        self.navigator = navigator
        self.presenter = presenter
        super.init(nibName: LoginViewController.className, bundle: Bundle(for: LoginViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
    }
}

// MARK: - UI Logic
extension LoginViewController {
    func showToast(_ message: String) {
        showToast(message: message)
    }
}

// MARK: - Navigation
extension LoginViewController {
    func moveNameSetting(with presenter: NameSettingViewPresenter) {
        navigator.show(seque: .nameSetting(presenter: presenter), sender: nil, transition: .root)
    }
}
