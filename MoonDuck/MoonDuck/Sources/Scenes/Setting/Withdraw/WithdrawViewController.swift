//
//  WithdrawViewController.swift
//  MoonDuck
//
//  Created by suni on 7/4/24.
//

import UIKit

protocol WithdrawView: BaseView {
    // UI Logic
    func updateContentLabel(with text: String)
        
    // Navigation
    func moveIntro(with presenter: IntroPresenter)
}

class WithdrawViewController: BaseViewController, WithdrawView, Navigatable {
    var navigator: Navigator?
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
    
    }
    
    init(navigator: Navigator,
         presenter: WithdrawPresenter) {
        self.navigator = navigator
        self.presenter = presenter
        super.init(nibName: WithdrawViewController.className, bundle: Bundle(for: WithdrawViewController.self))
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
    func updateContentLabel(with text: String) {
        contentLabel?.text = text
    }
}

// MARK: - Navigation
extension WithdrawViewController {
    private func back() {
        navigator?.pop(sender: self, animated: true)
    }
    
    func moveIntro(with presenter: IntroPresenter) {
        
    }
}
