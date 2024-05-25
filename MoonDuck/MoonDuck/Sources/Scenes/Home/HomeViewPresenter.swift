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
    
    var numberOfCategory: Int { get }
    var numberOfBoard: Int { get }
    
    var selectedCategoryIndex: Int { get }
        
    func viewDidLoad()
    
    func category(at index: Int) -> Category
    func board(at index: Int) -> Board
    
    func selectCategoryIndex(at index: Int)
}

class HomeViewPresenter: HomePresenter {
    weak var view: HomeView?
    
    var numberOfCategory: Int {
        return category.count
    }
    var numberOfBoard: Int {
        return boardList.count
    }
    
    private let category: [Category]
    private var boardList: [Board]
    private let user: User
    
    let service: AppServices
    var selectedCategoryIndex: Int = 0
    
    init(with service: AppServices, user: User) {
        self.service = service
        self.category = [.all, .movie, .book, .drama, .concert]
        self.user = user
        self.boardList = []
    }
    
    func viewDidLoad() {
        selectCategoryIndex(at: selectedCategoryIndex)
    }
    
    func category(at index: Int) -> Category {
        return category[index]
    }
    
    func board(at index: Int) -> Board {
        return boardList[index]
    }
    
    func selectCategoryIndex(at index: Int) {
        selectedCategoryIndex = index
        view?.reloadCategory()
        boardPostsUser(at: category[index])
    }
}

// MARK: - Netwroking
extension HomeViewPresenter {
    func boardPostsUser(at category: Category) {
        // FIXME: - TEST CODE : 홈 진입
        let request = BoardPosetUserRequest(userId: user.deviceId, category: category.apiString)
        service.boardService.boardPostsUser(request: request) { succeed, _ in
            if let succeed {
                self.boardList = succeed
                self.view?.reloadBoard()
                if self.boardList.count < 1 {
                    self.view?.updateEmptyView(isEmpty: true)
                }
            } else {
                self.view?.updateEmptyView(isEmpty: true)
            }
        }
    }
}
