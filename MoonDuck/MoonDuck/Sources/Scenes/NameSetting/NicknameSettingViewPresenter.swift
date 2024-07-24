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
        view?.updateNameTextFieldText(with: nickname)
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
        guard let text else { return }
        
        var currentText = text
        if text.count > maxNicknameCount {
            let maxIndex = text.index(text.startIndex, offsetBy: maxNicknameCount)
            let replaceText = String(text[..<maxIndex])
            view?.updateNameTextFieldText(with: replaceText)
            currentText = replaceText
        }
        
        view?.updateCountLabelText(with: "\(currentText.count)/\(maxNicknameCount)")
        view?.updateCompleteButtonEnabled(currentText.count > 1)
        nicknameText = currentText
    }
    
    func textField(_ text: String?, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.contains(" ") {
            return false
        } else {
            return true
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
    func error(didRecieve error: APIError?) {
        view?.updateLoadingView(isLoading: false)
        
        guard let error else { return }
        
        if error.isAuthError {
            AuthManager.shared.logout()
            let model = UserModel(provider)
            let presenter = LoginViewPresenter(with: provider, model: model)
            view?.showAuthErrorAlert(with: presenter)
        } else if error.duplicateNickname {
            // 중복된 닉네임
            view?.updateHintLabelText(with: L10n.Localizable.NicknameSetting.duplicateNameHint)
        } else if error.isNetworkError {
            view?.showNetworkErrorAlert()
        } else {
            view?.showSystemErrorAlert()
        }
    }
    
    
    func userModel(_ model: UserModelType, didChange user: User?) {
        // 닉네임 변경 성공
        view?.updateLoadingView(isLoading: false)
        
        if let user {
            if isNew {
                let cateogryModel = CategoryModel()
                let reviewModel = ReviewListModel(provider)
                let sortModel = SortModel()
                let shareModel = ShareModel(provider)
                let presenter = HomeViewPresenter(with: provider, userModel: model, categoryModel: cateogryModel, sortModel: sortModel, reviewModel: reviewModel, shareModel: shareModel)
                view?.moveHome(with: presenter)
            } else {
                delegate?.nicknameSetting(self, didSuccess: user.nickname)
            }
        }
    }
}
