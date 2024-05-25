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
    func board(at index: Int) -> Board
    
    /// Action
    func selectCategory(at index: Int)
    func selectSort(at index: Int)
    func selectBoard(at index: Int)
    
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
    private var boardList: [Board]
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
    
    func board(at index: Int) -> Board {
        return boardList[index]
    }
    
    func selectCategory(at index: Int) {
        indexOfSelectedCategory = index
        view?.reloadCategory()
        boardPostsUser(at: category[index])
    }
    
    func selectSort(at index: Int) {
        guard indexOfSeletedSort != index else { return }
        // TODO: SORT API 연결
        indexOfSeletedSort = index
        view?.updateSortLabel(sortList[index].title)
        boardPostsUser(at: category[indexOfSelectedCategory])
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
        self.view?.reloadBoard()
        if self.boardList.count < 1 {
            self.view?.updateEmptyView(isEmpty: true)
        }
    }
}

// MARK: - Netwroking
extension HomeViewPresenter {
    func boardPostsUser(at category: Category) {
        // TODO: - API boardPostsUser
        let request = BoardPosetUserRequest(userId: user.deviceId, category: category.apiKey)
        service.boardService.boardPostsUser(request: request) { succeed, _ in
            if let succeed {
                self.boardList = succeed
            }
            self.reloadBoard()
        }
    }
}
