//
//  WriteReviewCategoryViewController.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import UIKit

protocol WriteReviewCategoryView: AnyObject {
    func reloadCategories()
    func updateNextButton(_ isEnabled: Bool)
    
//    func moveCategorySearch(with presenter: CategorySearchViewPresenter)
}

class WriteReviewCategoryViewController: BaseViewController, WriteReviewCategoryView, Navigatable {
    
    var navigator: Navigator!
    let presenter: WriteReviewCategoryPresenter
    private let categoryDataSource: WriteReviewCategoryDataSource
    
    // @IBOutlet
    @IBOutlet weak private var categoryCollectioinView: UICollectionView!
    @IBOutlet weak private var nextButton: RadiusButton!
    
    // @IBAction
    @IBAction private func cancelButtonTap(_ sender: Any) {
        back()
    }
    
    @IBAction private func nextButtonTap(_ sender: Any) {
        presenter.tapNextButton()
    }
    
    init(navigator: Navigator,
         presenter: WriteReviewCategoryPresenter) {
        self.navigator = navigator
        self.presenter = presenter
        self.categoryDataSource = WriteReviewCategoryDataSource(presenter: self.presenter)
        super.init(nibName: WriteReviewCategoryViewController.className, bundle: Bundle(for: WriteReviewCategoryViewController.self))
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
extension WriteReviewCategoryViewController {
    func reloadCategories() {
        categoryCollectioinView.reloadData()
    }
    
    func updateNextButton(_ isEnabled: Bool) {
        nextButton.isEnabled = isEnabled
    }
    
}

// MARK: - Navigation
extension WriteReviewCategoryViewController {
    private func back() {
        navigator?.pop(sender: self)
    }
}
