//
//  BoardEditViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import Foundation
import UIKit
import Combine

protocol BoardEditPresenter: AnyObject {
    var view: BoardEditView? { get set }
    var service: AppServices { get }
    
    /// Life Cycle
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    
    /// Data
    
    /// Action
    func checkTitle(current: String, change: String) -> Bool
    func checkContent(current: String, change: String) -> Bool
    
}

class BoardEditViewPresenter: BoardEditPresenter {
    
    weak var view: BoardEditView?
    
    let service: AppServices
    
    private let user: User
    private var board: Board?
    private var isEdit: Bool = false
    private var cancellables = Set<AnyCancellable>()
    private let notificationCenter: NotificationCenter = .default // remove 처리
    
    init(with service: AppServices, user: User, board: Board? = nil) {
        self.service = service
        self.user = user
        self.board = board
    }

    func viewDidLoad() {
        if let board {
            view?.updateData(board: board)
        }
    }
    
    func viewWillAppear() {
        notificationCenter.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] notification in
                guard let info = UIKeyboardInfo(notification: notification) else {
                    return
                }
                self?.view?.keyboardWillShow(with: info)
            }
            .store(in: &cancellables)

        notificationCenter.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] notification in
                guard let info = UIKeyboardInfo(notification: notification) else {
                    return
                }
                self?.view?.keyboardWillHide(with: info)
            }
            .store(in: &cancellables)
    }
    func viewWillDisappear() {
        cancellables.removeAll()
    }
    
    func checkTitle(current: String, change: String) -> Bool {
        view?.updateCountTitle(change.count)
        return change.count < 40
    }
    
    func checkContent(current: String, change: String) -> Bool {
        view?.updateCountContent(change.count)
        return change.count < 500
    }
}
