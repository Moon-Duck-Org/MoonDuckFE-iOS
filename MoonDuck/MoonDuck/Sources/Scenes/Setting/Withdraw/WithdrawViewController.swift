//
//  WithdrawViewController.swift
//  MoonDuck
//
//  Created by suni on 7/4/24.
//

import UIKit
import AuthenticationServices

protocol WithdrawView: BaseView {
    // UI Logic
    func updateContentLabelText(with text: String)
    func showWithdrawWithAppleAlert()
        
    // Navigation
    func showComplteWithDrawAlert(with presenter: LoginPresenter)
}

class WithdrawViewController: BaseViewController, WithdrawView {
    private let presenter: WithdrawPresenter
    
    // @IBOutlet
    @IBOutlet private weak var contentLabel: UILabel!
    
    // @IBAction
    @IBAction private func backButtonTapped(_ sender: Any) {
        back()
    }
    @IBAction private func cancelButtonTapped(_ sender: Any) {
        back()
    }
    @IBAction private func withdrawButtonTapped(_ sender: Any) {
        AppAlert.default.showDestructive(
            self,
            title: L10n.Localizable.My.withdrawAlertMessage,
            cancelTitle: L10n.Localizable.Button.cancel,
            destructiveTitle: L10n.Localizable.Button.withdraw,
            destructiveHandler: { [weak self] in
                self?.presenter.withdrawButtonTapped()
            }
        )
    }
    
    init(navigator: Navigator,
         presenter: WithdrawPresenter) {
        self.presenter = presenter
        super.init(navigator: navigator, nibName: WithdrawViewController.className, bundle: Bundle(for: WithdrawViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.viewDidLoad()
    }
}

// MARK: - UI Logic
extension WithdrawViewController {
    func updateContentLabelText(with text: String) {
        contentLabel?.text = text
    }
    
    func showWithdrawWithAppleAlert() {
        AppAlert.default.showCancelAndDone(
            self,
            message: L10n.Localizable.Withdraw.Apple.message,
            doneHandler: { [weak self] in
                self?.appleLogin()
            }
        )
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
extension WithdrawViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            if let authorizationCodeData = appleIDCredential.authorizationCode,
               let authorizationCode = String(data: authorizationCodeData, encoding: .utf8) {
                presenter.withdrawWithApple(authorizationCode: authorizationCode)
                return
            }
        }
        appleLoginError()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 로그인 실패(유저의 취소도 포함)
        appleLoginError()
    }
    
    private func appleLoginError() {
        updateLoadingView(isLoading: false)
        showToastMessage(L10n.Localizable.Withdraw.Apple.error)
    }
    
}

// MARK: - Navigation
extension WithdrawViewController {
    private func back() {
        navigator?.pop(sender: self, animated: true)
    }
    
    func showComplteWithDrawAlert(with presenter: LoginPresenter) {
        AppAlert.default.showDone(self, message: L10n.Localizable.My.withdrawCompleteMessage, doneHandler: { [weak self] in
            self?.navigator?.show(seque: .login(presenter: presenter), sender: nil, transition: .root)
        })
    }
}
