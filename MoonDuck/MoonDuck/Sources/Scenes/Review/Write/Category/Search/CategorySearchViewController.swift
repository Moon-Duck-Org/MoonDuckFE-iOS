//
//  CategorySearchViewController.swift
//  MoonDuck
//
//  Created by suni on 6/10/24.
//

import UIKit

protocol CategorySearchView: BaseView {
    
}

class CategorySearchViewController: BaseViewController, CategorySearchView, Navigatable {
    
    var navigator: Navigator!
    let presenter: CategorySearchPresenter
    
    // @IBOutlet
    
    // @IBAction
    @IBAction func backButtonTap(_ sender: Any) {
        back()
    }
    
    init(navigator: Navigator,
         presenter: CategorySearchPresenter) {
        self.navigator = navigator
        self.presenter = presenter
        super.init(nibName: CategorySearchViewController.className, bundle: Bundle(for: CategorySearchViewController.self))
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
extension CategorySearchViewController {
    
}

// MARK: - Navigation
extension CategorySearchViewController {
    private func back() {
        navigator?.pop(sender: self)
    }
}
