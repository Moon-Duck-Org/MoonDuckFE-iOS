//
//  MyInfoViewController.swift
//  MoonDuck
//
//  Created by suni on 6/8/24.
//

import UIKit

protocol MyInfoView: BaseView {
    // UI Logic
    func updateNameLabelText(with text: String)
    func updateCountLabels(with all: Int, movie: Int, book: Int, drama: Int, concert: Int)
    
    // Navigation
    func dismiss()
    func presentNameSetting(with presenter: NicknameSettingPresenter)
    func moveLogin(with presenter: LoginPresenter)
    func moveSetting(with presenter: SettingPresenter)
}

class MyInfoViewController: BaseViewController, MyInfoView, Navigatable {
    
    var navigator: Navigator?
    let presenter: MyInfoPresenter
    
    // @IBOutlet
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var allCountLabel: UILabel!
    @IBOutlet private weak var movieCountLabel: UILabel!
    @IBOutlet private weak var bookCountLabel: UILabel!
    @IBOutlet private weak var dramaCountLabel: UILabel!
    @IBOutlet private weak var concertCountLabel: UILabel!
    
    // @IBAction
    @IBAction private func backButtonTapped(_ sender: Any) {
        back()
    }
    
    @IBAction private func settingButtonTapped(_ sender: Any) {
        presenter.settingButtonTapped()
    }
    
    @IBAction private func nicknameSettingButtonTapped(_ sender: Any) {
        presenter.nicknameSettingButtonTapped()
    }
    
    @IBAction private func logoutButtonTapped(_ sender: Any) {
        AppAlert.default
            .showDestructive(self,
                             title: L10n.Localizable.wouldYouLikeToLogOut,
                             destructiveTitle: L10n.Localizable.logout,
                             destructiveHandler: { [weak self] in
                self?.presenter.logoutButtonTapped()
            })
    }
        
    init(navigator: Navigator,
         presenter: MyInfoPresenter) {
        self.navigator = navigator
        self.presenter = presenter
        super.init(nibName: MyInfoViewController.className, bundle: Bundle(for: MyInfoViewController.self))
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
extension MyInfoViewController {
    func updateNameLabelText(with text: String) {
        nameLabel.text = text
    }
    
    func updateCountLabels(with all: Int, movie: Int, book: Int, drama: Int, concert: Int) {
        allCountLabel.text = "\(all)"
        movieCountLabel.text = "\(movie)"
        bookCountLabel.text = "\(book)"
        dramaCountLabel.text = "\(drama)"
        concertCountLabel.text = "\(concert)"
    }
}

// MARK: - Navigation
extension MyInfoViewController {
    private func back() {
        navigator?.pop(sender: self)
    }
    
    func dismiss() {
        navigator?.dismiss(sender: self)
    }
    
    func presentNameSetting(with presenter: NicknameSettingPresenter) {
        navigator?.show(seque: .nameSetting(presenter: presenter), sender: self, transition: .modal)
    }
    
    func moveLogin(with presenter: LoginPresenter) {
        navigator?.show(seque: .login(presenter: presenter), sender: nil, transition: .root)
    }
    
    func moveSetting(with presenter: SettingPresenter) {
        navigator?.show(seque: .setting(presenter: presenter), sender: self, transition: .navigation, animated: true)
    }
}
