//
//  BoardDetailViewPresenter.swift
//  MoonDuck
//
//  Created by suni on 5/25/24.
//

import Foundation

protocol ReviewDetailDelegate: AnyObject {
    func detailReview(_ review: Review, didChange boardId: Int)
    func detailReview(_ review: Review, didDelete boardId: Int)
}

protocol BoardDetailPresenter: AnyObject {
    var view: BoardDetailView? { get set }
    var service: AppServices { get }
    
    /// Life Cycle
    func viewDidLoad()
    
    /// Data
    var review: Review { get set }
    
    func reloadReview()
    
    /// Action
    func tapWriteReview()
    func tapDeleteReview()
}

class BoardDetailViewPresenter: BoardDetailPresenter {
    
    weak var view: BoardDetailView?
    
    let service: AppServices
    
    private let user: User
    var review: Review
    private let delegate: ReviewDetailDelegate
    
    init(with service: AppServices, user: User, board: Review, delegate: ReviewDetailDelegate) {
        self.service = service
        self.user = user
        self.review = board
        self.delegate = delegate
    }
    
    func viewDidLoad() {
        view?.updateData(review: review)
    }
    
    func tapWriteReview() {
        view?.moveBoardEdit(with: service, user: user, board: review)
    }
    
    func tapDeleteReview() {
        deleteReview()
    }
}

extension BoardDetailViewPresenter {
    func deleteReview() {
        let review = self.review
        let request = DeleteReviewRequest(boardId: review.id)
        service.reviewService.deleteReview(request: request) { succeed, _ in
            if let succeed, succeed {
                // 성공
                self.delegate.detailReview(review, didDelete: review.id)
                self.view?.popView()
            }
        }
    }
    
    func reloadReview() {
        let request = ReviewDetailRequest(boardId: review.id)
        service.reviewService.reviewDetail(request: request) { succeed, _ in
            if let succeed {
                self.review = succeed
                self.delegate.detailReview(succeed, didChange: succeed.id)
                self.view?.updateData(review: succeed)
            }
        }
    }
}
