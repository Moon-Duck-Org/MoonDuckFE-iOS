//
//  IntroViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation

protocol IntroPresenter: AnyObject {
    var view: IntroView? { get set }
    
    /// Life Cycle
    func viewDidLoad()
}

class IntroViewPresenter: Presenter, IntroPresenter {
    
    weak var view: IntroView?
    let model: UserModelType
    
    init(with provider: AppServices, model: UserModelType) {
        self.model = model
        super.init(with: provider)
        self.model.delegate = self
    }
}

// MARK: - Input
extension IntroViewPresenter {
    func viewDidLoad() {
        checkAutoLogin()
    }
}
// MARK: - Logic
extension IntroViewPresenter {
    private func checkAutoLogin() {
        if let auth = AuthManager.default.getAutoLoginAuth() {
            // 자동 로그인 가능 시, 로그인 시도
            login(auth)
        } else {
            moveLogin()
        }
    }
    
    private func login(_ auth: Auth) {
        AuthManager.default.login(auth: auth) { [weak self] result in
            if result == .success {
                self?.model.getUser()
            } else {
                self?.moveLogin()
            }
        }
    }
    
    private func moveLogin() {
        let presenter = LoginViewPresenter(with: provider)
        view?.moveLogin(with: presenter)
    }
}

// MARK: - UserModelDelegate
extension IntroViewPresenter: UserModelDelegate {
    func userModel(_ userModel: UserModel, didChange user: UserV2) {
        let presenter = V2HomeViewPresenter(with: provider, model: model)
        view?.moveHome(with: presenter)
    }
    
    func userModel(_ userModel: UserModel, didRecieve errorMessage: Error?) {
        AuthManager.default.logout()
        moveLogin()
    }
    
    func userModel(_ userModel: UserModel, didRecieve error: UserModelError) {
        AuthManager.default.logout()
        moveLogin()
    }
}
