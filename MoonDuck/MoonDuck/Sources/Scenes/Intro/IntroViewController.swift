//
//  IntroViewController.swift
//  MoonDuck
//
//  Created by suni on 5/22/24.
//

import UIKit

protocol IntroView: BaseView {
    // UI Logic
    func showForceUpdateAlert()
    func showLatestUpdateAlert()
    
    // Navigation
    func moveNameSetting(with presenter: NicknameSettingPresenter)
    func moveHome(with presenter: HomePresenter)
}

class IntroViewController: BaseViewController, IntroView {
    private let presenter: IntroPresenter
    
    init(navigator: Navigator,
         presenter: IntroPresenter) {
        self.presenter = presenter
        super.init(navigator: navigator, nibName: IntroViewController.className, bundle: Bundle(for: IntroViewController.self))
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
extension IntroViewController {
    func showForceUpdateAlert() {
        AppAlert.default.showDone(
            self,
            title: L10n.Localizable.Update.forceUpdateTitle,
            message: L10n.Localizable.Update.forceUpdateMessage,
            doneTitle: L10n.Localizable.Button.update,
            doneHandler: {
                Utils.moveAppStore()
            })
    }
    
    func showLatestUpdateAlert() {
        AppAlert.default.showCancelAndDone(
            self,
            title: L10n.Localizable.Update.latestUpdateTitle,
            message: L10n.Localizable.Update.latestUpdateMessage,
            cancelTitle: L10n.Localizable.Button.update,
            doneTitle: L10n.Localizable.Button.later,
            cancelHandler: { [weak self] in
                Utils.moveAppStore()
                self?.presenter.latestUpdateButtonTapped()
            },
            doneHandler: { [weak self] in
                self?.presenter.latestUpdateButtonTapped()
            })
    }
}

// MARK: - Navigation
extension IntroViewController {
    func moveNameSetting(with presenter: NicknameSettingPresenter) {
        navigator?.show(seque: .nameSetting(presenter: presenter), sender: nil, transition: .root, animated: false)
    }
    
    func moveHome(with presenter: HomePresenter) {
        navigator?.show(seque: .home(presenter: presenter), sender: nil, transition: .root, animated: false)
    }
}
