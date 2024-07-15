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
    private let model: UserModelType
    
    init(with provider: AppServices, model: UserModelType) {
        self.model = model
        super.init(with: provider)
    }
}

extension MyInfoViewPresenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        if let user = model.user {
            view?.updateNameLabelText(with: user.nickname)
            view?.updateCountLabels(with: user.all, movie: user.movie, book: user.book, drama: user.drama, concert: user.concert)
        } else {
            AuthManager.default.logout()
            moveLogin()
        }
    }
    
    // MARK: - Action
    func nicknameSettingButtonTapped() {
        let model = UserModel(provider)
        model.user = self.model.user
        let presenter = NicknameSettingViewPresenter(with: provider, model: model, delegate: self)
        view?.presentNameSetting(with: presenter)
    }
    
    func logoutButtonTapped() {
        AuthManager.default.logout()
        moveLogin()
    }
    
    func settingButtonTapped() {
        let model = UserModel(provider)
        model.user = self.model.user
        let presenter = SettingViewPresenter(with: provider, model: model, delegate: self)
        self.view?.moveSetting(with: presenter)
    }
    
    // MARK: - Logic
    private func moveLogin() {
        let model = UserModel(provider)
        let presenter = LoginViewPresenter(with: provider, model: model)
        self.view?.moveLogin(with: presenter)
    }
    
    private func updateNotification() {
        guard let user = model.user else { return }
        
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
        model.save(nickname: nickname)
        updateNotification()        
    }
    
    func nicknameSettingDidCancel(_ presenter: NicknameSettingPresenter) {
        view?.dismiss()
    }
}

// MARK: - SettingPresenterDelegate
extension MyInfoViewPresenter: SettingPresenterDelegate {
    func setting(_ presenter: SettingPresenter, didSuccess isPush: Bool) {
        model.save(isPush: isPush)
    }
}
