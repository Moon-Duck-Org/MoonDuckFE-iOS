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
    
    /// Life Cycle
    func viewDidLoad()
    
    /// Action
    func completeButtonTap()
    func textFieldDidEndEditing()
    func nameTextFieldDidChanges(_ text: String?)
    
    /// Data
    func isShouldChangeName(_ text: String) -> Bool
}

class NameSettingViewPresenter: Presenter, NameSettingPresenter {
    weak var view: NameSettingView?
    
    private var nameText: String?
    private var isInit: Bool
    
    init(with provider: AppServices, model: UserModelType, isInit: Bool = false) {
        self.isInit = isInit
        super.init(with: provider, model: model)
        model.delegate = self
    }
}

// MARK: - Input
extension NameSettingViewPresenter {
    func viewDidLoad() {
        // 초기화
        if !isInit {
            guard let nickname = model.user?.nickname else { return }
            view?.updateNameTextfield(nickname)
            view?.updateCountLabel(nickname.count)
            view?.updateCompleteButton(false)
            nameText = nickname
        }
    }
    
    func completeButtonTap() {
        guard let nameText else { return }
        
        if let userNickname = model.user?.nickname, 
            !userNickname.isEmpty,
           nameText == userNickname {
            view?.dismiss()
        } else {
            if isValidName(nameText) {
                model.nickname(nameText)
            } else {
                view?.showHintLabel(L10n.Localizable.specialCharactersAreNotAllowed)
            }
        }
        
    }
    
    func textFieldDidEndEditing() {
        if isValidName(nameText) {
            view?.clearHintLabel()
        } else {
            view?.showHintLabel(L10n.Localizable.specialCharactersAreNotAllowed)
        }
    }
    
    func nameTextFieldDidChanges(_ text: String?) {
        view?.updateCountLabel(text?.count ?? 0)
        view?.updateCompleteButton(text?.count ?? 0 > 1)
        nameText = text
    }
    
    func isShouldChangeName(_ text: String) -> Bool {
        if text.count > 10 || text.contains(" ") {
            return false
        } else {
            return true
        }
    }
    
    private func isValidName(_ text: String?) -> Bool {
        let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9]{1,10}$"
        if let text, text .range(of: pattern, options: .regularExpression) != nil {
            return true
        } else {
            return false
        }
    }
    
    private func moveLogin() {
        let presenter = LoginViewPresenter(with: provider, model: model)
        self.view?.moveLogin(with: presenter)
    }
}
// MARK: - UserModelDelegate
extension NameSettingViewPresenter: UserModelDelegate {
    func userModel(_ userModel: UserModel, didChange user: UserV2) {
        if !isInit {
            view?.dismiss()
        } else {
            // User 정보 조회 성공 -> 홈으로 이동
            let presenter = V2HomeViewPresenter(with: provider, model: model)
            view?.moveHome(with: presenter)
        }
        
    }
    func userModel(_ userModel: UserModel, didChange nickname: String) {
        if !isInit {
            
        } else {
            model.getUser()
        }
    }
    
    func userModel(_ userModel: UserModel, didRecieve error: UserModelError) {
        switch error {
        case .authError:
            AuthManager.default.logout()
            moveLogin()
        case .duplicateNickname:
            view?.showHintLabel(L10n.Localizable.duplicateNickname)
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
