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
    var service: AppServices { get }
    
    func viewDidLoad()
}

class IntroViewPresenter: IntroPresenter {
    
    weak var view: IntroView?
    
    let service: AppServices
    
    init(with service: AppServices) {
        self.service = service
    }
    
    func viewDidLoad() {
        login()
        // FIXME: - TEST CODE : 홈 진입
//        self.view?.moveHome(with: self.service, user: User(deviceId: "123", nickname: "포덕이"))
    }
}

// MARK: - Networking
extension IntroViewPresenter {
    func login() {
        // FIXME: - UUID로 설정
        if let id = UIDevice.current.identifierForVendor?.uuidString {
            service.userService.login(request: UserLoginRequest(deviceId: id)) { succeed, _ in
                if let succeed, succeed {
                    self.user(id: id)
                } else {
                    self.view?.moveOnboard(with: self.service, user: User(deviceId: id, nickname: ""))
                }
            }
        }
    }
    
    func user(id: String) {
        service.userService.user(request: UserRequest(deviceId: id)) { succeed, _ in
            if let succeed {
                self.view?.moveHome(with: self.service, user: succeed)
            } else {
                self.view?.moveOnboard(with: self.service, user: User(deviceId: id, nickname: ""))
            }
        }
    }
}
