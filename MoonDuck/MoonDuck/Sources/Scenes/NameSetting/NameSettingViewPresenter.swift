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
}

// MARK: - Input
extension NameSettingViewPresenter {
    func viewDidLoad() {
        // 초기화
    }
    
    func completeButtonTap() {
        guard let nameText else { return }
        if isValidName(nameText) {
            nickName(nameText)
        } else {
            view?.showHintLabel(L10n.Localizable.specialCharactersAreNotAllowed)
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
        let presenter = LoginViewPresenter(with: self.provider)
        self.view?.moveLogin(with: presenter)
    }
}

// MARK: - Networking
extension NameSettingViewPresenter {
    private func nickName(_ name: String) {
        let request = UserNicknameRequest(nickname: name)
        provider.userService.nickname(request: request) { [weak self] succeed, failed in
            if let succeed {
                // 닉네임 변경 성공
                self?.getUser()
            } else {
                // 오류 발생
                if let code = failed as? APIError {
                    if code.isAuthError {
                        Log.error("Auth Error \(code)")
                        self?.moveLogin()
                        return
                    }
                    
                    if code.neededRefreshToken {
                        AuthManager.current.refreshToken(self?.provider.authService) { [weak self] code in
                            if code == .success {
                                self?.nickName(name)
                            } else {
                                Log.error("토큰 갱신 오류 \(code)")
                                self?.moveLogin()
                            }
                        }
                        return
                    }
                    
                    if code == .duplicateNickname(code.errorDescription) {
                        // 중복된 닉네임
                        self?.view?.showHintLabel(L10n.Localizable.duplicateNickname)
                        return
                    }
                }
                Log.error(failed?.localizedDescription ?? "Nickname Error")
                self?.networkError()
            }
        }
    }
    
    private func getUser() {
        provider.userService.user { [weak self] succeed, failed in
            guard let self else { return }
            if let succeed {
                // User 정보 조회 성공
                AuthManager.current.saveUser(succeed)
                
                let presenter = V2HomeViewPresenter(with: self.provider)
                self.view?.moveHome(with: presenter)
            } else {
                Log.error(failed?.localizedDescription ?? "User Error")
                self.networkError()
            }
        }
    }
    
    private func networkError() {
        Log.todo("네트워크 오류 알럿 노출")
        view?.showToast("네트워크 오류 발생")
    }
}
