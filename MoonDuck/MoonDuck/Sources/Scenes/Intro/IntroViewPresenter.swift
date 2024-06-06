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
    
    func viewDidLoad() {
        login()
    }
}

// MARK: - Networking
extension IntroViewPresenter {
    func login() {
        // FIXME: - UUID로 설정
        if let id = UIDevice.current.identifierForVendor?.uuidString {
            provider.userService.login(request: UserLoginRequest(deviceId: id)) { succeed, _ in
                if let succeed, succeed {
                    self.user(id: id)
                } else {
                    let joinUser = JoinUser(deviceId: id, nickname: "")
                    let presenter = LoginViewPresenter(with: self.provider, joinUser: joinUser)
                    self.view?.moveLogin(with: presenter)
                }
            }
        }
    }
    
    func user(id: String) {
        provider.userService.user(request: UserRequest(deviceId: id)) { succeed, _ in
            if let succeed {
                let presenter = HomeViewPresenter(with: self.provider, user: succeed)
                self.view?.moveHome(with: presenter)
            } else {
                let joinUser = JoinUser(deviceId: id, nickname: "")
                let presenter = LoginViewPresenter(with: self.provider, joinUser: joinUser)
                self.view?.moveLogin(with: presenter)
            }
        }
    }
}
