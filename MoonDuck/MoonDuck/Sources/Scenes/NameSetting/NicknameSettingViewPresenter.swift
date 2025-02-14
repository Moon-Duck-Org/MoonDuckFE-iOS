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
    private let isNew: Bool
    
    private let maxNicknameCount: Int = 10
    private var nicknameText: String?
    
    init(with provider: AppStorages,
         model: AppModels,
         delegate: NicknameSettingPresenterDelegate?) {
        self.delegate = delegate
        self.isNew = delegate == nil
        super.init(with: provider, model: model)
        self.model.userModel?.delegate = self
    }
}

extension NicknameSettingViewPresenter {
    // MARK: - Life Cycle
    func viewDidLoad() {
        // 닉네임이 세팅
        let nickname = model.userModel?.user.nickname ?? ""
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
        
        if let userNickname = model.userModel?.user.nickname,
            !userNickname.isEmpty,
           nicknameText == userNickname {
            delegate?.nicknameSettingDidCancel(self)
        } else {
            if isValidNickname(nicknameText) {
                view?.updateLoadingView(isLoading: true)
                model.userModel?.setNickname(nickname: nicknameText)
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
            AnalyticsService.shared.logEvent(
                .FAIL_NICKNAME_SETTING_INVALID,
                parameters: [.NICKNAME: nicknameText ?? ""]
            )
            view?.updateHintLabelText(with: L10n.Localizable.NicknameSetting.invalidNameHint)
        }
    }
}

// MARK: - UserModelDelegate
extension NicknameSettingViewPresenter: UserModelDelegate {
    func error(didRecieve error: APIError?) {
        view?.updateLoadingView(isLoading: false)
    }
    
    func userModel(_ model: UserModelType, didChange user: User) {
        // 닉네임 변경 성공
        view?.updateLoadingView(isLoading: false)
        
        if let nickname = user.nickname {
            AnalyticsService.shared.logEvent(.SUCCESS_NICKNAME_SETTING, parameters: [.NICKNAME: user.nickname ?? ""])
            
            if isNew {
                let snsType = AuthManager.shared.getLoginType()?.rawValue ?? ""
                AnalyticsService.shared.logEvent(
                    .SUCCESS_LOGIN_NEW,
                    parameters: [.SNS_TYPE: snsType]
                )
                
//                let appModel = AppModels(
//                    userModel: model,
//                    categoryModel: CategoryModel(),
//                    sortModel: SortModel(),
//                    reviewListModel: ReviewListModel(provider),
//                    shareModel: ShareModel(provider)
//                )
                let appModel = AppModels(
                    userModel: model
                )
                let presenter = HomeViewPresenter(with: provider, model: appModel)
                view?.moveHome(with: presenter)
            } else {
                delegate?.nicknameSetting(self, didSuccess: nickname)
            }
        }
    }
}
