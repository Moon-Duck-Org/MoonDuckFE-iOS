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

protocol LoginPresenter: AnyObject {
    var view: LoginView? { get set }
    
    func kakaoLoginButtonTap()
    func appleLoginButtonTap()
    
    func googleLogin(result: GIDSignInResult?, error: Error?)
    func loginError()
}

final class LoginViewPresenter: Presenter, LoginPresenter {
    
    weak var view: LoginView?
    
    // MARK: - Input
    func kakaoLoginButtonTap() {
        kakaoLogin()
    }
    
    func googleLoginButtonTap() {
        
    }
    
    func appleLoginButtonTap() {
        
    }
}

// MARK: - Logic
extension LoginViewPresenter {
    func loginError() {
        Log.todo("로그인 오류 알럿 노출")
        view?.showToast("로그인에 실패하였습니다.")
    }
    
    func googleLogin(result: GIDSignInResult?, error: Error?) {
        if let error = error {
            Log.error(error.localizedDescription)
            loginError()
            return
        }
        guard let id = result?.user.userID else {
            self.view?.showToast("구글 아이디가 없습니다.")
            loginError()
            return
        }
        
        let auth = Auth(loginType: .apple, id: String(id))
        self.login(auth)
    }
}

// MARK: - Netwoking
extension LoginViewPresenter {
    private func kakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error {
                    Log.error(error.localizedDescription)
                    self.loginError()
                    return
                }
                
                guard let oauthToken else {
                    Log.error("oauthToken is nil.")
                    self.loginError()
                    return
                }
                self.kakaoUser(oauthToken.accessToken)
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error {
                    Log.error(error.localizedDescription)
                    self.loginError()
                    return
                }
                
                guard let oauthToken else {
                    Log.error("oauthToken is nil.")
                    self.loginError()
                    return
                }
                
                self.kakaoUser(oauthToken.accessToken)
            }
        }
    }
    
    private func kakaoUser(_ token: String) {
        UserApi.shared.me { user, error in
            if let error {
                Log.error(error.localizedDescription)
                self.loginError()
                return
            } 
            
            guard let id = user?.id else {
                self.view?.showToast("카카오 아이디가 없습니다.")
                return
            }
            
            let auth = Auth(loginType: .kakao, id: String(id))
            self.login(auth)
        }
    }
    
    private func login(_ auth: Auth) {
        let request = AuthLoginRequest(dvsnCd: auth.loginType.rawValue, id: auth.id)
        provider.authService.login(request: request) { succeed, failed in
            if let succeed {
                // 로그인 성공 자동 로그인 / token 저장
                AuthManager.current.saveToken(succeed.accessToken, succeed.refreshToken)
                if succeed.isHaveNickname {
                    self.user(auth)
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
    
    private func user(_ auth: Auth) {
        // TODO: User API 연결 -> 홈 이동
        
    }
}
