//
//  MyViewController.swift
//  MoonDuck
//
//  Created by suni on 6/8/24.
//

import UIKit

protocol MyView: AnyObject {
    func showToast(_ message: String)
    func updateCountLabel(movie: Int, book: Int, drama: Int, concert: Int)
    
    func moveLogin(with presenter: LoginViewPresenter)
}

class MyViewController: UIViewController, MyView, Navigatable {
    
    var navigator: Navigator!
    let presenter: MyPresenter
    
    // @IBOutlet
    @IBOutlet weak private var movieCountLabel: UILabel!
    @IBOutlet weak private var bookCountLabel: UILabel!
    @IBOutlet weak private var dramaCountLabel: UILabel!
    @IBOutlet weak private var concertCountLabel: UILabel!
    
    // @IBAction
    @IBAction private func backButtonTap(_ sender: Any) {
        back()
    }
    
    @IBAction private func settingButtonTap(_ sender: Any) {
        showToast("설정 화면 이동 예정")
    }
    
    @IBAction private func settingNameButtonTap(_ sender: Any) {
        showToast("닉네임 설정 화면 이동 예정")
    }
    
    @IBAction func logoutButtonTap(_ sender: Any) {
        showToast("로그아웃 개발 예정")
    }
        
    init(navigator: Navigator,
         presenter: MyPresenter) {
        self.navigator = navigator
        self.presenter = presenter
        super.init(nibName: MyViewController.className, bundle: Bundle(for: MyViewController.self))
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
extension MyViewController {
    func showToast(_ message: String) {
        showToast(message: message)
    }
    
    func updateCountLabel(movie: Int, book: Int, drama: Int, concert: Int) {
        self.movieCountLabel.text = "\(movie)"
        self.bookCountLabel.text = "\(movie)"
        self.dramaCountLabel.text = "\(movie)"
        self.concertCountLabel.text = "\(concert)"
    }
}

// MARK: - Navigation
extension MyViewController {
    private func back() {
        navigator.pop(sender: self)
    }
    
    func moveLogin(with presenter: LoginViewPresenter) {
        navigator.show(seque: .login(presenter: presenter), sender: nil, transition: .root)
    }
}
