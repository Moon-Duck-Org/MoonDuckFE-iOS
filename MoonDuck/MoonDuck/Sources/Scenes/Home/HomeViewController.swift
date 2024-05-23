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

    @IBOutlet private(set) weak var cvCategory: UICollectionView!
    
    let presenter: HomePresenter
    var navigator: Navigator!
    let dataSource: HomeViewDataSource
    
    init(navigator: Navigator,
         presenter: HomePresenter) {
        self.navigator = navigator
        self.presenter = presenter
        self.dataSource = HomeViewDataSource(presenter: presenter)
        super.init(nibName: HomeViewController.className, bundle: Bundle(for: HomeViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.configure(with: cvCategory)
        presenter.view = self
    }

}
