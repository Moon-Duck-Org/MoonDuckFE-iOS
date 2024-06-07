//
//  IntroViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation
import UIKit

protocol IntroPresenter: AnyObject {
    var view: IntroView? { get set }
    
    func viewDidLoad()
}

class IntroViewPresenter: Presenter, IntroPresenter {
    
    weak var view: IntroView?
    
}

// MARK: - Input
extension IntroViewPresenter {
    func viewDidLoad() {
        checkAutoLogin()
    }
    
    private func checkAutoLogin() {
        if AuthManager.current.autoLogin() {
            getUser()
        } else {
            moveLogin()
        }
    }
}

// MARK: - Networking
extension IntroViewPresenter {
    
    private func moveLogin() {
        let presenter = LoginViewPresenter(with: self.provider)
        self.view?.moveLogin(with: presenter)
    }
    
    private func getUser() {
        provider.userService.user { [weak self] code, succeed, failed in
            if let succeed {
                // User 정보 조회 성공
                AuthManager.current.login(succeed)
                self?.view?.showToast("자동 로그인 성공.")
            } else {
                if code == .tokenExpiryDate {
                    self?.refreshToken()
                } else {
                    Log.error(failed?.localizedDescription ?? "User Error")
                    AuthManager.current.removeToken()
                    self?.moveLogin()
                }
            }
        }
    }
    
    private func refreshToken() {
        AuthManager.current.refreshToken(provider.authService) { [weak self] code in
            if code == .success {
                self?.getUser()
            } else {
                Log.error("토큰 갱신 오류 \(code)")
                self?.view?.showToast("토큰 갱신 실패")
                self?.moveLogin()
            }
        }
    }
}
