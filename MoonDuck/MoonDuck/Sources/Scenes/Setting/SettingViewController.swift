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
    func updatePushSwitchSetOn(_ isOn: Bool)
    func updatePushLabelText(isAddOsString: Bool)
        
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
    @IBOutlet private weak var pushLabel: UILabel!
    
    // @IBAction
    @IBAction private func backButtonTapped(_ sender: Any) {
        back()
    }
    @IBAction private func pushSwitchValueChanged(_ sender: UISwitch) {
        presenter.pushSwitchValueChanged(isOn: pushSwitch.isOn)
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
    @IBAction private func goReviewButtonTapped(_ sender: Any) {
        Utils.moveAppReviewInStore()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
}

// MARK: - UI Logic
extension SettingViewController {
    func updateAppVersionLabelText(with version: String) {
        appVersionLabel.text = version
    }
    
    func updatePushSwitchSetOn(_ isOn: Bool) {
        DispatchQueue.main.async {
            self.pushSwitch.setOn(isOn, animated: true)
        }
    }
    
    func updatePushLabelText(isAddOsString: Bool) {
        DispatchQueue.main.async {
            var fullText = L10n.Localizable.Push.settingText
            if isAddOsString {
                fullText += "\n" + L10n.Localizable.Push.settingTextOs
                let emphasizeTest = L10n.Localizable.Push.settingTextOsEmphasize
                let attributedString = NSMutableAttributedString(string: fullText)
                let emphasizeRange = (fullText as NSString).range(of: emphasizeTest)
                let emphasizeFont = FontFamily.NotoSansCJKKR.bold.font(size: self.pushLabel.font.pointSize)
                
                attributedString.addAttribute(.font, value: emphasizeFont, range: emphasizeRange)
                
                self.pushLabel.attributedText = attributedString
            } else {
                self.pushLabel.text = fullText
            }
        }
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
