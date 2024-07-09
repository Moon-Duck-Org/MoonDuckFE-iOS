//
//  WithdrawViewController.swift
//  MoonDuck
//
//  Created by suni on 7/4/24.
//

import UIKit

protocol WithdrawView: BaseView {
    // UI Logic
    func updateContentLabelText(with text: String)
        
    // Navigation
    func showComplteWithDrawAlert(with presenter: IntroPresenter)
}

class WithdrawViewController: BaseViewController, WithdrawView {
    private let presenter: WithdrawPresenter
    
    // @IBOutlet
    @IBOutlet private weak var contentLabel: UILabel!
    
    // @IBAction
    @IBAction private func backButtonTapped(_ sender: Any) {
        back()
    }
    @IBAction private func cancelButtonTapped(_ sender: Any) {
        back()
    }
    @IBAction private func withdrawButtonTapped(_ sender: Any) {
        AppAlert.default.showDestructive(
            self,
            title: L10n.Localizable.My.withdrawAlertMessage,
            cancelTitle: L10n.Localizable.Button.cancel,
            destructiveTitle: L10n.Localizable.Button.withdraw,
            destructiveHandler: { [weak self] in
                self?.presenter.withdrawButtonTapped()
            }
        )
    }
    
    init(navigator: Navigator,
         presenter: WithdrawPresenter) {
        self.presenter = presenter
        super.init(navigator: navigator, nibName: WithdrawViewController.className, bundle: Bundle(for: WithdrawViewController.self))
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
extension WithdrawViewController {
    func updateContentLabelText(with text: String) {
        contentLabel?.text = text
    }
    
    func showMoveLoginAlert(_ message: String) {
        
    }
}

// MARK: - Navigation
extension WithdrawViewController {
    private func back() {
        navigator?.pop(sender: self, animated: true)
    }
    
    func showComplteWithDrawAlert(with presenter: IntroPresenter) {
        AppAlert.default.showDone(self, message: L10n.Localizable.My.withdrawCompleteMessage, doneHandler: { [weak self] in
            self?.navigator?.show(seque: .intro(presenter: presenter), sender: nil, transition: .root)
        })
    }
}
