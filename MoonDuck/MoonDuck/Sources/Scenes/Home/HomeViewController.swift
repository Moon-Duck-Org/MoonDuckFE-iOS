////
////  HomeViewController.swift
////  MoonDuck
////
////  Created by suni on 5/23/24.
////
//
//import UIKit
//
//protocol HomeView: AnyObject, ReviewDetailDelegate, ReviewWriteDelegate {
//    func moveBoardDetail(with presenter: BoardDetailViewPresenter)
//    func moveBoardEdit(with presenter: BoardEditViewPresenter)
//    func showBoardMoreAlert(at indexOfBoard: Int)
//    
//    func updateEmptyView(isEmpty: Bool)
//    func updateCountLabel(_ cnt: Int)
//    func updateSortLabel(_ text: String)
//    
//    func reloadCategory()
//    func reloadBoard()
//    func srollToTop()
//}
//
//class HomeViewController: UIViewController, HomeView, Navigatable {
//
//    @IBOutlet private weak var categoryCollectionView: UICollectionView!
//    @IBOutlet private weak var historyCountLabel: UILabel!
//    @IBOutlet private weak var sortLabel: UILabel!
//    @IBOutlet private weak var boardTableView: UITableView!
//    @IBOutlet private weak var boardEmptyView: UIView!
//    
//    @IBAction private func sortButtonTap(_ sender: Any) {
//        let titleList = presenter.sortList.map { String($0.title) }
//        AppAlert.shared.showList(self, buttonTitleList: titleList) { index in
//            self.presenter.selectSort(at: index)
//        }
//    }
//    
//    @IBAction private func createReviewButtonTap(_ sender: Any) {
//        presenter.tappedCreaateReview()
//    }
//    
//    var navigator: Navigator!
//    let presenter: HomePresenter
//    let categoryDataSource: HomeCategoryCvDataSource
//    let boardDataSource: BoardListTvDataSource
//    
//    init(navigator: Navigator,
//         presenter: HomePresenter) {
//        self.navigator = navigator
//        self.presenter = presenter
//        self.categoryDataSource = HomeCategoryCvDataSource(presenter: presenter)
//        self.boardDataSource = BoardListTvDataSource(presenter: presenter)
//        super.init(nibName: HomeViewController.className, bundle: Bundle(for: HomeViewController.self))
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        presenter.view = self
//        
//        categoryDataSource.configure(with: categoryCollectionView)
//        boardDataSource.configure(with: boardTableView)
//        
//        presenter.viewDidLoad()
//    }
//    
//    func srollToTop() {
//        boardTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
//    }
//    
//    func updateSortLabel(_ text: String) {
//        sortLabel.text = text
//    }
//    
//    func updateEmptyView(isEmpty: Bool) {
//        boardEmptyView.isHidden = !isEmpty
//    }
//    
//    func updateCountLabel(_ cnt: Int) {
//        historyCountLabel.text = "\(cnt)"
//    }
//    
//    func reloadCategory() {
//        categoryCollectionView.reloadData()
//    }
//    
//    func reloadBoard() {
//        boardTableView.reloadData()
//    }
//    
//    func showBoardMoreAlert(at indexOfBoard: Int) {
//        Alert.shared.showActionSheet(self, defaultTitle: "공유", destructiveTitle: "삭제", defaultHandler: {
//            let str = self.presenter.board(at: indexOfBoard).content
//            Alert.shared.showSystemShare(self, str: str)
//        }, destructiveHandler: {
//            Alert.shared.showAlert(self, style: .deleteTwoButton, title: "삭제하시겠어요?", destructiveHandler: {
//                self.presenter.deleteBoard(at: indexOfBoard)
//            })
//        })
//    }
//}
//
//// MARK: - Navigation
//extension HomeViewController {
//    func moveBoardDetail(with presenter: BoardDetailViewPresenter) {
//        navigator.show(seque: .boardDetail(presenter: presenter), sender: self, transition: .navigation)
//    }
//    
//    func moveBoardEdit(with presenter: BoardEditViewPresenter) {
//        navigator.show(seque: .boardEdit(presenter: presenter), sender: self, transition: .navigation)
//    }
//}
//
//// MARK: - ReviewWriteDelegate
//extension HomeViewController {
//    func writeReview(_ review: Review, didChange boardId: Int) {
//        presenter.reloadReview()
//    }
//    
//    func writeReview(_ review: Review, didCreate boardId: Int) {
//        presenter.reloadReview()
//    }
//}
//
//// MARK: - ReviewDetailDelegate
//extension HomeViewController {
//    func detailReview(_ review: Review, didChange boardId: Int) {
//        presenter.reloadReview()
//    }
//    
//    func detailReview(_ review: Review, didDelete boardId: Int) {
//        presenter.reloadReview()
//    }
//}
