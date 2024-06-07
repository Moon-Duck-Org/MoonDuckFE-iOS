//
//  LoginViewController.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import UIKit

import Firebase
import FirebaseAuth
import GoogleSignIn

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
        googleLogin()
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
    
    func googleLogin() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            self.showToast("구글 클라이언트 아이디가 없습니다.")
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            self.presenter.googleLogin(result: result, error: error)
        }
    }
}

// MARK: - Navigation
extension LoginViewController {
    func moveNameSetting(with presenter: NameSettingViewPresenter) {
        navigator.show(seque: .nameSetting(presenter: presenter), sender: nil, transition: .root)
    }
}
