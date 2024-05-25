//
//  HomeViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/23/24.
//

import Foundation

protocol HomePresenter: AnyObject {
    var view: HomeView? { get set }
    var service: AppServices { get }
    
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

class HomeViewPresenter: HomePresenter {
    
    weak var view: HomeView?
    
    var numberOfCategory: Int {
        return category.count
    }
    var numberOfBoard: Int {
        return boardList.count
    }
    
    let service: AppServices
    var indexOfSelectedCategory: Int = 0
    let sortList: [Sort]
    
    private let category: [Category]
    private var boardList: [Review]
    private let user: User
    private var indexOfSeletedSort: Int = 0
    
    init(with service: AppServices, user: User) {
        self.service = service
        self.category = [.all, .movie, .book, .drama, .concert]
        self.sortList = [.latestOrder, .oldestFirst, .ratingOrder]
        self.user = user
        self.boardList = []
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
        // TODO: SORT API 연결
        indexOfSeletedSort = index
        view?.updateSortLabel(sortList[index].title)
        loadReview(at: category[indexOfSelectedCategory], sort: sortList[index])
    }
    
    func selectBoard(at index: Int) {
        let board = boardList[index]
        view?.moveBoardDetail(with: service, user: user, board: board)
    }
    
    func tappedBoardMore(at index: Int) {
        view?.showBoardMoreAlert(at: index)
    }
    
    func deleteBoard(at index: Int) {
        // TODO: API board delete
        boardList.remove(at: index)
        reloadBoard()
    }
    
    func tappedCreaateReview() {
        view?.moveBoardEdit(with: service, user: user, board: nil)
    }
    
    private func reloadBoard() {
        view?.reloadBoard()
        if boardList.count < 1 {
            view?.updateEmptyView(isEmpty: true)
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
        service.reviewService.getReview(request: request) { succeed, _ in
            if let succeed {
                self.boardList = succeed
            }
            self.reloadBoard()
        }
    }
    
    private func reviewAll(sort: Sort) {
        let request = ReviewAllRequest(userId: user.id, filter: sort.apiKey)
        service.reviewService.reviewAll(request: request) { succeed, _ in
            if let succeed {
                self.boardList = succeed
            }
            self.reloadBoard()
        }
    }
    
}
