//
//  WriteReviewCategoryViewController.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import UIKit

protocol WriteReviewCategoryView: AnyObject {
    func reloadCategories()
}

class WriteReviewCategoryViewController: UIViewController, WriteReviewCategoryView, Navigatable {
    
    var navigator: Navigator!
    let presenter: WriteReviewCategoryPresenter
    private let categoryDataSource: WriteReviewCategoryDataSource
    
    // @IBOutlet
    @IBOutlet weak private var categoryCollectioinView: UICollectionView!
    
    // @IBAction
    @IBAction private func cancelButtonTap(_ sender: Any) {
        back()
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
    func showToast(_ message: String) {
        showToast(message: message)
    }
    
    func reloadCategories() {
        categoryCollectioinView.reloadData()
    }
    
}

// MARK: - Navigation
extension WriteReviewCategoryViewController {
    func back() {
        navigator?.pop(sender: self)
    }
}
