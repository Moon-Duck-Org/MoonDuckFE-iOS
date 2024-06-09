//
//  NameSettingViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import Foundation
import UIKit

protocol NameSettingPresenterDelegate: AnyObject {
    func nameSetting(_ presenter: NameSettingPresenter, didSuccess nickname: String)
    func nameSetting(didCancel presenter: NameSettingPresenter)
}

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
    weak var delegate: NameSettingPresenterDelegate?
    
    private var nameText: String?
    
    init(with provider: AppServices, model: UserModelType,
         delegate: NameSettingPresenterDelegate?) {
        self.delegate = delegate
        super.init(with: provider, model: model)
        model.delegate = self
    }
}

// MARK: - Input
extension NameSettingViewPresenter {
    func viewDidLoad() {
        // 초기화
        if let nickname = model.user?.nickname {
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
            delegate?.nameSetting(didCancel: self)
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
        delegate?.nameSetting(self, didSuccess: user.nickname)
    }
    func userModel(_ userModel: UserModel, didChange nickname: String) {
        delegate?.nameSetting(self, didSuccess: nickname)
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
