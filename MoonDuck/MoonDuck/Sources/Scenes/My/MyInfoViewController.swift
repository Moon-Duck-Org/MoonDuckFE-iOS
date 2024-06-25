//
//  MyInfoViewController.swift
//  MoonDuck
//
//  Created by suni on 6/8/24.
//

import UIKit

protocol MyInfoView: BaseView {
    // UI Logic
    func updateNameLabel(_ text: String)
    func updateCountLabel(movie: Int, book: Int, drama: Int, concert: Int)
    
    // Navigation
    func dismiss()
    func presentNameSetting(with presenter: NicknameSettingPresenter)
    func moveLogin(with presenter: LoginPresenter)
}

class MyInfoViewController: BaseViewController, MyInfoView, Navigatable {
    
    var navigator: Navigator?
    let presenter: MyInfoPresenter
    
    // @IBOutlet
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var movieCountLabel: UILabel!
    @IBOutlet weak private var bookCountLabel: UILabel!
    @IBOutlet weak private var dramaCountLabel: UILabel!
    @IBOutlet weak private var concertCountLabel: UILabel!
    
    // @IBAction
    @IBAction private func tapBackButton(_ sender: Any) {
        back()
    }
    
    @IBAction private func tapSettingButton(_ sender: Any) {
        showToast("설정 화면 이동 예정")
    }
    
    @IBAction private func tapNicknameSettingButton(_ sender: Any) {
        presenter.tapNicknameSettingButton()
    }
    
    @IBAction private func tapLogoutButton(_ sender: Any) {
        AppAlert.default.logout(self, logoutHandler: {
            self.presenter.tapLogoutButton()
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
    func updateNameLabel(_ text: String) {
        nameLabel.text = text
    }
    
    func updateCountLabel(movie: Int, book: Int, drama: Int, concert: Int) {
        self.movieCountLabel.text = "\(movie)"
        self.bookCountLabel.text = "\(movie)"
        self.dramaCountLabel.text = "\(movie)"
        self.concertCountLabel.text = "\(concert)"
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
}
