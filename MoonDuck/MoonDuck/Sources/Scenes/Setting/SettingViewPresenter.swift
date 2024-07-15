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
    func viewWillAppear()
    
    // Action
    func termsOfServiceButtonTapped()
    func privacyPolicyButtonTapped()
    func appVersionButtonTapped()
    func noticeButtonTapped()
    func withdrawButtonTapped()
    func pushSwitchValueChanged(isOn: Bool)
    
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
        return ContractUs(nickName: nickname)
    }
    
}

extension SettingViewPrsenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        view?.updateAppVersionLabelText(with: Utils.appVersion ?? "")
    }
    
    func viewWillAppear() {
        checkPushStatus()
    }
    
    // MARK: - Action
    func termsOfServiceButtonTapped() {
        let title = L10n.Localizable.Title.service
        let url = MoonDuckAPI.baseUrl() + "/contract.html"
        let presenter = WebViewPresenter(with: provider, title: title, url: url)
        view?.moveWebview(with: presenter)
    }
    
    func privacyPolicyButtonTapped() {
        let title = L10n.Localizable.Title.policy
        let url = MoonDuckAPI.baseUrl() + "/privacy.html"
        let presenter = WebViewPresenter(with: provider, title: title, url: url)
        view?.moveWebview(with: presenter)
    }
    
    func appVersionButtonTapped() {
        let presenter = AppVersionViewPresenter(with: provider)
        view?.moveAppVersion(with: presenter)
    }
    
    func noticeButtonTapped() {
        let title = L10n.Localizable.Title.notice
        let url = MoonDuckAPI.baseUrl() + "/notice.html"
        let presenter = WebViewPresenter(with: provider, title: title, url: url)
        view?.moveWebview(with: presenter)
    }
    
    func withdrawButtonTapped() {
        let presenter = WithdrawViewPresenter(with: provider, model: model)
        view?.moveWithdraw(with: presenter)
    }
    
    func pushSwitchValueChanged(isOn: Bool) {
        AppNotification.getNotificationSettingStatus { [weak self] status in
            guard let self else { return }
            
            if status == .authorized {
                self.setPushStatus(isOn: isOn)
            } else {
                Utils.moveAppSetting()
                self.view?.updatePushSwitchSetOn(false)
            }
        }
    }
    
    private func setPushStatus(isOn: Bool) {
        guard let user = model.user else { return }
        if user.isPush == isOn {
            return
        }
        
        let today = Utils.getToday()
        if isOn {
            AppNotification.resetAndScheduleNotification(with: user.nickname)
            view?.showToastMessage(L10n.Localizable.Push.onCompleteToast(today))
        } else {
            AppNotification.removeNotification()
            view?.showToastMessage(L10n.Localizable.Push.offCompleteToast(today))
        }
        
    }
    
    // MARK: - Logic
    private func checkPushStatus() {
        AppNotification.getNotificationSettingStatus { [weak self] status in
            guard let self else { return }
            
            if status == .authorized {
                self.view?.updatePushSwitchSetOn(self.model.user?.isPush ?? false)
                self.view?.updatePushLabelText(isAddOsString: false)
            } else {
                self.view?.updatePushSwitchSetOn(false)
                self.view?.updatePushLabelText(isAddOsString: true)
            }
        }
    }
}
