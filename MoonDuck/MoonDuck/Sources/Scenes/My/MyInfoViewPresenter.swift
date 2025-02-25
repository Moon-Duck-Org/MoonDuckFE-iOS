//
//  MyInfoViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 6/8/24.
//

import Foundation

protocol MyInfoPresenter: AnyObject {
    var view: MyInfoView? { get set }
        
    // Life Cycle
    func viewDidLoad()
    func viewWillAppear()
    
    // Action
    func nicknameSettingButtonTapped()
    func settingButtonTapped()
}

class MyInfoViewPresenter: BaseViewPresenter, MyInfoPresenter {
    weak var view: MyInfoView?
}

extension MyInfoViewPresenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        AnalyticsService.shared.logEvent(.VIEW_MY)
        view?.updateNameLabelText(with: model.userModel?.nickname ?? "")
        view?.updateCountLabels(with: model.reviewModel?.countReviews() ?? [:])
    }
    
    func viewWillAppear() {
        view?.updateNameLabelText(with: model.userModel?.nickname ?? "")
    }
    
    // MARK: - Action
    func nicknameSettingButtonTapped() {
        let appModel = AppModels(
            userModel: model.userModel
        )
        let presenter = NicknameSettingViewPresenter(with: provider, model: appModel, delegate: self)
        view?.presentNameSetting(with: presenter)
    }
    
    func logoutButtonTapped() {
//        let snsType = AuthManager.shared.getLoginType()?.rawValue ?? ""
//        AnalyticsService.shared.logEvent(.TAP_LOGOUT, parameters: [.SNS_TYPE: snsType])
//        AuthManager.shared.logout()
//        moveLogin()
    }
    
    func settingButtonTapped() {
        let appModel = AppModels(
            userModel: model.userModel
        )
        let presenter = SettingViewPresenter(with: provider, model: appModel)
        self.view?.moveSetting(with: presenter)
    }
    
    // MARK: - Logic
    private func moveLogin() {
//        let appModel = AppModels(
//            userModel: UserModel(provider)
//        )
//        let presenter = LoginViewPresenter(with: provider, model: appModel)
//        self.view?.moveLogin(with: presenter)
    }
}

extension MyInfoViewPresenter: NicknameSettingPresenterDelegate {
    func dismiss(_ presenter: NicknameSettingPresenter) {
        view?.updateNameLabelText(with: model.userModel?.nickname ?? "")
    }
}
