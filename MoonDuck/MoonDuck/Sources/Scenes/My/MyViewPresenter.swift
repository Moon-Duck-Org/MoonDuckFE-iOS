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
    
    /// Life Cycle
    func viewDidLoad()
    
    /// Action
    func logoutButtonTap()
    
    /// Data
}

class MyViewPresenter: Presenter, MyPresenter {
    weak var view: MyView?
    
    override init(with provider: AppServices, model: UserModelType) {
        super.init(with: provider, model: model)
        model.delegate = self
    }
}

// MARK: - Input
extension MyViewPresenter {
    
    func viewDidLoad() {
        if let user = model.user {
            view?.updateNameLabel(user.nickname)
            view?.updateCountLabel(movie: user.movie, book: user.book, drama: user.drama, concert: user.concert)
        }
        
        model.getUser()
    }
    
    func logoutButtonTap() {
        AuthManager.default.logout()
        moveLogin()
    }
    
    private func moveLogin() {
        let presenter = LoginViewPresenter(with: provider, model: model)
        self.view?.moveLogin(with: presenter)
    }
}

// MARK: - UserModelDelegate
extension MyViewPresenter: UserModelDelegate {
    func userModel(_ userModel: UserModel, didChange user: UserV2) {
        guard let user = userModel.user else { return }
        view?.updateNameLabel(user.nickname)
        view?.updateCountLabel(movie: user.movie, book: user.book, drama: user.drama, concert: user.concert)
        
    }
    
    func userModel(_ userModel: UserModel, didRecieve error: UserModelError) {
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
        Log.todo("네트워크 오류 알럿 노출")
        view?.showToast("네트워크 오류 발생")
    }
}
