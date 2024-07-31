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
    func updateSnsLogin(with type: SnsLoginType)
    
    // Navigation
    func dismiss()
    func presentNameSetting(with presenter: NicknameSettingPresenter)
    func moveSetting(with presenter: SettingPresenter)
}

class MyInfoViewController: BaseViewController, MyInfoView {
    
    private let presenter: MyInfoPresenter
    
    // @IBOutlet
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var allCountLabel: UILabel!
    @IBOutlet private weak var movieCountLabel: UILabel!
    @IBOutlet private weak var bookCountLabel: UILabel!
    @IBOutlet private weak var dramaCountLabel: UILabel!
    @IBOutlet private weak var concertCountLabel: UILabel!
    @IBOutlet private weak var snsLoginImageView: UIImageView!
    @IBOutlet private weak var snsLoginLabel: UILabel!
    
    // @IBAction
    @IBAction private func backButtonTapped(_ sender: Any) {
        back()
    }
    
    @IBAction private func settingButtonTapped(_ sender: Any) {
        throttler.throttle {
            self.presenter.settingButtonTapped()
        }
    }
    
    @IBAction private func nicknameSettingButtonTapped(_ sender: Any) {
        throttler.throttle {
            self.presenter.nicknameSettingButtonTapped()
        }
    }
    
    @IBAction private func logoutButtonTapped(_ sender: Any) {
        AppAlert.default
            .showDestructive(self,
                             title: L10n.Localizable.My.logoutAlertMessage,
                             destructiveTitle: L10n.Localizable.Button.logout,
                             destructiveHandler: { [weak self] in
                self?.presenter.logoutButtonTapped()
            })
    }
    
    init(navigator: Navigator,
         presenter: MyInfoPresenter) {
        self.presenter = presenter
        super.init(navigator: navigator, nibName: MyInfoViewController.className, bundle: Bundle(for: MyInfoViewController.self))
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
    
    func updateSnsLogin(with type: SnsLoginType) {
        snsLoginLabel.text = "\(type.title) 간편 로그인"
        snsLoginImageView.image = type.smallImage
    }
}

// MARK: - Navigation
extension MyInfoViewController {
    private func back() {
        navigator?.pop(sender: self, animated: true)
    }
    
    func dismiss() {
        navigator?.dismiss(sender: self, animated: true)
    }
    
    func presentNameSetting(with presenter: NicknameSettingPresenter) {
        navigator?.show(seque: .nameSetting(presenter: presenter), sender: self, transition: .modal, animated: true)
    }
    
    func moveSetting(with presenter: SettingPresenter) {
        navigator?.show(seque: .setting(presenter: presenter), sender: self, transition: .navigation, animated: true)
    }
}
