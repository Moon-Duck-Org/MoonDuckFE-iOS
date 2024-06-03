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
    
    /// Life Cycle
    func viewDidLoad()
    
    /// Data
    var review: Review { get set }
    
    func reloadReview()
    
    /// Action
    func tapWriteReview()
    func tapDeleteReview()
}

class BoardDetailViewPresenter: Presenter, BoardDetailPresenter {
    
    weak var view: BoardDetailView?
    private weak var delegate: ReviewDetailDelegate?
    
    var review: Review
    private let user: User
    
    init(with provider: AppServices, user: User, board: Review, delegate: ReviewDetailDelegate?) {
        self.user = user
        self.review = board
        self.delegate = delegate
        super.init(with: provider)
    }
    
    func viewDidLoad() {
        view?.updateData(review: review)
    }
    
    func tapWriteReview() {
        let presenter = BoardEditViewPresenter(with: provider, user: user, board: review)
        view?.moveBoardEdit(with: presenter)
    }
    
    func tapDeleteReview() {
        deleteReview()
    }
}

extension BoardDetailViewPresenter {
    func deleteReview() {
        let review = self.review
        let request = DeleteReviewRequest(boardId: review.id)
        provider.reviewService.deleteReview(request: request) { succeed, _ in
            if let succeed, succeed {
                // 성공
                self.delegate?.detailReview(review, didDelete: review.id)
                self.view?.popView()
            }
        }
    }
    
    func reloadReview() {
        let request = ReviewDetailRequest(boardId: review.id)
        provider.reviewService.reviewDetail(request: request) { succeed, _ in
            if let succeed {
                self.review = succeed
                self.delegate?.detailReview(succeed, didChange: succeed.id)
                self.view?.updateData(review: succeed)
            }
        }
    }
}
