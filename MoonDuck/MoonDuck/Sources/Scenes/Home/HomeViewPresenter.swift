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
        loadReview(at: category[index])
    }
    
    func selectSort(at index: Int) {
        guard indexOfSeletedSort != index else { return }
        // TODO: SORT API 연결
        indexOfSeletedSort = index
        view?.updateSortLabel(sortList[index].title)
        loadReview(at: category[indexOfSelectedCategory])
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
    
    private func reloadBoard() {
        view?.reloadBoard()
        if boardList.count < 1 {
            view?.updateEmptyView(isEmpty: true)
        }
        view?.updateCountLabel(boardList.count)
    }
    func tappedCreaateReview() {
        view?.moveBoardEdit(with: service, user: user, board: nil)
    }
}

// MARK: - Netwroking
extension HomeViewPresenter {
    func boardPostsUser(at category: Category) {
        // TODO: - API boardPostsUser
        let request = BoardPosetUserRequest(userId: user.deviceId, category: category.apiKey)
        service.reviewService.boardPostsUser(request: request) { succeed, _ in
            if let succeed {
                self.boardList = succeed
            }
            self.reloadBoard()
        }
    }
    
    private func loadReview(at category: Category) {
        if category == .all {
            reviewAll()
        } else {
            
        }
    }
    
    private func reviewAll() {
        let request = ReviewAllRequest(userId: user.id)
        service.reviewService.reviewAll(request: request) { succeed, failed in
            if let succeed {
                self.boardList = succeed
            }
            self.reloadBoard()
        }
    }
}
