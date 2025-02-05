//
//  AppVersionViewController.swift
//  MoonDuck
//
//  Created by suni on 7/4/24.
//

import UIKit

protocol AppVersionView: BaseView {
    // UI Logic
    func updateLabelsText(versionInfo: String, updateInfo: String)
    func updateUpdateButtonHidden(_ isHidden: Bool)
        
    // Navigation
}

class AppVersionViewController: BaseViewController, AppVersionView {
    private let presenter: AppVersionPresenter
    
    // @IBOutlet
    @IBOutlet private weak var versionLabel: UILabel!
    @IBOutlet private weak var updateLabel: UILabel!
    @IBOutlet private weak var updateButtonView: RadiusView!
    
    // @IBAction
    @IBAction private func backButtonTapped(_ sender: Any) {
        back()
    }
    @IBAction private func updateButtonTapped(_ sender: Any) {
        presenter.updateButtonTapped()
    }
    
    init(navigator: Navigator,
         presenter: AppVersionPresenter) {
        self.presenter = presenter
        super.init(navigator: navigator, nibName: AppVersionViewController.className, bundle: Bundle(for: AppVersionViewController.self))
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
extension AppVersionViewController {
    func updateLabelsText(versionInfo: String, updateInfo: String) {
        versionLabel.text = versionInfo
        updateLabel.text = updateInfo
    }
    
    func updateUpdateButtonHidden(_ isHidden: Bool) {
        updateButtonView.isHidden = isHidden
    }
}

// MARK: - Navigation
extension AppVersionViewController {
    private func back() {
        navigator?.pop(sender: self, animated: true)
    }
}
