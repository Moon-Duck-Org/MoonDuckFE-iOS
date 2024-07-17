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
    func kakaoLoginButtonTapped()
    func googleLogin(result: GIDSignInResult?, error: Error?)
    func appleLogin(id: String)
    func loginError()
}

final class LoginViewPresenter: BaseViewPresenter, LoginPresenter {
    
    weak var view: LoginView?
    let model: UserModelType
    
    init(with provider: AppServices, model: UserModelType) {
        self.model = model
        super.init(with: provider)
        self.model.delegate = self
    }
}

// MARK: - Input
extension LoginViewPresenter {
    func kakaoLoginButtonTapped() {
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
        view?.showToastMessage(L10n.Localizable.Error.loginMessage)
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
                    Log.error("kakaoLogin oauthToken is nil.")
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
                    Log.error("kakaoLogin oauthToken is nil.")
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
                Log.error("kakaoUser user.id is nil.")
                self?.loginError()
                return
            }
            
            let auth = Auth(loginType: .kakao, id: String(id))
            self?.login(auth)
        }
    }
    
    private func login(_ auth: Auth) {
        view?.updateLoadingView(isLoading: true)
        AuthManager.default.login(auth: auth) { [weak self] isHaveNickname, failed in
            guard let self else {
                self?.view?.updateLoadingView(isLoading: false)
                return
            }
            if failed != nil {
                self.view?.updateLoadingView(isLoading: false)
                self.loginError()
                return
            }
            
            if let isHaveNickname {
                if isHaveNickname {
                    self.model.getUser()
                    return
                } else {
                    self.view?.updateLoadingView(isLoading: false)
                    let model = UserModel(provider)
                    let presenter = NicknameSettingViewPresenter(with: self.provider, model: model, delegate: nil)
                    self.view?.moveNameSetting(with: presenter)
                    return
                }
            }
            
            self.view?.updateLoadingView(isLoading: false)
            self.loginError()
        }
    }
}

// MARK: - UserModelDelegate
extension LoginViewPresenter: UserModelDelegate {
    func userModel(_ model: UserModelType, didChange user: User?) {
        // User 정보 조회 성공 -> 홈 이동
        view?.updateLoadingView(isLoading: false)
        if user != nil {
            let cateogryModel = CategoryModel()
            let reviewModel = ReviewListModel(provider)
            let sortModel = SortModel()
            let shareModel = ShareModel(provider)
            let presenter = HomeViewPresenter(with: provider, userModel: model, categoryModel: cateogryModel, sortModel: sortModel, reviewModel: reviewModel, shareModel: shareModel)
            view?.moveHome(with: presenter)
        }
    }
    
    func userModel(_ model: UserModelType, didRecieve error: APIError?) {
        view?.updateLoadingView(isLoading: false)
        AuthManager.default.logout()
        
        if let error {
            if error.isNetworkError {
                view?.showNetworkErrorAlert()
                return
            } else if error.isSystemError {
                view?.showSystemErrorAlert()
                return
            }
        }
        
        loginError()
    }
    
    func userModelDidFailLogin(_ model: UserModelType) {
        view?.updateLoadingView(isLoading: false)
        AuthManager.default.logout()
        loginError()
    }
    
    func userModelDidAuthError(_ model: UserModelType) {
        view?.updateLoadingView(isLoading: false)
        AuthManager.default.logout()
        loginError()
    }
}
