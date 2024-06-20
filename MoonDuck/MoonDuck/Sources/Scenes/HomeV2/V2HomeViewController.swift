//
//  V2HomeViewController.swift
//  MoonDuck
//
//  Created by suni on 6/8/24.
//

import UIKit

protocol V2HomeView: BaseView {
    func moveMy(with presenter: MyInfoPresenter)
    func moveSelectCategory(with presenter: SelectProgramPresenter)
}

class V2HomeViewController: BaseViewController, V2HomeView, Navigatable {
    var navigator: Navigator?
    let presenter: V2HomePresenter
    
    // @IBOutlet
    
    // @IBAction
    @IBAction private func tapMyButton(_ sender: Any) {
        presenter.tapMyButton()
    }
    @IBAction private func tapWriteNewReviewButton(_ sender: Any) {
        presenter.tapWriteNewReviewButton()
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
    
}

// MARK: - Navigation
extension V2HomeViewController {
    func moveMy(with presenter: MyInfoPresenter) {
        navigator?.show(seque: .myInfo(presenter: presenter), sender: self, transition: .navigation, animated: true)
    }
    
    func moveSelectCategory(with presenter: SelectProgramPresenter) {
        navigator?.show(seque: .selectProgram(presenter: presenter), sender: self, transition: .navigation, animated: true)
    }
}
