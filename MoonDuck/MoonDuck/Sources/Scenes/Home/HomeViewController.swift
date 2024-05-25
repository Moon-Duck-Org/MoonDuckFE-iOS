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
    func updateSortLabel(_ text: String)
    
    func reloadCategory()
    func reloadBoard()
    
    func moveBoardDetail(with service: AppServices, user: User, board: Board)
    
    func showBoardMoreAlert(sharedString: String, deleteHandler: (() -> Void)?)
}

class HomeViewController: UIViewController, HomeView, Navigatable {

    @IBOutlet private weak var categoryCollectionView: UICollectionView!
    @IBOutlet private weak var historyCountLabel: UILabel!
    @IBOutlet private weak var sortLabel: UILabel!
    @IBOutlet private weak var boardTableView: UITableView!
    @IBOutlet private weak var boardEmptyView: UIView!
    
    @IBAction private func sortButtonTap(_ sender: Any) {
        let titleList = presenter.sortList.map { String($0.title) }
        Alert.shared.showList(self,
                       buttonTitleList: titleList) { index in
            self.presenter.selectSort(at: index)
        }
    }
    
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
        
        presenter.viewDidLoad()
    }
    
    func updateSortLabel(_ text: String) {
        sortLabel.text = text
    }
    
    func updateEmptyView(isEmpty: Bool) {
        boardEmptyView.isHidden = isEmpty
    }
    
    func updateCountLabel(_ cnt: Int) {
        historyCountLabel.text = "\(cnt)"
    }
    
    func reloadCategory() {
        categoryCollectionView.reloadData()
    }
    
    func reloadBoard() {
        boardTableView.reloadData()
    }
    
    func showBoardMoreAlert(sharedString: String, deleteHandler: (() -> Void)?) {
        Alert.shared.showActionSheet(self, defaultTitle: "공유", destructiveTitle: "삭제", defaultHandler: {
            
            Alert.shared.showSystemShare(self, str: sharedString)
        }, destructiveHandler: deleteHandler)
    }
}

// MARK: - Navigation
extension HomeViewController {
    func moveBoardDetail(with service: AppServices, user: User, board: Board) {
        let presenter = BoardDetailViewPresenter(with: service, user: user, board: board)
        navigator.show(seque: .boardDetail(presenter: presenter), sender: self, transition: .navigation)
    }
}
