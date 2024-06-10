//
//  MyViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 6/8/24.
//

import Foundation
import UIKit

protocol MyPresenter: AnyObject {
    var view: MyView? { get set }
    
    /// Data
    
    /// Life Cycle
    func viewDidLoad()
    
    /// Action
    func logoutButtonTap()
    func settingNameButtonTap()
}

class MyViewPresenter: Presenter, MyPresenter {
    weak var view: MyView?
    let model: UserModelType
    
    init(with provider: AppServices, model: UserModelType) {
        self.model = model
        super.init(with: provider)
        self.model.delegate = self
    }
}

extension MyViewPresenter {
    
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
extension MyViewPresenter: UserModelDelegate {
    func userModel(_ userModel: UserModel, didChange user: UserV2) {
        view?.updateLoadingView(false)
        guard let user = userModel.user else { return }
        view?.updateNameLabel(user.nickname)
        view?.updateCountLabel(movie: user.movie, book: user.book, drama: user.drama, concert: user.concert)
    }
    
    func userModel(_ userModel: UserModel, didChange nickname: String) {
        view?.updateLoadingView(false)
        view?.updateNameLabel(nickname)
    }
    
    func userModel(_ userModel: UserModel, didRecieve error: UserModelError) {
        view?.updateLoadingView(false)
        switch error {
        case .authError:
            AuthManager.default.logout()
            moveLogin()
        default:
            break
        }
    }
    
    func userModel(_ userModel: UserModel, didRecieve error: Error?) {
        networkError()
    }
    
    private func networkError() {
        view?.updateLoadingView(false)
        Log.todo("네트워크 오류 알럿 노출")
        view?.showToast("네트워크 오류 발생")
    }
}

// MARK: - NameSettingPresenterDelegate
extension MyViewPresenter: NameSettingPresenterDelegate {
    func nameSetting(_ presenter: NameSettingPresenter, didSuccess nickname: String) {
        view?.dismiss()
        model.updateNickname(nickname)
    }
    
    func nameSetting(didCancel presenter: NameSettingPresenter) {
        view?.dismiss()
    }
}
