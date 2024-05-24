//
//  HomeViewController.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import UIKit

protocol HomeView: AnyObject {
    func updateEmptyView(isEmpty: Bool)
    func updateCountLabel(_ cnt: Int)
}

class HomeViewController: UIViewController, HomeView, Navigatable {

    @IBOutlet private weak var categoryCollectionView: UICollectionView!
    @IBOutlet private weak var historyCountLabel: UILabel!
    @IBOutlet private weak var sortLabel: UILabel!
    @IBOutlet private weak var boardTableView: UITableView!
    @IBOutlet private weak var boardEmptyView: UIView!
    
    let presenter: HomePresenter
    var navigator: Navigator!
    let categoryDataSource: HomeCategoryCvDataSource
    let boardDataSource: BoardListTvDataSource
    
    init(navigator: Navigator,
         presenter: HomePresenter) {
        self.navigator = navigator
        self.presenter = presenter
        self.categoryDataSource = HomeCategoryCvDataSource(presenter: presenter)
        self.boardDataSource = BoardListTvDataSource(presenter: presenter)
        super.init(nibName: HomeViewController.className, bundle: Bundle(for: HomeViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.view = self
        
        categoryDataSource.configure(with: categoryCollectionView)
        boardDataSource.configure(with: boardTableView)
        
        categoryCollectionView.selectItem(at: IndexPath(row: presenter.selectedCategoryIndex, section: 0), animated: false, scrollPosition: .top)
    }
    
    func updateEmptyView(isEmpty: Bool) {
        boardEmptyView.isHidden = isEmpty
    }
    
    func updateCountLabel(_ cnt: Int) {
        historyCountLabel.text = "\(cnt)"
    }
}
