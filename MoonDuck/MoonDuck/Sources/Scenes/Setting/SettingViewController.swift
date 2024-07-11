//
//  SettingViewController.swift
//  MoonDuck
//
//  Created by suni on 7/2/24.
//

import UIKit

import MessageUI

protocol SettingView: BaseView {
    // UI Logic
    func updateAppVersionLabelText(with version: String)
    func updatePushSwitchValue(isOn: Bool)
        
    // Navigation
    func moveWebview(with presenter: WebPresenter)
    func moveWithdraw(with presenter: WithdrawPresenter)
    func moveAppVersion(with presenter: AppVersionPresenter)
}

class SettingViewController: BaseViewController, SettingView {
    private let presenter: SettingPresenter
    
    // @IBOutlet
    @IBOutlet private weak var appVersionLabel: UILabel!
    @IBOutlet private weak var pushSwitch: UISwitch!
    
    // @IBAction
    @IBAction private func backButtonTapped(_ sender: Any) {
        back()
    }
    @IBAction private func pushSwitchValueChanged(_ sender: UISwitch) {
        
    }
    @IBAction private func termsOfServiceButtonTapped(_ sender: Any) {
        presenter.termsOfServiceButtonTapped()
        
    }
    @IBAction private func privacyPolicyButtonTapped(_ sender: Any) {
        presenter.privacyPolicyButtonTapped()
        
    }
    @IBAction private func contactUsButtonTapped(_ sender: Any) {
        showContractUsMail()
    }
    @IBAction private func appVersionButtonTapped(_ sender: Any) {
        presenter.appVersionButtonTapped()
    }
    @IBAction private func noticeButtonTapped(_ sender: Any) {
        presenter.noticeButtonTapped()
    }
    @IBAction private func withdrawButtonTapped(_ sender: Any) {
        presenter.withdrawButtonTapped()
    }
    
    init(navigator: Navigator,
         presenter: SettingPresenter) {
        self.presenter = presenter
        super.init(navigator: navigator, nibName: SettingViewController.className, bundle: Bundle(for: SettingViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.viewDidLoad()
    }
}

// MARK: - UI Logic
extension SettingViewController {
    func updateAppVersionLabelText(with version: String) {
        appVersionLabel.text = version
    }
    
    func updatePushSwitchValue(isOn: Bool) {
        pushSwitch.isOn = isOn
    }
    
    private func showContractUsMail() {
        let mail = presenter.contractUs.mail
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients([mail])
            mailComposeVC.setSubject(presenter.contractUs.subject)
            mailComposeVC.setMessageBody(presenter.contractUs.getBody(), isHTML: false)
            
            self.present(mailComposeVC, animated: true, completion: nil)
        } else {
            // 메일을 보낼 수 없는 경우 경고 표시
            showErrorAlert(
                title: L10n.Localizable.ContractUs.notAvailableMailTitle,
                message: L10n.Localizable.ContractUs.notAvailableMailMessage(mail)
            )
        }
    }
}

// MARK: - Navigation
extension SettingViewController {
    private func back() {
        navigator?.pop(sender: self, animated: true)
    }
    
    func moveWebview(with presenter: WebPresenter) {
        navigator?.show(seque: .webview(presenter: presenter), sender: self, transition: .navigation, animated: true)
    }
    
    func moveWithdraw(with presenter: WithdrawPresenter) {
        navigator?.show(seque: .withdraw(presenter: presenter), sender: self, transition: .navigation, animated: true)
    }
    
    func moveAppVersion(with presenter: AppVersionPresenter) {
        navigator?.show(seque: .appVersion(presenter: presenter), sender: self, transition: .navigation, animated: true)
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
        switch result {
        case .cancelled:
            Log.debug("Mail cancelled")
        case .saved:
            Log.debug("Mail saved")
        case .sent:
            showToastMessage(L10n.Localizable.ContractUs.completeMessage)
        case .failed:
            showToastMessage(L10n.Localizable.ContractUs.errorMessage)
        @unknown default:
            showToastMessage(L10n.Localizable.ContractUs.errorMessage)
        }
    }
}
