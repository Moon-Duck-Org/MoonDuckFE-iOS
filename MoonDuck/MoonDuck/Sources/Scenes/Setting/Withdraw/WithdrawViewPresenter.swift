//
//  WithdrawViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 7/4/24.
//

import Foundation

protocol WithdrawPresenter: AnyObject {
    var view: WithdrawView? { get set }
    
    // Life Cycle
    func viewDidLoad()
    
    // Action
    func withdrawButtonTapped()
    func withdrawWithApple(authorizationCode: String)
}

class WithdrawViewPresenter: BaseViewPresenter, WithdrawPresenter {
    weak var view: WithdrawView?
//    private let model: UserModelType
    
    override init(with provider: AppServices, model: AppModels) {
        super.init(with: provider, model: model)
        self.model.userModel?.delegate = self
    }
}

extension WithdrawViewPresenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        let nickname = model.userModel?.user?.nickname ?? "사용자"
        let all = "\(model.userModel?.user?.all ?? 0)"
        let text: String = L10n.Localizable.Withdraw.text(nickname, all)
        view?.updateContentLabelText(with: text)
    }
    
    // MARK: - Action
    func withdrawButtonTapped() {
        view?.updateLoadingView(isLoading: true)
        if let loginType = AuthManager.shared.getLoginType() {
            if loginType == .apple {
                view?.showWithdrawWithAppleAlert()
            } else {
                model.userModel?.withdraw()
            }
        } else {
            view?.updateLoadingView(isLoading: false)
            view?.showErrorAlert(title: L10n.Localizable.Error.title("회원 탈퇴"), message: L10n.Localizable.Error.message)
        }
    }
    
    func withdrawWithApple(authorizationCode: String) {
        model.userModel?.withdrawWithApple(authorizationCode: authorizationCode)
    }
}

extension WithdrawViewPresenter: UserModelDelegate {
    func error(didRecieve error: APIError?) {
        view?.updateLoadingView(isLoading: false)
        
        guard let error else { return }
        
        if error.isAuthError {
            AuthManager.shared.logout()
            let appModel = AppModels(
                userModel: UserModel(provider)
            )
            let presenter = LoginViewPresenter(with: provider, model: appModel)
            view?.showAuthErrorAlert(with: presenter)
        } else if error.isNetworkError {
            view?.showNetworkErrorAlert()
        } else if error.isSystemError {
            view?.showSystemErrorAlert()
        } else {
            view?.showErrorAlert(title: L10n.Localizable.Error.title("회원 탈퇴"), message: L10n.Localizable.Error.message)
        }
    }
    
    func userModel(_ model: UserModelType, didChange user: User?) {
        view?.updateLoadingView(isLoading: false)
        
        let appModel = AppModels(
            userModel: UserModel(provider)
        )
        let presenter = IntroViewPresenter(with: provider, model: appModel)
        view?.showComplteWithDrawAlert(with: presenter)
    }
}
