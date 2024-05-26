//
//  NameSettingViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import Foundation
import UIKit

protocol NameSettingPresenter: AnyObject {
    var view: NameSettingView? { get set }
    var service: AppServices { get }
    
    func changeText(current: String, change: String) -> Bool
    func checkValid(_ text: String?)
    func completeButtonTap()
}

class NameSettingViewPresenter: NameSettingPresenter {
    
    weak var view: NameSettingView?
    
    let service: AppServices
    private let user: JoinUser
    
    init(with service: AppServices, user: JoinUser) {
        self.service = service
        self.user = user
    }
    
    func checkValid(_ text: String?) {
        let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9]{1,10}$"
        if let text, text.range(of: pattern, options: .regularExpression) != nil {
            // TODO: 중복 확인 API
            nickName(text)
        } else {
            view?.showErrorText("특수문자는 사용 불가해요.")
        }
    }
    
    func completeButtonTap() {
        view?.completeButtonTap()
    }
    
    func changeText(current: String, change: String) -> Bool {
        view?.updateCountText(change.count)
        view?.updateCompleteButton(isEnabled: change.count > 2)
        return change.count < 10
    }
}

// MARK: - Networking
extension NameSettingViewPresenter {
    func nickName(_ name: String) {
        let request = UserNicknameRequest(deviceId: user.deviceId, nickname: name)
        service.userService.nickname(request: request) { succeed, _ in
            if let succeed {
                self.view?.moveHome(with: self.service, user: succeed)
            } else {
                self.view?.showErrorText("중복된 닉네임입니다.")
            }
        }
    }
}
