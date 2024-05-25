//
//  BoardDetailViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import Foundation

protocol BoardDetailPresenter: AnyObject {
    var view: BoardDetailView? { get set }
    var service: AppServices { get }
        
    /// Life Cycle
    func viewDidLoad()
    func viewWillAppear()
    
    /// Data
    
    /// Action
}

class BoardDetailViewPresenter: BoardDetailPresenter {
    
    weak var view: BoardDetailView?
    
    let service: AppServices
    
    private let user: User
    private let board: Board
    
    init(with service: AppServices, user: User, board: Board) {
        self.service = service
        self.user = user
        self.board = board
    }
    
    func viewDidLoad() {
        
    }
    
    func viewWillAppear() {
        view?.reloadData(board: board)
    }
}
