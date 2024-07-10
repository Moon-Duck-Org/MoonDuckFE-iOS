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

class SettingViewPrsenter: BaseViewPresenter, SettingPresenter {
    weak var view: SettingView?
    private let model: UserModelType
    
    init(with provider: AppServices, model: UserModelType) {
        self.model = model
        super.init(with: provider)
    }
    
    // MARK: - Data
    var contractUs: ContractUs {
        let nickname = model.user?.nickname ?? ""
        return ContractUs(nickName: nickname, appVersion: Utils.getAppVersion() ?? "")
    }
    
}

extension SettingViewPrsenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        view?.updateAppVersionLabelText(with: Utils.getAppVersion() ?? "")
    }
    
    // MARK: - Action
    func termsOfServiceButtonTapped() {
        let title = L10n.Localizable.Title.service
        let url = MoonDuckAPI.baseUrl() + "/root/moonduck/contract.html"
        let presenter = WebViewPresenter(with: provider, title: title, url: url)
        view?.moveWebview(with: presenter)
    }
    
    func privacyPolicyButtonTapped() {
        let title = L10n.Localizable.Title.policy
        let url = MoonDuckAPI.baseUrl() + "/root/moonduck/privacy.html"
        let presenter = WebViewPresenter(with: provider, title: title, url: url)
        view?.moveWebview(with: presenter)
    }
    
    func appVersionButtonTapped() {
        let presenter = AppVersionViewPresenter(with: provider)
        view?.moveAppVersion(with: presenter)
    }
    
    func noticeButtonTapped() {
        let title = L10n.Localizable.Title.notice
        let url = MoonDuckAPI.baseUrl() + "/root/moonduck/notice.html"
        let presenter = WebViewPresenter(with: provider, title: title, url: url)
        view?.moveWebview(with: presenter)
    }
    
    func withdrawButtonTapped() {
        let presenter = WithdrawViewPresenter(with: provider, model: model)
        view?.moveWithdraw(with: presenter)
    }
    
    // MARK: - Logic
}
