//
//  SettingViewController.swift
//  MoonDuck
//
//  Created by suni on 7/2/24.
//

import UIKit

protocol SettingView: BaseView {
    // UI Logic
    
    
    // Navigation
    func moveWebview(with presenter: WebPresenter)
    
}

class SettingViewController: BaseViewController, SettingView, Navigatable {
    
    var navigator: Navigator?
    let presenter: SettingPresenter
    
    // @IBOutlet
    
    // @IBAction
    @IBAction private func termsOfServiceButtonTapped(_ sender: Any) {
        
    }
    
    init(navigator: Navigator,
         presenter: SettingPresenter) {
        self.navigator = navigator
        self.presenter = presenter
        super.init(nibName: SettingViewController.className, bundle: Bundle(for: SettingViewController.self))
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
    
}

// MARK: - Navigation
extension SettingViewController {
    private func back() {
        navigator?.pop(sender: self)
    }
    
    func moveWebview(with presenter: WebPresenter) {
        navigator?.show(seque: .webview(presenter: presenter), sender: self, transition: .navigation, animated: true)
    }
}
