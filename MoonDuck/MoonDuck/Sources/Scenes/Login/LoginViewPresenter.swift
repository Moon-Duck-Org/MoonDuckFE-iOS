//
//  LoginViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import Foundation


protocol LoginPresenter: AnyObject {
    var view: LoginView? { get set }
    
    func kakaoLoginButtonTap()
    func googleLoginButtonTap()
    func appleLoginButtonTap()
}

class LoginViewPresenter: Presenter, LoginPresenter {
    func kakaoLoginButtonTap() {
        <#code#>
    }
    
    func googleLoginButtonTap() {
        <#code#>
    }
    
    func appleLoginButtonTap() {
        <#code#>
    }
    
    
    weak var view: LoginView?
    
    private let joinUser: JoinUser
    
    init(with provider: AppServices, joinUser: JoinUser) {
        self.joinUser = joinUser
        super.init(with: provider)
    }
    
    func startButtonTap() {
        let presenter = NameSettingViewPresenter(with: provider, joinUser: joinUser)
        view?.moveNameSetting(with: presenter)
    }
}

// MARK: - Logic
extension LoginViewPresenter {
    
}

// MARK: - Netwoking
extension LoginViewPresenter {
    
}
