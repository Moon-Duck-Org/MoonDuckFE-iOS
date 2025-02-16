//
//  ReviewModel.swift
//  MoonDuck
//
//  Created by suni on 7/1/24.
//

import Foundation

protocol APIReviewModelDelegate: AnyObject {
    func reviewModel(_ model: APIReviewModelType, didSuccess review: Review)
    func reviewModel(_ model: APIReviewModelType, didRecieve error: APIError?)
}

protocol APIReviewModelType: AnyObject {
    // Data
    var delegate: APIReviewModelDelegate? { get set }
    var review: Review { get }
    var deleteReviewHandler: (() -> Void)? { get }
    
    // Logic
    func save(for review: Review)
    
    // Networking
    func reviewDetail(with reviewId: Int)
}

class APIReviewModel: APIReviewModelType {
    private let provider: AppServices
    
    init(_ provider: AppServices, review: Review, deleteReviewHandler: (() -> Void)?) {
        self.provider = provider
        self.review = review
        self.deleteReviewHandler = deleteReviewHandler
    }
    
    // MARK: - Data
    weak var delegate: APIReviewModelDelegate?
    
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
extension APIReviewModel {
    func reviewDetail(with reviewId: Int) {
        let request = ReviewDetailRequest(boardId: reviewId)
        provider.reviewService.reviewDetail(request: request) { [weak self] succeed, failed in
            guard let self else { return }
            if let succeed {
                // 검색 성공
                self.review = succeed
            } else {
                // 오류 발생
                self.delegate?.reviewModel(self, didRecieve: failed)
            }
        }
    }
}
