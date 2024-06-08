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
    
    private func networkError() {
        Log.todo("네트워크 오류 알럿 노출")
        view?.showToast("네트워크 오류 발생")
    }
}

// MARK: - Networking
extension NameSettingViewPresenter {
    func nickName(_ name: String) {
        let request = UserNicknameRequest(nickname: name)
        provider.userService.nickname(request: request) { [weak self] code, succeed, failed in
            if let succeed {
                // 닉네임 변경 성공
                self?.getUser()
            } else {
                // 오류 발생
                if code == .duplicateNickname {
                    // 중복된 닉네임
                    self?.view?.showHintLabel(L10n.Localizable.duplicateNickname)
                } else {
                    // 다른 오류
                    Log.error(failed?.localizedDescription ?? "Nickname Error")
                    self?.networkError()
                }
            }
        }
    }
    
    func getUser() {
        provider.userService.user { [weak self] code, succeed, failed in
            guard let self else { return }
            if let succeed {
                // User 정보 조회 성공
                AuthManager.current.login(succeed)
                self.view?.showToast("로그인 성공.")
                
                let presenter = V2HomeViewPresenter(with: self.provider)
                self.view?.moveHome(with: presenter)
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
}
