//
//  SelectProgramViewController.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import UIKit

protocol SelectProgramView: AnyObject {
    func reloadCategories()
    func updateNextButton(_ isEnabled: Bool)
    
    func moveCategorySearch(with presenter: ProgramSearchPresenter)
}

class SelectProgramViewController: BaseViewController, SelectProgramView, Navigatable {
    
    var navigator: Navigator?
    let presenter: SelectProgramPresenter
    private let categoryDataSource: SelectCategoryDataSource
    
    // @IBOutlet
    @IBOutlet weak private var categoryCollectioinView: UICollectionView!
    @IBOutlet weak private var nextButton: RadiusButton!
    
    // @IBAction
    @IBAction private func tapCancelButton(_ sender: Any) {
        presenter.tapCancelButton()
    }
    
    @IBAction private func tapNextButton(_ sender: Any) {
        presenter.tapNextButton()
    }
    
    init(navigator: Navigator,
         presenter: SelectProgramPresenter) {
        self.navigator = navigator
        self.presenter = presenter
        self.categoryDataSource = SelectCategoryDataSource(presenter: self.presenter)
        super.init(nibName: SelectProgramViewController.className, bundle: Bundle(for: SelectProgramViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.viewDidLoad()
        
        categoryDataSource.configure(with: categoryCollectioinView)
    }
}

// MARK: - UI Logic
extension SelectProgramViewController {
    func reloadCategories() {
        categoryCollectioinView.reloadData()
    }
    
    func updateNextButton(_ isEnabled: Bool) {
        nextButton.isEnabled = isEnabled
    }
    
}

// MARK: - Navigation
extension SelectProgramViewController {
    func moveCategorySearch(with presenter: ProgramSearchPresenter) {
        navigator?.show(seque: .programSearch(presenter: presenter), sender: self, transition: .navigation)
    }
}
