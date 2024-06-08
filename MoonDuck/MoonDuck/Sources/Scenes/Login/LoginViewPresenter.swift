//
//  LoginViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import Foundation
import UIKit

import KakaoSDKUser
import Firebase
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices

protocol LoginPresenter: AnyObject {
    var view: LoginView? { get set }
    
    /// Action
    func kakaoLoginButtonTap()
    func googleLogin(result: GIDSignInResult?, error: Error?)
    func appleLogin(id: String)
    func loginError()
}

final class LoginViewPresenter: Presenter, LoginPresenter {
    
    weak var view: LoginView?
    
}

// MARK: - Input
extension LoginViewPresenter {
    func kakaoLoginButtonTap() {
        kakaoLogin()
    }
    
    func googleLogin(result: GIDSignInResult?, error: Error?) {
        if let error = error {
            Log.error(error.localizedDescription)
            loginError()
            return
        }
        guard let id = result?.user.userID else {
            Log.error("userID is nil.")
            self.view?.showToast("구글 아이디가 없습니다.")
            loginError()
            return
        }
        
        let auth = Auth(loginType: .google, id: String(id))
        login(auth)
    }
    
    func appleLogin(id: String) {
        let auth = Auth(loginType: .apple, id: id)
        login(auth)
    }
    
    func loginError() {
        Log.todo("로그인 오류 알럿 노출")
        view?.showToast("로그인에 실패하였습니다.")
    }
}

// MARK: - Netwoking
extension LoginViewPresenter {
    private func kakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in
                if let error {
                    Log.error(error.localizedDescription)
                    self?.loginError()
                    return
                }
                
                guard let oauthToken else {
                    Log.error("oauthToken is nil.")
                    self?.loginError()
                    return
                }
                self?.kakaoUser(oauthToken.accessToken)
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error in
                if let error {
                    Log.error(error.localizedDescription)
                    self?.loginError()
                    return
                }
                
                guard let oauthToken else {
                    Log.error("oauthToken is nil.")
                    self?.loginError()
                    return
                }
                
                self?.kakaoUser(oauthToken.accessToken)
            }
        }
    }
    
    private func kakaoUser(_ token: String) {
        UserApi.shared.me { [weak self] user, error in
            if let error {
                Log.error(error.localizedDescription)
                self?.loginError()
                return
            } 
            
            guard let id = user?.id else {
                Log.error("user.id is nil.")
                self?.view?.showToast("카카오 아이디가 없습니다.")
                return
            }
            
            let auth = Auth(loginType: .kakao, id: String(id))
            self?.login(auth)
        }
    }
    
    private func login(_ auth: Auth) {
        let request = AuthLoginRequest(dvsnCd: auth.loginType.rawValue, id: auth.id)
        provider.authService.login(request: request) { [weak self] succeed, failed in
            guard let self else { return }
            
            if let succeed {
                // 앱에 토큰 및 로그인 정보 저장
                AuthManager.current.saveAuth(auth)
                AuthManager.current.saveToken(
                    Token(accessToken: succeed.accessToken,
                          refreshToken: succeed.refreshToken)
                )
                if succeed.isHaveNickname {
                    self.getUser()
                } else {
                    let presenter = NameSettingViewPresenter(with: self.provider)
                    self.view?.moveNameSetting(with: presenter)
                }
            } else {
                Log.error(failed?.localizedDescription ?? "Login Error")
                self.loginError()
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
                AuthManager.current.removeToken()
                AuthManager.current.removeAuth()
                self.loginError()
            }
        }
    }
}
