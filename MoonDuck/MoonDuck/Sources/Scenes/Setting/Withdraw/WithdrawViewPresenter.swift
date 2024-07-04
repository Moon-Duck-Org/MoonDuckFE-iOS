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
}

class WithdrawViewPresenter: Presenter, WithdrawPresenter {
    weak var view: WithdrawView?
    private let model: UserModelType
    
    init(with provider: AppServices, model: UserModelType) {
        self.model = model
        super.init(with: provider)
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
        view?.updateContentLabel(with: text)
    }
    
    // MARK: - Action
    
    // MARK: - Logic
}
