//
//  V2HomeViewController.swift
//  MoonDuck
//
//  Created by suni on 6/8/24.
//

import UIKit

protocol V2HomeView: BaseView {
    // UI Logic
    func reloadCategories()
    func reloadReviews()
    func updateReviewCount(_ count: String)
    func updateEmptyReviewsView(_ isEmpty: Bool)
    func scrollToTopReviews()
    
    // Navigation
    func moveMy(with presenter: MyInfoPresenter)
    func moveSelectProgram(with presenter: SelectProgramPresenter)
    func popToSelf()
}

class V2HomeViewController: BaseViewController, V2HomeView, Navigatable {
    var navigator: Navigator?
    let presenter: V2HomePresenter
    private let categoryDataSource: HomeCategoryDataSource
    private let reviewDataSource: HomeReviewDataSource
    
    // @IBOutlet
    @IBOutlet weak private var categoryCollectioinView: UICollectionView!
    @IBOutlet weak private var reviewCountLabel: UILabel!
    @IBOutlet weak private var reviewTableView: UITableView!
    @IBOutlet weak private var emptyReviewsView: UIView!
    
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
        self.categoryDataSource = HomeCategoryDataSource(presenter: self.presenter)
        self.reviewDataSource = HomeReviewDataSource(presenter: self.presenter)
        super.init(nibName: V2HomeViewController.className, bundle: Bundle(for: V2HomeViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.viewDidLoad()
        
        categoryDataSource.configure(with: categoryCollectioinView)
        reviewDataSource.configure(with: reviewTableView)
    }
}

// MARK: - UI Logic
extension V2HomeViewController {
    func reloadCategories() {
        categoryCollectioinView.reloadData()
    }
    
    func reloadReviews() {
        reviewTableView.reloadData()
    }
    
    func updateReviewCount(_ count: String) {
        reviewCountLabel.text = count
    }
    
    func updateEmptyReviewsView(_ isEmpty: Bool) {
        emptyReviewsView.isHidden = !isEmpty
    }

    func scrollToTopReviews() {
        DispatchQueue.main.async {
            self.reviewTableView.setContentOffset(CGPoint(x: 0, y: -self.reviewTableView.contentInset.top), animated: true)
        }
    }
}

// MARK: - Navigation
extension V2HomeViewController {
    func moveMy(with presenter: MyInfoPresenter) {
        navigator?.show(seque: .myInfo(presenter: presenter), sender: self, transition: .navigation, animated: true)
    }
    
    func moveSelectProgram(with presenter: SelectProgramPresenter) {
        navigator?.show(seque: .selectProgram(presenter: presenter), sender: self, transition: .navigation, animated: true)
    }
    
    func popToSelf() {
        navigator?.pop(sender: self, popType: .popToSelf, animated: true)
    }
}
