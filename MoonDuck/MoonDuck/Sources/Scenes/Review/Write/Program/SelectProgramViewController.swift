//
//  SelectProgramViewController.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import UIKit

protocol SelectProgramView: AnyObject {
    // UI Logic
    func reloadCategories()
    func updateNextButton(_ isEnabled: Bool)
    
    // Navigation
    func moveProgramSearch(with presenter: ProgramSearchPresenter)
}

class SelectProgramViewController: BaseViewController, SelectProgramView {
    
    private let presenter: SelectProgramPresenter
    private let categoryDataSource: SelectCategoryDataSource
    
    // @IBOutlet
    @IBOutlet private weak var categoryCollectioinView: UICollectionView!
    @IBOutlet private weak var nextButton: RadiusButton!
    
    // @IBAction
    @IBAction private func cancelButtonTapped(_ sender: Any) {
        back()
    }
    
    @IBAction private func nextButtonTapped(_ sender: Any) {
        throttler.throttle {
            self.presenter.nextButtonTapped()
        }
    }
    
    init(navigator: Navigator,
         presenter: SelectProgramPresenter) {
        self.presenter = presenter
        self.categoryDataSource = SelectCategoryDataSource(presenter: self.presenter)
        super.init(navigator: navigator, nibName: SelectProgramViewController.className, bundle: Bundle(for: SelectProgramViewController.self))
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
    private func back() {
        navigator?.pop(sender: self, popType: .pop, animated: true)
    }
    
    func moveProgramSearch(with presenter: ProgramSearchPresenter) {
        navigator?.show(seque: .programSearch(presenter: presenter), sender: self, transition: .navigation, animated: true)
    }
}
