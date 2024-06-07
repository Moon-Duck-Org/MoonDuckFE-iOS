//
//  IntroViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation
import UIKit

protocol IntroPresenter: AnyObject {
    var view: IntroView? { get set }
    
    func viewDidLoad()
}

class IntroViewPresenter: Presenter, IntroPresenter {
    
    weak var view: IntroView?
    
}

// MARK: - Input
extension IntroViewPresenter {
    func viewDidLoad() {
        autoLogin()
    }
    
    private func autoLogin() {
        // TODO: 자동 로그인 체크
        login()
    }
}

// MARK: - Networking
extension IntroViewPresenter {
    func login() {
        // TODO: 로그인 API 수정
        if let id = UIDevice.current.identifierForVendor?.uuidString {
//            provider.userService.login(request: UserLoginRequest(deviceId: id)) { succeed, _ in
//                if let succeed, succeed {
//                    self.user(id: id)
//                } else {
                    let presenter = LoginViewPresenter(with: self.provider)
                    self.view?.moveLogin(with: presenter)
//                }
//            }
        }
    }
    
    func user(id: String) {
        let presenter = LoginViewPresenter(with: self.provider)
        self.view?.moveLogin(with: presenter)
//        provider.userService.user(request: UserRequest(deviceId: id)) { succeed, _ in
//            if let succeed {
//                let presenter = HomeViewPresenter(with: self.provider, user: succeed)
//                self.view?.moveHome(with: presenter)
//            } else {
//                let presenter = LoginViewPresenter(with: self.provider)
//                self.view?.moveLogin(with: presenter)
//            }
//        }
    }
}
