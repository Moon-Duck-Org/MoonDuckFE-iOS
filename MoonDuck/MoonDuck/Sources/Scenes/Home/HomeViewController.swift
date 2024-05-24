//
//  HomeViewController.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import UIKit

protocol HomeView: AnyObject {
    
}

class HomeViewController: UIViewController, HomeView {

    @IBOutlet private weak var cvCategory: UICollectionView!
    @IBOutlet private weak var lbHistoryCount: UILabel!
    @IBOutlet private weak var lbSortTitle: UILabel!
    @IBOutlet private weak var tvBoardList: UITableView!
    
    let presenter: HomePresenter
    var navigator: Navigator!
    let cvDatasource: HomeCategoryCvDataSource
    let tvDatasource: HomeListTvDataSource
    
    init(navigator: Navigator,
         presenter: HomePresenter) {
        self.navigator = navigator
        self.presenter = presenter
        self.cvDatasource = HomeCategoryCvDataSource(presenter: presenter)
        self.tvDatasource = HomeListTvDataSource(presenter: presenter)
        super.init(nibName: HomeViewController.className, bundle: Bundle(for: HomeViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cvDatasource.configure(with: cvCategory)
        tvDatasource.configure(with: tvBoardList)
        presenter.view = self
    }
    
    func reloadData() {
        cvCategory.reloadData()
    }

}
