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
}

// MARK: - Networking
extension MyViewPresenter {
    private func getUser() {
        provider.userService.user { [weak self] code, succeed, failed in
            guard let self else { return }
            if let succeed {
                // User 정보 조회 성공
                AuthManager.current.update(succeed)
                
                self.view?.updateCountLabel(movie: succeed.movie, book: succeed.book, drama: succeed.drama, concert: succeed.concert)
            } else {
                if code == .tokenExpiryDate {
                    // TODO: 토큰 갱신
                } else {
                    Log.error(failed?.localizedDescription ?? "User Error")
                    self.networkError()
                }
            }
        }
    }
    
    private func networkError() {
        Log.todo("네트워크 오류 알럿 노출")
        view?.showToast("네트워크 오류 발생")
    }
}
