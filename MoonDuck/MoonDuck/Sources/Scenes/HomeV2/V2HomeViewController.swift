//
//  V2HomeViewController.swift
//  MoonDuck
//
//  Created by suni on 6/8/24.
//

import UIKit

protocol V2HomeView: AnyObject {
    func showToast(_ message: String)
    
    func moveMy(with presenter: MyViewPresenter)
}

class V2HomeViewController: UIViewController, V2HomeView, Navigatable {
    var navigator: Navigator!
    let presenter: V2HomePresenter
    
    // @IBOutlet
    
    // @IBAction
    @IBAction private func myButtonTap(_ sender: Any) {
        presenter.myButtonTap()
    }
    
    // datasource
    
    init(navigator: Navigator,
         presenter: V2HomePresenter) {
        self.navigator = navigator
        self.presenter = presenter
        super.init(nibName: V2HomeViewController.className, bundle: Bundle(for: V2HomeViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        
    }
}

// MARK: - UI Logic
extension V2HomeViewController {
    func showToast(_ message: String) {
        showToast(message: message)
    }
    
}

// MARK: - Navigation
extension V2HomeViewController {
    func moveMy(with presenter: MyViewPresenter) {
        navigator.show(seque: .my(presenter: presenter), sender: self, transition: .navigation)
    }
}
