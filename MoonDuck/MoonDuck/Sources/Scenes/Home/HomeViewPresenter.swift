//
//  HomeViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation

protocol HomePresenter: AnyObject {
    var view: HomeView? { get set }
    
    var sortList: [Sort] { get }
    
    var numberOfCategory: Int { get }
    var numberOfBoard: Int { get }
    var indexOfSelectedCategory: Int { get }
        
    /// Life Cycle
    func viewDidLoad()
    
    /// Data
    func category(at index: Int) -> Category
    func board(at index: Int) -> Review
    
    /// Action
    func selectCategory(at index: Int)
    func selectSort(at index: Int)
    func selectBoard(at index: Int)
    func tappedCreaateReview()
    
    func tappedBoardMore(at index: Int)
    func deleteBoard(at index: Int)
    
    func reloadReview()
}

class HomeViewPresenter: Presenter, HomePresenter {
    
    weak var view: HomeView?
    
    var numberOfCategory: Int {
        return category.count
    }
    var numberOfBoard: Int {
        return boardList.count
    }
    
    var indexOfSelectedCategory: Int = 0
    let sortList: [Sort]
    
    private let category: [Category]
    private var boardList: [Review]
    private let user: User
    private var indexOfSeletedSort: Int = 0
    
    init(with provider: AppServices, user: User) {
        self.category = [.all, .movie, .book, .drama, .concert]
        self.sortList = [.latestOrder, .oldestFirst, .ratingOrder]
        self.user = user
        self.boardList = []
        
        super.init(with: provider)
    }
    
    func viewDidLoad() {
        selectCategory(at: indexOfSelectedCategory)
    }
    
    func category(at index: Int) -> Category {
        return category[index]
    }
    
    func board(at index: Int) -> Review {
        return boardList[index]
    }
    
    func selectCategory(at index: Int) {
        indexOfSelectedCategory = index
        view?.reloadCategory()
        loadReview(at: category[index], sort: sortList[indexOfSeletedSort])
    }
    
    func selectSort(at index: Int) {
        guard indexOfSeletedSort != index else { return }
        indexOfSeletedSort = index
        view?.updateSortLabel(sortList[index].title)
        loadReview(at: category[indexOfSelectedCategory], sort: sortList[index])
    }
    
    func selectBoard(at index: Int) {
        let board = boardList[index]
        let presenter = BoardDetailViewPresenter(with: provider, user: user, board: board, delegate: view)
        view?.moveBoardDetail(with: presenter)
    }
    
    func tappedBoardMore(at index: Int) {
        view?.showBoardMoreAlert(at: index)
    }
    
    func deleteBoard(at index: Int) {
        let review = boardList[index]
        delete(at: review)
        boardList.remove(at: index)
        reloadBoard()
    }
    
    func tappedCreaateReview() {
        let presenter = BoardEditViewPresenter(with: provider, user: user, delegate: view)
        view?.moveBoardEdit(with: presenter)
    }
    
    private func reloadBoard() {
        view?.reloadBoard()
        if boardList.count < 1 {
            view?.updateEmptyView(isEmpty: true)
        } else {
            view?.updateEmptyView(isEmpty: false)
            view?.srollToTop()
        }
        view?.updateCountLabel(boardList.count)
    }
    
    func reloadReview() {
        loadReview(at: category[indexOfSelectedCategory], sort: sortList[indexOfSeletedSort])
    }
    
}

// MARK: - Netwroking
extension HomeViewPresenter {
    private func loadReview(at category: Category, sort: Sort) {
        if category == .all {
            reviewAll(sort: sort)
        } else {
            getReview(at: category, sort: sort)
        }
    }
    
    private func getReview(at category: Category, sort: Sort) {
        let request = GetReviewRequest(userId: user.id, category: category.apiKey, filter: sort.apiKey)
        provider.reviewService.getReview(request: request) { succeed, _ in
            if let succeed {
                self.boardList = succeed
            }
            self.reloadBoard()
        }
    }
    
    private func reviewAll(sort: Sort) {
        let request = ReviewAllRequest(userId: user.id, filter: sort.apiKey)
        provider.reviewService.reviewAll(request: request) { succeed, _ in
            if let succeed {
                self.boardList = succeed
            }
            self.reloadBoard()
        }
    }
    
    private func delete(at review: Review) {
        let request = DeleteReviewRequest(boardId: review.id)
        provider.reviewService.deleteReview(request: request) { succeed, _ in
            if let succeed, succeed {
                // 성공                
            }
        }
    }
}
