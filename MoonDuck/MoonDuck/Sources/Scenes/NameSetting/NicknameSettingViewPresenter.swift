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
    func nicknameSettingDidCancel(_ presenter: NicknameSettingPresenter)
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
    func textFieldDidChangeSelection(_ text: String?)
    func textFieldDidBeginEditing(_ text: String?)
    func textFieldShouldReturn(_ text: String?) -> Bool
    func textFieldDidEndEditing(_ text: String?)
}

class NicknameSettingViewPresenter: BaseViewPresenter, NicknameSettingPresenter {
    weak var view: NicknameSettingView?
    
    private weak var delegate: NicknameSettingPresenterDelegate?
    private let model: UserModelType
    private let isNew: Bool
    
    private let maxNicknameCount: Int = 10
    private var nicknameText: String?
    
    init(with provider: AppServices,
         model: UserModelType,
         delegate: NicknameSettingPresenterDelegate?) {
        self.model = model
        self.delegate = delegate
        self.isNew = delegate == nil
        super.init(with: provider)
        self.model.delegate = self
    }
}

extension NicknameSettingViewPresenter {
    // MARK: - Life Cycle
    func viewDidLoad() {
        // 닉네임이 세팅
        let nickname = model.user?.nickname ?? ""
        view?.updateCancelButtonHidden(isNew)
        view?.updateNameTextfieldText(with: nickname)
        view?.updateCountLabelText(with: "\(nickname.count)/\(maxNicknameCount)")
        nicknameText = nickname
        view?.updateCompleteButtonEnabled(false)
        view?.createTouchEvent()
    }
    
    // MARK: - Action
    func completeButtonTapped() {
        guard let nicknameText else { return }
        
        if let userNickname = model.user?.nickname,
            !userNickname.isEmpty,
           nicknameText == userNickname {
            delegate?.nicknameSettingDidCancel(self)
        } else {
            if isValidNickname(nicknameText) {
                view?.updateLoadingView(isLoading: true)
                model.nickname(nicknameText)
            } else {
                view?.updateHintLabelText(with: L10n.Localizable.NicknameSetting.invalidNameHint)
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
        view?.updateCountLabelText(with: "\(text?.count ?? 0)/\(maxNicknameCount)")
        view?.updateCompleteButtonEnabled(text?.count ?? 0 > 1)
        nicknameText = text
    }
    
    func textField(_ text: String?, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changeText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if string.contains(" ") {
            return false
        }
        
        if changeText.count <= maxNicknameCount {
            return true
        }
        
        let lastWordOfCurrentText = String(currentText[currentText.index(before: stringRange.lowerBound)]) // 입력하기 전 text의 마지막 글자 입니다.
        let separatedCharacters = lastWordOfCurrentText.decomposedStringWithCanonicalMapping.unicodeScalars.map { String($0) } // 입력하기 전 text의 마지막 글자를 자음과 모음으로 분리해줍니다.
        let separatedCharactersCount = separatedCharacters.count // 분리된 자음, 모음의 개수입니다.
        
        if separatedCharactersCount == 1 && !string.isConsonant { // -- A
            return true
        }
        
        if separatedCharactersCount == 2 && (string.isConsonant || string.isVowel) { // -- B
            return true
        }
        
        if separatedCharactersCount == 3 && string.isConsonant { // -- C
            return true
        }
        
        return false
    }
    
    func textFieldDidChangeSelection(_ text: String?) {
        var text = text ?? "" // textField에 수정이 반영된 후의 text 입니다.
        if text.count > maxNicknameCount {
            let startIndex = text.startIndex
            let endIndex = text.index(startIndex, offsetBy: maxNicknameCount - 1)
            let fixedText = String(text[startIndex...endIndex])
            view?.updateNameTextfieldText(with: fixedText)
            nicknameText = text
        }
    }
    
    func textFieldDidBeginEditing(_ text: String?) {
        view?.isEditingText = true
        view?.updateHintLabelText(with: "")
    }
    
    func textFieldShouldReturn(_ text: String?) -> Bool {
        view?.endEditing()
        return true
    }
    
    func textFieldDidEndEditing(_ text: String?) {
        guard let text else { return }
        if isValidNickname(text) {
            view?.updateHintLabelText(with: "")
        } else {
            view?.updateHintLabelText(with: L10n.Localizable.NicknameSetting.invalidNameHint)
        }
    }
}

// MARK: - UserModelDelegate
extension NicknameSettingViewPresenter: UserModelDelegate {
    
    func userModel(_ model: UserModelType, didChange user: User?) {
        // 닉네임 변경 성공
        view?.updateLoadingView(isLoading: false)
        
        if let user {
            if isNew {
                let cateogryModel = CategoryModel()
                let reviewModel = ReviewListModel(provider)
                let sortModel = SortModel()
                let presenter = HomeViewPresenter(with: provider, userModel: model, categoryModel: cateogryModel, sortModel: sortModel, reviewModel: reviewModel)
                view?.moveHome(with: presenter)
            } else {
                delegate?.nicknameSetting(self, didSuccess: user.nickname)
            }
        }
    }
    
    func userModel(_ model: UserModelType, didRecieve error: APIError?) {
        view?.updateLoadingView(isLoading: false)
        
        if let error, error.isNetworkError {
            view?.showNetworkErrorAlert()
        } else {
            view?.showSystemErrorAlert()
        }
    }
    
    func userModelDidDuplicateNickname(_ model: UserModelType) {
        view?.updateLoadingView(isLoading: false)
        view?.updateHintLabelText(with: L10n.Localizable.NicknameSetting.duplicateNameHint)
    }
    
    func userModelDidAuthError(_ model: UserModelType) {
        view?.updateLoadingView(isLoading: false)
        AuthManager.default.logout()
        moveLogin()
    }
}
