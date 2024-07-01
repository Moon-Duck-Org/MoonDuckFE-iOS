//
//  ReviewModel.swift
//  MoonDuck
//
//  Created by suni on 7/1/24.
//

import Foundation

protocol ReviewModelDelegate: AnyObject {
    func review(_ model: ReviewModelType, didSuccess review: Review)
    func review(_ model: ReviewModelType, didRecieve error: APIError?)
    func review(_ model: ReviewModelType, didDelete review: Review)
}

protocol ReviewModelType: AnyObject {
    // Data
    var delegate: ReviewModelDelegate? { get set }
    var review: Review { get }
    
    // Logic
    
    // Networking
    func reviewDetail(with reviewId: Int)
}

class ReviewModel: ReviewModelType {
    
    private let provider: AppServices
    
    init(_ provider: AppServices, review: Review) {
        self.provider = provider
        self.review = review
    }
    
    // MARK: - Data
    weak var delegate: ReviewModelDelegate?
    
    var review: Review {
        didSet {
            delegate?.review(self, didSuccess: review)
        }
    }
    
    // MARK: - Logic
    
    
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
                if let code = failed as? APIError {
                    if code.isReviewError {
                        self.delegate?.review(self, didRecieve: code)
                        return
                    } else if code.needsTokenRefresh {
                        AuthManager.default.refreshToken { [weak self] code in
                            guard let self else { return }
                            if code == .success {
                                self.reviewDetail(with: reviewId)
                            } else {
                                Log.error("Refresh Token Error \(code)")
                                self.delegate?.review(self, didRecieve: .unowned)
                            }
                        }
                        return
                    }
                }
                Log.error(failed?.localizedDescription ?? "Get Review Error")
                self.delegate?.review(self, didRecieve: .unowned)
            }
        }
    }
}
