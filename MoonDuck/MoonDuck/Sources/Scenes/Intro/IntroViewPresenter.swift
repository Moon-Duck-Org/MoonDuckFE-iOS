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
    
    /// Life Cycle
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
        if let auth = AuthManager.current.getAutoLoginData() {
            // 자동 로그인 가능 시, 로그인 시도
            login(auth)
        } else {
            moveLogin()
        }
    }
    
    private func moveLogin() {
        let presenter = LoginViewPresenter(with: self.provider)
        self.view?.moveLogin(with: presenter)
    }
}

// MARK: - Networking
extension IntroViewPresenter {
    
    private func login(_ auth: Auth) {
        let request = AuthLoginRequest(dvsnCd: auth.loginType.rawValue, id: auth.id)
        provider.authService.login(request: request) { [weak self] succeed, failed in
            guard let self else { return }
            
            if let succeed, succeed.isHaveNickname {
                // 앱에 토큰 및 로그인 정보 저장
                AuthManager.current.saveAuth(auth)
                AuthManager.current.saveToken(
                    Token(accessToken: succeed.accessToken,
                          refreshToken: succeed.refreshToken)
                )
                self.getUser()
            } else {
                Log.error(failed?.localizedDescription ?? "Login Error")
                self.moveLogin()
            }
        }
    }
    
    private func getUser() {
        provider.userService.user { [weak self] succeed, failed in
            guard let self else { return }
            if let succeed {
                // User 정보 조회 성공
                AuthManager.current.saveUser(succeed)
                
                let presenter = V2HomeViewPresenter(with: self.provider)
                self.view?.moveHome(with: presenter)
            } else {
                // User 정보 조회 실패
                Log.error(failed?.localizedDescription ?? "User Error")
                AuthManager.current.logout()
                self.moveLogin()
            }
        }
    }
}
