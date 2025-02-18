//
//  LoginViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

// MARK: - API Version

import Foundation
import UIKit

import KakaoSDKUser
import Firebase
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices

protocol LoginPresenter: AnyObject {
    var view: LoginView? { get set }
    
    // Life Cycle
    func viewDidLoad()
    
    // Action
    func kakaoLoginButtonTapped()
    func googleLogin(result: GIDSignInResult?, error: Error?)
    func appleLogin(id: String)
    func loginError()
}

final class LoginViewPresenter: BaseAPIViewPresenter, LoginPresenter {
    
    weak var view: LoginView?
    
    override init(with provider: AppServices, model: APIAppModels) {
        super.init(with: provider, model: model)
        self.model.userModel?.delegate = self
    }
}

extension LoginViewPresenter {
    // MARK: - Life Cycle
    func viewDidLoad() {
        AnalyticsService.shared.logEvent(.VIEW_LOGIN)
    }
    
    // MARK: - Action
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
        AuthManager.shared.login(auth: auth) { [weak self] isHaveNickname, failed in
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
                    self.model.userModel?.getUser()
                    return
                } else {
                    self.view?.updateLoadingView(isLoading: false)
//                    let appModel = AppModels(
//                        userModel: UserModel(provider)
//                    )
//                    let presenter = NicknameSettingViewPresenter(with: self.provider, model: appModel, delegate: nil)
//                    self.view?.moveNameSetting(with: presenter)
                    return
                }
            }
            
            self.view?.updateLoadingView(isLoading: false)
            self.loginError()
        }
    }
}

// MARK: - UserModelDelegate
extension LoginViewPresenter: APIUserModelDelegate {
    func error(didRecieve error: APIError?) {
        view?.updateLoadingView(isLoading: false)
        
        let snsType = AuthManager.shared.getLoginType()?.rawValue ?? ""
        AnalyticsService.shared.logEvent(
            .FAIL_LOGIN,
            parameters: [.SNS_TYPE: snsType,
                         .ERROR_CODE: error?.code ?? "",
                         .ERROR_MESSAGE: error?.message ?? "",
                         .TIME_STAMP: Utils.getCurrentKSTTimestamp()
            ]
        )
        
        AuthManager.shared.logout()
        
        guard let error else {
            loginError()
            return
        }
    
        if error.isAuthError {
            loginError()
        } else if error.isNetworkError {
            view?.showNetworkErrorAlert()
        } else if error.isSystemError {
            view?.showSystemErrorAlert()
        }
    }
    
    func userModel(_ model: APIUserModelType, didChange user: User?) {
        // User 정보 조회 성공 -> 홈 이동
        view?.updateLoadingView(isLoading: false)
        if let user {
            let snsType = AuthManager.shared.getLoginType()?.rawValue ?? ""
            AnalyticsService.shared.logEvent(
                .SUCCESS_LOGIN,
                parameters: [.SNS_TYPE: snsType,
                             .REVIEW_COUNT: user.all,
                             .IS_PUSH: user.isPush
                ]
            )
            
//            let appModel = AppModels(
//                userModel: model,
//                categoryModel: CategoryModel(),
//                sortModel: SortModel(),
//                reviewListModel: ReviewListModel(provider),
//                shareModel: ShareModel(provider)
//            )
//            let presenter = HomeViewPresenter(with: provider, model: appModel)
//            view?.moveHome(with: presenter)
        }
    }
}
