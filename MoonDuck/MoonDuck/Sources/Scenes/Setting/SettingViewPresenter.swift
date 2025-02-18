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
    
    override init(with provider: AppStorages,
         model: AppModels) {
        super.init(with: provider, model: model)
        self.model.userModel?.delegate = self
    }
    
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
//        let title = L10n.Localizable.Title.service
//        let url = Constants.termsOfServiceUrl
//        let presenter = WebViewPresenter(with: provider, title: title, url: url)
//        view?.moveWebview(with: presenter)
    }
    
    func privacyPolicyButtonTapped() {
//        let title = L10n.Localizable.Title.policy
//        let url = Constants.privacyPolicyUrl
//        let presenter = WebViewPresenter(with: provider, title: title, url: url)
//        view?.moveWebview(with: presenter)        
    }
    
    func appVersionButtonTapped() {
        let presenter = AppVersionViewPresenter(with: provider, model: AppModels())
        view?.moveAppVersion(with: presenter)
    }
    
    func noticeButtonTapped() {
//        let title = L10n.Localizable.Title.notice
//        let url = Constants.noticeUrl
//        let presenter = WebViewPresenter(with: provider, title: title, url: url)
//        view?.moveWebview(with: presenter)
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
        
        view?.updateLoadingView(isLoading: true)
        model.userModel?.setPush(isPush: isOn)
    }
    
    // MARK: - Logic
    private func checkPushStatus() {
        AppNotification.getNotificationSettingStatus { [weak self] status in
            guard let self else { return }
            
            if status == .authorized {
//                self.view?.updatePushSwitchSetOn(self.model.userModel?.user?.isPush ?? false)
                self.view?.updatePushLabelText(isAddOsString: false)
            } else {
                self.view?.updatePushSwitchSetOn(false)
                self.view?.updatePushLabelText(isAddOsString: true)
            }
        }
    }
}

// MARK: - UserModelDelegate
extension SettingViewPresenter: UserModelDelegate {
    
    func userModel(_ model: UserModelType, didChange user: User) {
        // Push 설정 성공
//        view?.updateLoadingView(isLoading: false)
//        
//        guard let user else { return }
//        delegate?.setting(self, didSuccess: user.isPush)
//        
//        let today = Utils.getToday()
//        if user.isPush {
//            AppNotification.resetAndScheduleNotification(with: user.nickname)
//            view?.showToastMessage(L10n.Localizable.Push.onCompleteToast(today))
//        } else {
//            AppNotification.removeNotification()
//            view?.showToastMessage(L10n.Localizable.Push.offCompleteToast(today))
//        }
    }
}
