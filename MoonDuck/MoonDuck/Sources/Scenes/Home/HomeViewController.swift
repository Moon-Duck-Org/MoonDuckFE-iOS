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
    
    func moveBoardDetail(with service: AppServices, user: User, board: Review)
    func moveBoardEdit(with service: AppServices, user: User, board: Review?)
    func showBoardMoreAlert(at indexOfBoard: Int)
}

class HomeViewController: UIViewController, HomeView, Navigatable {

    @IBOutlet private weak var categoryCollectionView: UICollectionView!
    @IBOutlet private weak var historyCountLabel: UILabel!
    @IBOutlet private weak var sortLabel: UILabel!
    @IBOutlet private weak var boardTableView: UITableView!
    @IBOutlet private weak var boardEmptyView: UIView!
    
    @IBAction private func sortButtonTap(_ sender: Any) {
        let titleList = presenter.sortList.map { String($0.title) }
        Alert.shared.showList(self, buttonTitleList: titleList) { index in
            self.presenter.selectSort(at: index)
        }
    }
    
    @IBAction private func createReviewButtonTap(_ sender: Any) {
        presenter.tappedCreaateReview()
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
        boardEmptyView.isHidden = !isEmpty
    }
    
    func updateCountLabel(_ cnt: Int) {
        historyCountLabel.text = "\(cnt)"
    }
    
    func reloadCategory() {
        categoryCollectionView.reloadData()
    }
    
    func reloadBoard() {
        boardTableView.reloadData()
        boardTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    func showBoardMoreAlert(at indexOfBoard: Int) {
        Alert.shared.showActionSheet(self, defaultTitle: "공유", destructiveTitle: "삭제", defaultHandler: {
            let str = self.presenter.board(at: indexOfBoard).content
            Alert.shared.showSystemShare(self, str: str)
        }, destructiveHandler: {
            Alert.shared.showAlert(self, style: .deleteTwoButton, title: "삭제하시겠어요?", destructiveHandler: {
                self.presenter.deleteBoard(at: indexOfBoard)
            })
        })
    }
}

// MARK: - Navigation
extension HomeViewController {
    func moveBoardDetail(with service: AppServices, user: User, board: Review) {
        let presenter = BoardDetailViewPresenter(with: service, user: user, board: board)
        navigator.show(seque: .boardDetail(presenter: presenter), sender: self, transition: .navigation)
    }
    
    func moveBoardEdit(with service: AppServices, user: User, board: Review?) {
        let presenter = BoardEditViewPresenter(with: service, user: user, board: board)
        navigator.show(seque: .boardEdit(presenter: presenter), sender: self, transition: .navigation)
    }
}
