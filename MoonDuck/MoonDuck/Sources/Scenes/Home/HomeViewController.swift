//
//  HomeViewController.swift
//  MoonDuck
//
//  Created by suni on 6/8/24.
//

import UIKit

protocol HomeView: BaseView {
    // UI Logic
    func reloadCategories()
    func reloadReviews()
    func updateReviewCount(_ count: String)
    func updateSortTitle(_ text: String)
    func updateEmptyReviewsView(_ isEmpty: Bool)
    func resetScrollAndEndRefresh()
    func showOptionAlert(for review: Review)
    
    // Navigation
    func moveMy(with presenter: MyInfoPresenter)
    func moveSelectProgram(with presenter: SelectProgramPresenter)
    func moveWriteReview(with presenter: WriteReviewPresenter)
    func moveReviewDetail(with presenter: ReviewDetailPresenter)
    func popToSelf()
}

class HomeViewController: BaseViewController, HomeView, Navigatable {
    var navigator: Navigator?
    let presenter: HomePresenter
    
    private let categoryDataSource: HomeCategoryDataSource
    private let reviewDataSource: HomeReviewDataSource
    private let refreshControl = UIRefreshControl()
    
    // @IBOutlet
    @IBOutlet weak private var categoryCollectioinView: UICollectionView!
    @IBOutlet weak private var reviewCountLabel: UILabel!
    @IBOutlet weak private var sortTitleLabel: UILabel!
    @IBOutlet weak private var reviewTableView: UITableView!
    @IBOutlet weak private var emptyReviewsView: UIView!
    
    // @IBAction
    @IBAction private func tapMyButton(_ sender: Any) {
        presenter.tapMyButton()
    }
    @IBAction private func tapSortButton(_ sender: Any) {
        AppAlert.default.showList(self, buttonTitleList: presenter.sortTitleList) { [weak self] index in
            self?.presenter.selectSort(at: index)
        }
    }
    @IBAction private func tapWriteNewReviewButton(_ sender: Any) {
        presenter.tapWriteNewReviewButton()
    }
        
    init(navigator: Navigator,
         presenter: HomePresenter) {
        self.navigator = navigator
        self.presenter = presenter
        self.categoryDataSource = HomeCategoryDataSource(presenter: self.presenter)
        self.reviewDataSource = HomeReviewDataSource(presenter: self.presenter)
        super.init(nibName: HomeViewController.className, bundle: Bundle(for: HomeViewController.self))
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
        
        refreshControl.tintColor = Asset.Color.gray3.color
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        reviewTableView.refreshControl = refreshControl
    }
}

// MARK: - UI Logic
extension HomeViewController {
    func reloadCategories() {
        categoryCollectioinView.reloadData()
    }
    
    func reloadReviews() {
        reviewTableView.reloadData()
    }
    
    func updateReviewCount(_ count: String) {
        reviewCountLabel.text = count
    }
    
    func updateSortTitle(_ text: String) {
        sortTitleLabel.text = text
    }
    
    func updateEmptyReviewsView(_ isEmpty: Bool) {
        emptyReviewsView.isHidden = !isEmpty
    }

    func resetScrollAndEndRefresh() {
        if refreshControl.isRefreshing {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.refreshControl.endRefreshing()
            }
        } else {
            DispatchQueue.main.async {
                // 테이블 뷰를 맨 위로 스크롤
                let topIndexPath = IndexPath(row: 0, section: 0)
                if self.reviewTableView.numberOfSections > 0 && self.reviewTableView.numberOfRows(inSection: 0) > 0 {
                    self.reviewTableView.scrollToRow(at: topIndexPath, at: .top, animated: true)
                }
            }
        }
    }
    
    func showOptionAlert(for review: Review) {
        AppAlert.default
            .showReviewOption(
                self,
                writeHandler: presenter.writeReviewHandler(for: review),
                shareHandler: presenter.shareReviewHandler(for: review),
                deleteHandler: { [weak self] in
                    self?.showDeleteReviewAlert(review)
                }
            )
    }
    
    private func showDeleteReviewAlert(_ review: Review) {
        AppAlert.default
            .showDestructive(
                self,
                title: "삭제하시겠어요?",
                destructiveHandler: presenter.deleteReviewHandler(for: review)
            )
    }
    
    @objc
    private func refreshData(_ sender: Any) {
        // 새로고침할 데이터 로드하는 메서드 호출
        presenter.refreshReviews()
    }
}

// MARK: - Navigation
extension HomeViewController {
    func moveMy(with presenter: MyInfoPresenter) {
        navigator?.show(seque: .myInfo(presenter: presenter), sender: self, transition: .navigation, animated: true)
    }
    
    func moveSelectProgram(with presenter: SelectProgramPresenter) {
        navigator?.show(seque: .selectProgram(presenter: presenter), sender: self, transition: .navigation, animated: true)
    }
     
    func moveWriteReview(with presenter: WriteReviewPresenter) {
        navigator?.show(seque: .writeReview(presenter: presenter), sender: self, transition: .navigation, animated: true)
    }
    
    func moveReviewDetail(with presenter: ReviewDetailPresenter) {
        navigator?.show(seque: .reviewDetail(presenter: presenter), sender: self, transition: .navigation, animated: true)
    }
    
    func popToSelf() {
        navigator?.pop(sender: self, popType: .popToSelf, animated: true)
    }
}
