//
//  NicknameSettingViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/24/24.
//

import Foundation
import UIKit

protocol NicknameSettingPresenterDelegate: AnyObject {
    func nicknameSetting(_ presenter: NicknameSettingPresenter, didSuccess nickname: String)
    func nicknameSetting(didCancel presenter: NicknameSettingPresenter)
}

protocol NicknameSettingPresenter: AnyObject {
    var view: NicknameSettingView? { get set }
    
    // Life Cycle
    func viewDidLoad()
    
    // Action
    func completeButtonTapped()
    
    // TextField Delegate
    func nicknameTextFieldEditingChanged(_ text: String?)
    func textField(_ text: String?, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    func textFieldDidBeginEditing(_ text: String?)
    func textFieldShouldReturn(_ text: String?) -> Bool
    func textFieldDidEndEditing(_ text: String?)
}

class NicknameSettingViewPresenter: Presenter, NicknameSettingPresenter {
    weak var view: NicknameSettingView?
    
    private weak var delegate: NicknameSettingPresenterDelegate?
    private let model: UserModelType
    
    private let maxNicknameCount: Int = 10
    private var nicknameText: String?
    
    init(with provider: AppServices,
         model: UserModelType,
         delegate: NicknameSettingPresenterDelegate?) {
        self.model = model
        self.delegate = delegate
        super.init(with: provider)
        self.model.delegate = self
    }
}

extension NicknameSettingViewPresenter {
    // MARK: - Life Cycle
    func viewDidLoad() {
        // 닉네임이 세팅
        if let nickname = model.user?.nickname {
            view?.updateCancelButton(false)
            view?.updateNameTextfield(nickname)
            view?.updateCountLabel("\(nickname.count)/\(maxNicknameCount)")
            nicknameText = nickname
        } else {
            view?.updateCancelButton(false)
        }
        view?.updateCompleteButton(false)
        view?.createTouchEvent()
    }
    
    // MARK: - Action
    func completeButtonTapped() {
        guard let nicknameText else { return }
        
        if let userNickname = model.user?.nickname,
            !userNickname.isEmpty,
           nicknameText == userNickname {
            delegate?.nicknameSetting(didCancel: self)
        } else {
            if isValidNickname(nicknameText) {
                view?.updateLoadingView(true)
                model.nickname(nicknameText)
            } else {
                view?.updateHintLabel(L10n.Localizable.specialCharactersAreNotAllowed)
            }
        }
    }

    // MARK: - Logic
    private func isValidNickname(_ text: String?) -> Bool {
        let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9]{1,10}$"
        if let text, text .range(of: pattern, options: .regularExpression) != nil {
            return true
        } else {
            return false
        }
    }
    
    private func moveLogin() {
        let model = UserModel(provider)
        let presenter = LoginViewPresenter(with: provider, model: model)
        view?.moveLogin(with: presenter)
    }
}
// MARK: - UITextFieldDelegate
extension NicknameSettingViewPresenter {
    func nicknameTextFieldEditingChanged(_ text: String?) {
        view?.updateCountLabel("\(text?.count ?? 0)/\(maxNicknameCount)")
        view?.updateCompleteButton(text?.count ?? 0 > 1)
        nicknameText = text
    }
    
    func textField(_ text: String?, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changeText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if changeText.count > maxNicknameCount || changeText.contains(" ") {
            return false
        } else {
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ text: String?) {
        view?.isEditingText = true
        view?.updateHintLabel("")
    }
    
    func textFieldShouldReturn(_ text: String?) -> Bool {
        view?.endEditing()
        return true
    }
    
    func textFieldDidEndEditing(_ text: String?) {
        guard let text else { return }
        if isValidNickname(text) {
            view?.updateHintLabel("")
        } else {
            view?.updateHintLabel(L10n.Localizable.specialCharactersAreNotAllowed)
        }
    }
}

// MARK: - UserModelDelegate
extension NicknameSettingViewPresenter: UserModelDelegate {
    func user(_ model: UserModel, didChange user: User) {
        // 닉네임 변경 성공
        view?.updateLoadingView(false)
        delegate?.nicknameSetting(self, didSuccess: user.nickname)
    }
    
    func user(_ model: UserModel, didRecieve error: UserModelError) {
        view?.updateLoadingView(false)
        switch error {
        case .authError:
            AuthManager.default.logout()
            moveLogin()
        case .duplicateNickname:
            view?.updateHintLabel(L10n.Localizable.duplicateNickname)
        }
    }
    
    func user(_ model: UserModel, didRecieve error: Error?) {
        networkError()
    }
    
    private func networkError() {
        view?.updateLoadingView(false)
        Log.todo("네트워크 오류 알럿 노출")
        view?.showToast("네트워크 오류 발생")
    }
}
