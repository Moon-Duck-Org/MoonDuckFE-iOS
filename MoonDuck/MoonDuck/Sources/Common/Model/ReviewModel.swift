//
//  ReviewModel.swift
//  MoonDuck
//
//  Created by suni on 7/1/24.
//

import Foundation

protocol ReviewModelDelegate: AnyObject {
    func reviewModel(_ model: ReviewModelType, didSuccess review: Review)
    func reviewModel(_ model: ReviewModelType, didRecieve error: APIError?)
}

protocol ReviewModelType: AnyObject {
    // Data
    var delegate: ReviewModelDelegate? { get set }
    var review: Review { get }
    var deleteReviewHandler: (() -> Void)? { get }
    
    // Logic
    func save(for review: Review)
    
    // Networking
    func reviewDetail(with reviewId: Int)
}

class ReviewModel: ReviewModelType {
    private let provider: AppServices
    
    init(_ provider: AppServices, review: Review, deleteReviewHandler: (() -> Void)?) {
        self.provider = provider
        self.review = review
        self.deleteReviewHandler = deleteReviewHandler
    }
    
    // MARK: - Data
    weak var delegate: ReviewModelDelegate?
    
    var review: Review {
        didSet {
            delegate?.reviewModel(self, didSuccess: review)
        }
    }
    
    var deleteReviewHandler: (() -> Void)?
    
    // MARK: - Logic
    func save(for review: Review) {
        self.review = review
    }
    
}

// MARK: - Networking
extension ReviewModel {
    func reviewDetail(with reviewId: Int) {
        let request = ReviewDetailRequest(boardId: reviewId)
        provider.reviewService.reviewDetail(request: request) { [weak self] succeed, failed in
            guard let self else { return }
            if let succeed {
                // 검색 성공
                self.review = succeed
            } else {
                // 오류 발생
                if let error = failed {
                    if error.isReviewError {
                        self.delegate?.reviewModel(self, didRecieve: error)
                        return
                    } else if error.needsTokenRefresh {
                        AuthManager.default.refreshToken { [weak self] success, error in
                            guard let self else { return }
                            if let error {
                                self.delegate?.reviewModel(self, didRecieve: error)
                                return
                            }
                            if success {
                                self.reviewDetail(with: reviewId)
                                return
                            }
                        }
                        return
                    }
                }
                self.delegate?.reviewModel(self, didRecieve: .unknown)
            }
        }
    }
}
