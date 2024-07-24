//
//  IntroViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation

import FirebaseRemoteConfig

protocol IntroPresenter: AnyObject {
    var view: IntroView? { get set }
    
    // Life Cycle
    func viewDidLoad()
    
    // Action
    func latestUpdateButtonTapped()
}

class IntroViewPresenter: BaseViewPresenter, IntroPresenter {
    
    weak var view: IntroView?
    
    override init(with provider: AppServices, model: AppModels) {
        super.init(with: provider, model: model)
        self.model.userModel?.delegate = self
    }
}

extension IntroViewPresenter {
    // MARK: - Life Cycle
    func viewDidLoad() {
        if Utils.isJailbroken() {
            view?.showJalibrokenAlert()
        } else {
            startApp()
        }
    }
    
    // MARK: - Action
    func latestUpdateButtonTapped() {
        checkAutoLogin()
    }
}
// MARK: - Logic
extension IntroViewPresenter {
    private func startApp() {
        Utils.initConfig()
        Utils.checkForUpdate { [weak self] appUpdate in
            switch appUpdate {
            case .forceUpdate:
                self?.view?.showForceUpdateAlert()
            case .latestUpdate:
                self?.view?.showLatestUpdateAlert()
            case .none:
                self?.checkAutoLogin()
            }
        }
    }
    
    private func checkAutoLogin() {
        if let auth = AuthManager.shared.getAutoLoginAuth() {
            // 자동 로그인 정보 있으면 로그인 시도
            login(auth)
        } else {
            moveLogin()
        }
    }
    
    private func login(_ auth: Auth) {
        AuthManager.shared.login(auth: auth) { [weak self] isHaveNickname, _ in
            if let isHaveNickname, isHaveNickname {
                if isHaveNickname {
                    // 로그인 성공 시, User 정보 조회
                    self?.model.userModel?.getUser()
                    return
                }
            }
            self?.moveLogin()
        }
    }
    
    private func moveLogin() {
        let userModel = UserModel(provider)
        let appModel = AppModels(userModel: userModel)
        let presenter = LoginViewPresenter(with: provider, model: appModel)
        view?.moveLogin(with: presenter)
    }
}

// MARK: - UserModelDelegate
extension IntroViewPresenter: UserModelDelegate {
    func error(didRecieve error: APIError?) {
        AuthManager.shared.logout()
        moveLogin()
    }
    
    func userModel(_ model: UserModelType, didChange user: User?) {
        // User 정보 조회 성공 -> 홈 이동
        if user != nil {
            let cateogryModel = CategoryModel()
            let reviewListModel = ReviewListModel(provider)
            let sortModel = SortModel()
            let shareModel = ShareModel(provider)
            let appModel = AppModels(userModel: model, categoryModel: cateogryModel, sortModel: sortModel, reviewListModel: reviewListModel, shareModel: shareModel)
            let presenter = HomeViewPresenter(with: provider, model: appModel)
            self.view?.moveHome(with: presenter)
        }
    }
    
    func userModelDidFailFetchingUser(_ model: UserModelType) {
        AuthManager.shared.logout()
        moveLogin()
    }
}
