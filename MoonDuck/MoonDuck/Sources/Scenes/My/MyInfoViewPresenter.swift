//
//  MyInfoViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 6/8/24.
//

import Foundation
import UIKit

protocol MyInfoPresenter: AnyObject {
    var view: MyInfoView? { get set }
    
    /// Data
    
    /// Life Cycle
    func viewDidLoad()
    
    /// Action
    func logoutButtonTap()
    func settingNameButtonTap()
}

class MyInfoViewPresenter: Presenter, MyInfoPresenter {
    weak var view: MyInfoView?
    let model: UserModelType
    
    init(with provider: AppServices, model: UserModelType) {
        self.model = model
        super.init(with: provider)
        self.model.delegate = self
    }
}

extension MyInfoViewPresenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        if let user = model.user {
            view?.updateNameLabel(user.nickname)
            view?.updateCountLabel(movie: user.movie, book: user.book, drama: user.drama, concert: user.concert)
        } else {
            view?.updateLoadingView(true)
            model.getUser()
        }
    }
    
    // MARK: - Action
    func settingNameButtonTap() {
        let presenter = NameSettingViewPresenter(with: provider, user: model.user, delegate: self)
        view?.presentNameSetting(with: presenter)
    }
    
    func logoutButtonTap() {
        AuthManager.default.logout()
        moveLogin()
    }
    
    // MARK: - Logic
    private func moveLogin() {
        let presenter = LoginViewPresenter(with: provider)
        self.view?.moveLogin(with: presenter)
    }
}

// MARK: - UserModelDelegate
extension MyInfoViewPresenter: UserModelDelegate {
    func userModel(_ model: UserModel, didChange user: User) {
        view?.updateLoadingView(false)
        view?.updateNameLabel(user.nickname)
        view?.updateCountLabel(movie: user.movie, book: user.book, drama: user.drama, concert: user.concert)
    }
    
    func userModel(_ model: UserModel, didRecieve error: UserModelError) {
        view?.updateLoadingView(false)
        switch error {
        case .authError:
            AuthManager.default.logout()
            moveLogin()
        default:
            break
        }
    }
    
    func userModel(_ model: UserModel, didRecieve error: Error?) {
        networkError()
    }
    
    private func networkError() {
        view?.updateLoadingView(false)
        Log.todo("네트워크 오류 알럿 노출")
        view?.showToast("네트워크 오류 발생")
    }
}

// MARK: - NameSettingPresenterDelegate
extension MyInfoViewPresenter: NameSettingPresenterDelegate {
    func nameSetting(_ presenter: NameSettingPresenter, didSuccess nickname: String) {
        view?.dismiss()
        model.save(nickname: nickname)
    }
    
    func nameSetting(didCancel presenter: NameSettingPresenter) {
        view?.dismiss()
    }
}
