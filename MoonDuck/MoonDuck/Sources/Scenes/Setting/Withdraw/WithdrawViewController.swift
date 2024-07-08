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
            title: "정말 탈퇴 하시겠어요?",
            cancelTitle: "취소",
            destructiveTitle: "탈퇴",
            destructiveHandler: { [weak self] in
                self?.presenter.withdrawButtonTapped()
        })
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
        AppAlert.default.showDone(self, message: "회원 탈퇴가 성공적으로 완료되었습니다. 문덕이를 이용해 주셔서 감사합니다.", doneHandler: { [weak self] in
            self?.navigator?.show(seque: .intro(presenter: presenter), sender: nil, transition: .root)
        })
    }
}
