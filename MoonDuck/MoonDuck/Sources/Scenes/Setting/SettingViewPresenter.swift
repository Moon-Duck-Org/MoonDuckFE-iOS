//
//  SettingViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 7/3/24.
//

import Foundation

protocol SettingPresenterDelegate: AnyObject {
    func setting(_ presenter: SettingPresenter, didSuccess isPush: Bool)
}

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

class SettingViewPresenter: BaseViewPresenter, SettingPresenter {
    weak var view: SettingView?
    private weak var delegate: SettingPresenterDelegate?
    
    // MARK: - Data
    var contractUs: ContractUs {
        let nickname = model.userModel?.nickname ?? ""
        return ContractUs(nickName: nickname)
    }
    
}

extension SettingViewPresenter {
    
    // MARK: - Life Cycle
    func viewDidLoad() {
        AnalyticsService.shared.logEvent(.VIEW_SETTING)
        view?.updateAppVersionLabelText(with: Constants.appVersion)
    }
    
    func viewWillAppear() {
        checkPushStatus()
    }
    
    // MARK: - Action
    func termsOfServiceButtonTapped() {
        let title = L10n.Localizable.Title.service
        if let path = Constants.termsOfServicePath {
            let presenter = WebViewPresenter(with: provider, title: title, path: path)
            view?.moveWebview(with: presenter)
        }
    }
    
    func privacyPolicyButtonTapped() {
        let title = L10n.Localizable.Title.policy
        if let path = Constants.privacyPolicyPath {
            let presenter = WebViewPresenter(with: provider, title: title, path: path)
            view?.moveWebview(with: presenter)
        }
    }
    
    func appVersionButtonTapped() {
        let presenter = AppVersionViewPresenter(with: provider, model: AppModels())
        view?.moveAppVersion(with: presenter)
    }
    
    func noticeButtonTapped() {
        let title = L10n.Localizable.Title.notice
        if let path = Constants.noticePath {
            let presenter = WebViewPresenter(with: provider, title: title, path: path)
            view?.moveWebview(with: presenter)
        }
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
        guard let user = model.userModel, user.isPush != isOn else { return }
        
        AnalyticsService.shared.logEvent(isOn ? .TAP_SETTING_PUSH_ON : .TAP_SETTING_PUSH_OFF)
        
        model.userModel?.setPush(isPush: isOn)
        notificationSetting(isPush: isOn)
    }
    
    // MARK: - Logic
    private func checkPushStatus() {
        AppNotification.getNotificationSettingStatus { [weak self] status in
            guard let self else { return }
            
            if status == .authorized {
                self.view?.updatePushSwitchSetOn(self.model.userModel?.isPush ?? false)
                self.view?.updatePushLabelText(isAddOsString: false)
            } else {
                self.view?.updatePushSwitchSetOn(false)
                self.view?.updatePushLabelText(isAddOsString: true)
            }
        }
    }
    
    private func notificationSetting(isPush: Bool) {
        let nickname = model.userModel?.nickname ?? "사용자"
        
        let today = Utils.getToday()
        if isPush {
            AppNotification.resetAndScheduleNotification(with: nickname)
            view?.showToastMessage(L10n.Localizable.Push.onCompleteToast(today))
        } else {
            AppNotification.removeNotification()
            view?.showToastMessage(L10n.Localizable.Push.offCompleteToast(today))
        }
    }
}
