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
        
    // Navigation
    func moveWebview(with presenter: WebPresenter)
    func moveWithdraw(with presenter: WithdrawPresenter)
    func moveAppVersion(with presenter: AppVersionPresenter)
}

class SettingViewController: BaseViewController, SettingView {
    private let presenter: SettingPresenter
    
    // @IBOutlet
    @IBOutlet private weak var appVersionLabel: UILabel!
    
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
    
    private func showContractUsMail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients([presenter.contractUs.mail])
            mailComposeVC.setSubject(presenter.contractUs.subject)
            mailComposeVC.setMessageBody(presenter.contractUs.getBody(), isHTML: false)
            
            self.present(mailComposeVC, animated: true, completion: nil)
        } else {
            // 메일을 보낼 수 없는 경우 경고 표시
            let alert = UIAlertController(title: "Error", message: "Mail services are not available", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
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
            Log.debug("Mail sent")
        case .failed:
            Log.debug("Mail sent failure: \(String(describing: error?.localizedDescription))")
        @unknown default:
            Log.error("Mail Error")
        }
    }
}
