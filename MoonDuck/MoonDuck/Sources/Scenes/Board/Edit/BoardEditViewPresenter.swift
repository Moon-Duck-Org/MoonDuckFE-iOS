//
//  BoardEditViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import Foundation
import UIKit
import Combine

protocol ReviewWriteDelegate: AnyObject {
    func writeReview(_ review: Review, didChange boardId: Int)
    func writeReview(_ review: Review, didCreate boardId: Int)
}

protocol BoardEditPresenter: AnyObject {
    var view: BoardEditView? { get set }
    var service: AppServices { get }
    
    var numberOfCategory: Int { get }
    var numberOfImage: Int { get }
    
    /// Life Cycle
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    
    /// Data
    func category(at index: Int) -> Category
    var indexOfSelectedCategory: Int? { get }
    
    func image(at index: Int) -> UIImage?
    func selectImage(image: UIImage?)
    
    /// Action
    func changeTitle(current: String, change: String) -> Bool
    func changeContent(current: String, change: String) -> Bool
    func selectCategory(at index: Int)
    func saveData()
    func tabRatingButton(at index: Int)
    func tapDeleteButton(at index: Int)
}

class BoardEditViewPresenter: BoardEditPresenter {
    
    func image(at index: Int) -> UIImage? {
        if imageList.count > index {
            return imageList[index]
        } else {
            return nil
        }
    }    
    
    weak var view: BoardEditView?
    
    var numberOfImage: Int {
        return imageList.count
    }
    
    var numberOfCategory: Int {
        return category.count
    }
    
    let service: AppServices
    var indexOfSelectedCategory: Int?
    
    private let delegate: ReviewWriteDelegate
    private let category: [Category]
    private let user: User
    private var board: Review?
    private var isEdit: Bool = false
    private var cancellables = Set<AnyCancellable>()
    private let notificationCenter: NotificationCenter = .default // remove 처리
    private var titleText: String = ""
    private var contentText: String = ""
    private var linkText: String?
    private var rating: Int = 0
    private var imageList: [UIImage?] = [UIImage?]()
    
    init(with service: AppServices, user: User, board: Review? = nil, delegate: ReviewWriteDelegate) {
        self.service = service
        self.category = [.movie, .book, .drama, .concert]
        self.user = user
        self.board = board
        self.delegate = delegate
    }
    
    func viewDidLoad() {
        if let board {
            if let firstIndex = category.firstIndex(of: board.category) {
                selectCategory(at: firstIndex)
            }
            titleText = board.title
            contentText = board.content
            linkText = board.link
            rating = board.rating
            
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
    
    func category(at index: Int) -> Category {
        return category[index]
    }
    
    func selectCategory(at index: Int) {
        indexOfSelectedCategory = index
        view?.reloadCategory()
    }
    
    func changeTitle(current: String, change: String) -> Bool {
        view?.updateCountTitle(change.count)
        titleText = change
        return change.count < 40
    }
    
    func changeContent(current: String, change: String) -> Bool {
        view?.updateCountContent(change.count)
        contentText = change
        return change.count < 500
    }
    
    func saveData() {
        var categoryData: Category = .movie
        var title = ""
        var content = ""
        var score = 0
        
        if let indexOfSelectedCategory {
            categoryData = category[indexOfSelectedCategory]
        } else {
            // 카테고리 미입력
            view?.toast("카테고리를 선택해주세요.")
            return
        }
        
        if titleText.count > 0 {
            title = titleText
        } else {
            // 제목 미입력
            view?.toast("제목을 입력해주세요.")
            return
        }
        
        if contentText.count > 0 {
            content = contentText
        } else {
            // 내용 미입력
            view?.toast("내용을 입력해주세요.")
            return
        }
        
        if rating > 0 {
            score = rating
        } else {
            // 별점 미입력
            view?.toast("별점을 선택해주세요.")
            return
        }
        
        if let board {
            putReview(at: Review(id: board.id,
                                 title: title,
                                 created: board.created,
                                 nickname: board.nickname,
                                 category: categoryData,
                                 content: content,
                                 imageUrlList: [],
                                 rating: score))
        } else {
            postReview(at: Review(id: 0,
                                  title: title,
                                  created: "",
                                  nickname: user.nickname,
                                  category: categoryData,
                                  content: content,
                                  imageUrlList: [],
                                  link: linkText,
                                  rating: score),
                       userId: user.id)
        }
    }
    
    func tabRatingButton(at index: Int) {
        guard rating != index else { return }
        rating = index
        view?.updateRating(at: index)
    }
    
    func selectImage(image: UIImage?) {
        imageList.append(image)
    }
    
    func tapDeleteButton(at index: Int) {
        if imageList.count > index {
            imageList.remove(at: index)
            view?.reloadImage()
        }
    }
}

// MARK: - Netwroking
extension BoardEditViewPresenter {
    private func putReview(at review: Review) {
        let request = PutReviewRequest(title: review.title,
                                       category: review.category.apiKey,
                                       content: review.content,
                                       url: review.link,
                                       score: review.rating,
                                       boardId: review.id)
        service.reviewService.putReview(request: request) { succeed, _ in
            if let succeed {
                // 메인 이동
                self.delegate.writeReview(succeed, didChange: succeed.id)
                self.view?.popView()
            }
        }
    }
    
    private func postReview(at review: Review, userId: Int) {
        let request = PostReviewRequest(title: review.title,
                                        category: review.category.apiKey,
                                        content: review.content,
                                        url: review.link,
                                        score: review.rating,
                                        userId: userId)
        service.reviewService.postReview(request: request) { succeed, _ in
            if let succeed {
                // 메인 이동
                self.delegate.writeReview(succeed, didCreate: succeed.id)
                self.view?.popView()
            }
        }
    }
}
