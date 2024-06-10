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
    
    /// Data
    func isShouldChangeName(_ text: String) -> Bool
    
    /// Life Cycle
    func viewDidLoad()
    
    /// Action
    func completeButtonTap()
    func textFieldDidEndEditing()
    func nameTextFieldDidChanges(_ text: String?)
}

class NameSettingViewPresenter: Presenter, NameSettingPresenter {
    weak var view: NameSettingView?
    weak var delegate: NameSettingPresenterDelegate?
    let model: UserModelType
    
    private var nameText: String?
    
    init(with provider: AppServices, user: UserV2?,
         delegate: NameSettingPresenterDelegate?) {
        self.model = UserModel(provider)
        self.delegate = delegate
        super.init(with: provider)
        
        if let user = user {
            self.model.user = user
        }
        self.model.delegate = self
    }
    
    // MARK: - Data
    func isShouldChangeName(_ text: String) -> Bool {
        if text.count > 10 || text.contains(" ") {
            return false
        } else {
            return true
        }
    }
}

extension NameSettingViewPresenter {
    // MARK: - Life Cycle
    func viewDidLoad() {
        // 초기화
        if let nickname = model.user?.nickname {
            view?.updateNameTextfield(nickname)
            view?.updateCountLabel(nickname.count)
            view?.updateCompleteButton(false)
            nameText = nickname
        }
    }
    
    // MARK: - Action
    func completeButtonTap() {
        guard let nameText else { return }
        
        if let userNickname = model.user?.nickname, 
            !userNickname.isEmpty,
           nameText == userNickname {
            delegate?.nameSetting(didCancel: self)
        } else {
            if isValidName(nameText) {
                view?.updateLoadingView(true)
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
    
    // MARK: - Logic
    private func isValidName(_ text: String?) -> Bool {
        let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9]{1,10}$"
        if let text, text .range(of: pattern, options: .regularExpression) != nil {
            return true
        } else {
            return false
        }
    }
    
    private func moveLogin() {
        let presenter = LoginViewPresenter(with: provider)
        self.view?.moveLogin(with: presenter)
    }
}

// MARK: - UserModelDelegate
extension NameSettingViewPresenter: UserModelDelegate {
    func userModel(_ userModel: UserModel, didChange user: UserV2) {
        view?.updateLoadingView(false)
        delegate?.nameSetting(self, didSuccess: user.nickname)
    }
    func userModel(_ userModel: UserModel, didChange nickname: String) {
        view?.updateLoadingView(false)
        delegate?.nameSetting(self, didSuccess: nickname)
    }
    
    func userModel(_ userModel: UserModel, didRecieve error: UserModelError) {
        view?.updateLoadingView(false)
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
        view?.updateLoadingView(false)
        Log.todo("네트워크 오류 알럿 노출")
        view?.showToast("네트워크 오류 발생")
    }
}
