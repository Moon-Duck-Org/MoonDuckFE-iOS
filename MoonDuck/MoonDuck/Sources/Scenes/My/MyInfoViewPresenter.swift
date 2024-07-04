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

class MyInfoViewPresenter: Presenter, MyInfoPresenter {
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
        let presenter = SettingViewPrsenter(with: provider, model: model)
        self.view?.moveSetting(with: presenter)
    }
    
    // MARK: - Logic
    private func moveLogin() {
        let model = UserModel(provider)
        let presenter = LoginViewPresenter(with: provider, model: model)
        self.view?.moveLogin(with: presenter)
    }
}

// MARK: - NicknameSettingPresenterDelegate
extension MyInfoViewPresenter: NicknameSettingPresenterDelegate {
    func nicknameSetting(_ presenter: NicknameSettingPresenter, didSuccess nickname: String) {
        view?.dismiss()
        view?.updateNameLabelText(with: nickname)
        model.save(nickname: nickname)
    }
    
    func nicknameSettingDidCancel(_ presenter: NicknameSettingPresenter) {
        view?.dismiss()
    }
}
