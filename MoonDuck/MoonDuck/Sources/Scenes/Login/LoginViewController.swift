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
import AuthenticationServices

protocol LoginView: BaseView {
    // Navigation
    func dismiss()
    func moveNameSetting(with presenter: NicknameSettingPresenter)
    func moveHome(with presenter: V2HomePresenter)
}

class LoginViewController: BaseViewController, LoginView, Navigatable {
    
    var navigator: Navigator?
    let presenter: LoginPresenter
    
    // IBAction
    @IBAction private func tapKakaoLoginButton(_ sender: Any) {
        presenter.tapKakaoLoginButton()
    }
    @IBAction private func tapGoogleLoginButton(_ sender: Any) {
        googleLogin()
    }
    @IBAction private func tapAppleLoginButton(_ sender: Any) {
        appleLogin()
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
    
    private func googleLogin() {
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
    
    private func appleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
               
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

// MARK: - ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding
extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:

            // Create an account in your system .
            let id = appleIDCredential.user
            presenter.appleLogin(id: id)

        case let passwordCredential as ASPasswordCredential:

            // Sign in using an existing iCloud Keychain credential.
            let id = passwordCredential.user
            presenter.appleLogin(id: id)

        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 로그인 실패(유저의 취소도 포함)
        presenter.loginError()
    }
}

// MARK: - Navigation
extension LoginViewController {
    func dismiss() {
        navigator?.dismiss(sender: self)
    }
    
    func moveNameSetting(with presenter: NicknameSettingPresenter) {
        navigator?.show(seque: .nameSetting(presenter: presenter), sender: self, transition: .navigation)
    }
    
    func moveHome(with presenter: V2HomePresenter) {
        navigator?.show(seque: .home(presenter: presenter), sender: nil, transition: .root)
    }
}
