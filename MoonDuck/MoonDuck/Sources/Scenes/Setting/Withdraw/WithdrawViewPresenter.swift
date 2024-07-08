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
}

class WithdrawViewPresenter: BaseViewPresenter, WithdrawPresenter {
    weak var view: WithdrawView?
    private let model: UserModelType
    
    init(with provider: AppServices, model: UserModelType) {
        self.model = model
        super.init(with: provider)
        self.model.delegate = self
    }
}

extension WithdrawViewPresenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        let nickname = model.user?.nickname ?? "사용자"
        let all = "\(model.user?.all ?? 0)"
        let text: String =
                            """
                            \(nickname)님은 문덕이와
                            \(all)번의 기록을 함께했어요.
                            정말 탈퇴하시겠어요? 너무 아쉬워요.
                            """
        view?.updateContentLabelText(with: text)
    }
    
    // MARK: - Action
    func withdrawButtonTapped() {
        view?.updateLoadingView(isLoading: true)
        model.deleteUser()
    }
    
    // MARK: - Logic
}

extension WithdrawViewPresenter: UserModelDelegate {
    func userModelDidAuthError(_ model: UserModelType) {
        view?.updateLoadingView(isLoading: false)
        AuthManager.default.logout()
        let model = UserModel(provider)
        let presenter = LoginViewPresenter(with: provider, model: model)
        view?.showAuthErrorAlert(with: presenter)
    }
    
    func userModelDidFailDeleteUser(_ model: UserModelType) {
        view?.updateLoadingView(isLoading: false)
        view?.showToastMessage("회원 탈퇴에 실패했습니다. 다시 시도해주세요. 문제가 지속되면 '설정->문의하기'에 문의해주세요.")
    }
    
    func userModel(_ model: UserModelType, didChange user: User?) {
        view?.updateLoadingView(isLoading: false)
        AuthManager.default.logout()
        
        let presenter = IntroViewPresenter(with: provider, model: model)
        view?.showComplteWithDrawAlert(with: presenter)
    }
}
