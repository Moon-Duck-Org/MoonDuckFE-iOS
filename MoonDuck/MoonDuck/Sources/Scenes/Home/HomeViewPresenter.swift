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
    
    func category(at index: Int) -> Category
    func board(at index: Int) -> Board
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
    
    init(with service: AppServices, user: User) {
        self.service = service
        self.category = [.all, .movie, .book, .drama, .concert]
        self.boardList = [
            Board(id: 0, created: "2024년 5월 24일", userNickname: "포덕이", title: "범죄도시", content: "재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 ㅍ 재밌다 재밌다 재밌다 ㅍ", category: .movie),
            Board(id: 0, created: "2024년 5월 24일", userNickname: "포덕이", title: "범죄도시", content: "재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 ㅍ 재밌다 재밌다 재밌다 ㅍ", category: .movie),
            Board(id: 0, created: "2024년 5월 24일", userNickname: "포덕이", title: "범죄도시", content: "재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 ㅍ 재밌다 재밌다 재밌다 ㅍ", category: .movie),
            Board(id: 0, created: "2024년 5월 24일", userNickname: "포덕이", title: "범죄도시", content: "재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 ㅍ 재밌다 재밌다 재밌다 ㅍ", category: .movie),
            Board(id: 0, created: "2024년 5월 24일", userNickname: "포덕이", title: "범죄도시", content: "재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 ㅍ 재밌다 재밌다 재밌다 ㅍ", category: .movie),
            Board(id: 0, created: "2024년 5월 24일", userNickname: "포덕이", title: "범죄도시", content: "재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 재밌다 ㅍ 재밌다 재밌다 재밌다 ㅍ", category: .movie)
        ]
        self.user = user
    }
    
    func category(at index: Int) -> Category {
        return category[index]
    }
    
    func board(at index: Int) -> Board {
        return boardList[index]
    }
}
