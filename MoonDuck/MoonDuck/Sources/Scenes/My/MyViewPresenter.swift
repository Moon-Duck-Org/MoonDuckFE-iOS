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
    
}

// MARK: - Input
extension MyViewPresenter {
    
    func viewDidLoad() {
        getUser()
    }
    
    func logoutButtonTap() {
        AuthManager.current.logout()
        moveLogin()
    }
    
    private func moveLogin() {
        let presenter = LoginViewPresenter(with: self.provider)
        self.view?.moveLogin(with: presenter)
    }
}

// MARK: - Networking
extension MyViewPresenter {
    private func getUser() {
        provider.userService.userTest { [weak self] succeed, failed in
            guard let self else { return }
            if let succeed {
                // User 정보 조회 성공
                AuthManager.current.saveUser(succeed)
                
                self.view?.updateNameLabel(succeed.nickname)
                self.view?.updateCountLabel(movie: succeed.movie, book: succeed.book, drama: succeed.drama, concert: succeed.concert)
            } else {
                // 오류 발생
                if let code = failed as? APIError {
                    if code.isAuthError {
                        Log.error("Auth Error \(code)")
                        AuthManager.current.logout()
                        self.moveLogin()
                        return
                    } else if code.neededRefreshToken {
                        AuthManager.current.refreshToken(self.provider.authService) { [weak self] code in
                            if code == .success {
                                self?.getUser()
                            } else {
                                Log.error("토큰 갱신 오류 \(code)")
                                AuthManager.current.logout()
                                self?.moveLogin()
                            }
                        }
                        return
                    }
                }
                Log.error(failed?.localizedDescription ?? "Nickname Error")
                self.networkError()
            }
        }
    }
    
    private func networkError() {
        Log.todo("네트워크 오류 알럿 노출")
        view?.showToast("네트워크 오류 발생")
    }
}
