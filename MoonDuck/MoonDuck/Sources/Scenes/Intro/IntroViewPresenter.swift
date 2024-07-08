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

class IntroViewPresenter: BaseViewPresenter, IntroPresenter {
    
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
            // 자동 로그인 정보 있으면 로그인 시도
            login(auth)
        } else {
            moveLogin()
        }
    }
    
    private func login(_ auth: Auth) {
        AuthManager.default.login(auth: auth) { [weak self] isHaveNickname, _ in
            if let isHaveNickname, isHaveNickname {
                if isHaveNickname {
                    // 로그인 성공 시, User 정보 조회
                    self?.model.getUser()
                    return
                }
            }
            self?.moveLogin()
        }
    }
    
    private func moveLogin() {
        let model = UserModel(provider)
        let presenter = LoginViewPresenter(with: provider, model: model)
        view?.moveLogin(with: presenter)
    }
}

// MARK: - UserModelDelegate
extension IntroViewPresenter: UserModelDelegate {
    
    func userModel(_ model: UserModelType, didChange user: User?) {
        // User 정보 조회 성공 -> 홈 이동
        if let user {
            let cateogryModel = CategoryModel()
            let sortModel = SortModel()
            let reviewModel = ReviewListModel(provider)
            let presenter = HomeViewPresenter(with: provider, userModel: model, categoryModel: cateogryModel, sortModel: sortModel, reviewModel: reviewModel)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.view?.moveHome(with: presenter)
            }
        }
    }
    
    func userModel(_ model: UserModelType, didRecieve error: APIError?) {
        AuthManager.default.logout()
        moveLogin()
    }
    
    func userModelDidFailLogin(_ model: UserModelType) {
        AuthManager.default.logout()
        moveLogin()
    }
    
    func userModelDidFailFetchingUser(_ model: UserModelType) {
        AuthManager.default.logout()
        moveLogin()
    }
    
    func userModelDidAuthError(_ model: UserModelType) {
        AuthManager.default.logout()
        moveLogin()
    }
}
