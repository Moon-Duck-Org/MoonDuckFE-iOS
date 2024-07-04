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

final class LoginViewPresenter: Presenter, LoginPresenter {
    
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
            self.view?.showToastMessage("구글 아이디가 없습니다.")
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
        view?.updateLoadingView(isLoading: false)
        Log.todo("로그인 오류 알럿 노출")
        view?.showToastMessage("로그인에 실패하였습니다.")
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
                self?.view?.showToastMessage("카카오 아이디가 없습니다.")
                return
            }
            
            let auth = Auth(loginType: .kakao, id: String(id))
            self?.login(auth)
        }
    }
    
    private func login(_ auth: Auth) {
        view?.updateLoadingView(isLoading: true)
        AuthManager.default.login(auth: auth) { [weak self] result in
            guard let self else {
                self?.view?.updateLoadingView(isLoading: false)
                return
            }
            
            switch result {
            case .success: 
                self.model.getUser()
            case .donthaveNickname:
                self.view?.updateLoadingView(isLoading: false)
                let model = UserModel(provider)
                let presenter = NicknameSettingViewPresenter(with: self.provider, model: model, delegate: self)
                self.view?.moveNameSetting(with: presenter)
            case .error:
                self.loginError()
            }
        }
    }
}

// MARK: - UserModelDelegate
extension LoginViewPresenter: UserModelDelegate {
    func userModel(_ model: UserModel, didChange user: User) {
        // User 정보 조회 성공
        view?.updateLoadingView(isLoading: false)
        let cateogryModel = CategoryModel()
        let reviewModel = ReviewListModel(provider)
        let sortModel = SortModel()
        let presenter = HomeViewPresenter(with: provider, userModel: model, categoryModel: cateogryModel, sortModel: sortModel, reviewModel: reviewModel)
        view?.moveHome(with: presenter)
    }
    
    func userModel(_ model: UserModel, didRecieve error: UserModelError) {
        AuthManager.default.logout()
        loginError()
    }
    
    func userModel(_ model: UserModel, didRecieve errorMessage: (any Error)?) {
        AuthManager.default.logout()
        loginError()
    }
}

// MARK: - NicknameSettingPresenterDelegate
extension LoginViewPresenter: NicknameSettingPresenterDelegate {
    func nicknameSetting(_ presenter: NicknameSettingPresenter, didSuccess nickname: String) {
        view?.updateLoadingView(isLoading: false)
        model.save(nickname: nickname)
    }
    
    func nicknameSettingDidCancel(_ presenter: NicknameSettingPresenter) {
        
    }
}
