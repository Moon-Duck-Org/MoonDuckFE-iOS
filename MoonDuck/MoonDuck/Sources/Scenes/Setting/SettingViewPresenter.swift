//
//  SettingViewPrsenter.swift
//  MoonDuck
//
//  Created by suni on 7/3/24.
//

import Foundation

protocol SettingPresenter: AnyObject {
    var view: SettingView? { get set }
    
    // Data
    var contractUs: ContractUs { get }
    
    // Life Cycle
    func viewDidLoad()
    
    // Action
    func termsOfServiceButtonTapped()
    func privacyPolicyButtonTapped()
    func appVersionButtonTapped()
    func noticeButtonTapped()
    func withdrawButtonTapped()
    
}

class SettingViewPrsenter: Presenter, SettingPresenter {
    weak var view: SettingView?
    private let model: UserModelType
    
    init(with provider: AppServices, model: UserModelType) {
        self.model = model
        super.init(with: provider)
    }
    
    // MARK: - Data
    var contractUs: ContractUs {
        let nickname = model.user?.nickname ?? ""
        return ContractUs(nickName: nickname, appVersion: "1.0.0")
    }
    
}

extension SettingViewPrsenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        
    }
    
    // MARK: - Action
    func termsOfServiceButtonTapped() {
        let title = "서비스 이용약관"
        let url = "https://sunidev.notion.site/c85019c82e444fceb580e4667dce8a48?pvs=4"
        let presenter = WebViewPresenter(with: provider, title: title, url: url)
        view?.moveWebview(with: presenter)
    }
    
    func privacyPolicyButtonTapped() {
        let title = "개인정보 처리방침"
        let url = "https://sunidev.notion.site/2282adad10e740f08f5d6a30f4704e87?pvs=4"
        let presenter = WebViewPresenter(with: provider, title: title, url: url)
        view?.moveWebview(with: presenter)
    }
    
    func appVersionButtonTapped() {
        
    }
    
    func noticeButtonTapped() {
        let title = "공지사항"
        let url = "https://sunidev.notion.site/c77f983fa04e4525917b80ea1a4f3c22?pvs=4"
        let presenter = WebViewPresenter(with: provider, title: title, url: url)
        view?.moveWebview(with: presenter)
    }
    
    func withdrawButtonTapped() {
        let presenter = WithdrawViewPresenter(with: provider, model: model)
        view?.moveWithdraw(with: presenter)
    }
    
    // MARK: - Logic
}
