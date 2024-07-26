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
    
    // Action
    func logoutButtonTapped()
    func nicknameSettingButtonTapped()
    func settingButtonTapped()
}

class MyInfoViewPresenter: BaseViewPresenter, MyInfoPresenter {
    weak var view: MyInfoView?
//    private let model: UserModelType
}

extension MyInfoViewPresenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        if let user = model.userModel?.user {
            view?.updateNameLabelText(with: user.nickname)
            view?.updateCountLabels(with: user.all, movie: user.movie, book: user.book, drama: user.drama, concert: user.concert)
        } else {
            AuthManager.shared.logout()
            moveLogin()
        }
    }
    
    // MARK: - Action
    func nicknameSettingButtonTapped() {
        let userModel = UserModel(provider)
        userModel.user = self.model.userModel?.user
        let appModel = AppModels(
            userModel: userModel
        )
        let presenter = NicknameSettingViewPresenter(with: provider, model: appModel, delegate: self)
        view?.presentNameSetting(with: presenter)
    }
    
    func logoutButtonTapped() {
        AuthManager.shared.logout()
        moveLogin()
    }
    
    func settingButtonTapped() {
        let userModel = UserModel(provider)
        userModel.user = self.model.userModel?.user
        let appModel = AppModels(
            userModel: userModel
        )
        let presenter = SettingViewPresenter(with: provider, model: appModel, delegate: self)
        self.view?.moveSetting(with: presenter)
    }
    
    // MARK: - Logic
    private func moveLogin() {
        let appModel = AppModels(
            userModel: UserModel(provider)
        )
        let presenter = LoginViewPresenter(with: provider, model: appModel)
        self.view?.moveLogin(with: presenter)
    }
    
    private func updateNotification() {
        guard let user = model.userModel?.user else { return }
        
        if user.isPush {
            AppNotification.resetAndScheduleNotification(with: user.nickname)
        }
    }
}

// MARK: - NicknameSettingPresenterDelegate
extension MyInfoViewPresenter: NicknameSettingPresenterDelegate {
    func nicknameSetting(_ presenter: NicknameSettingPresenter, didSuccess nickname: String) {
        view?.dismiss()
        view?.updateNameLabelText(with: nickname)
        view?.showToastMessage(L10n.Localizable.NicknameSetting.completeToast)
        model.userModel?.save(nickname: nickname)
        updateNotification()
    }
    
    func nicknameSettingDidCancel(_ presenter: NicknameSettingPresenter) {
        view?.dismiss()
    }
}

// MARK: - SettingPresenterDelegate
extension MyInfoViewPresenter: SettingPresenterDelegate {
    func setting(_ presenter: SettingPresenter, didSuccess isPush: Bool) {
        model.userModel?.save(isPush: isPush)
    }
}
