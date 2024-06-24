//
//  HomeReviewModel.swift
//  MoonDuck
//
//  Created by suni on 6/23/24.
//

import Foundation

protocol HomeReviewModelDelegate: AnyObject {
    func homeReview(_ model: HomeReviewModel, didSuccess reviews: [Review], isRefresh: Bool)
    func homeReview(_ model: HomeReviewModel, didRecieve error: APIError?)
    
}
protocol HomeReviewModelType: AnyObject {
    // Data
    var delegate: HomeReviewModelDelegate? { get set }
    var numberOfReviews: Int { get }
    var reviews: [Review] { get }
    
    // Logic
    
    // Networking
    func getReviews(with category: Category, filter: Sort)
}

class HomeReviewModel: HomeReviewModelType {
    
    private let provider: AppServices
    private var offset: Int = 0
    private var size: Int = 30
    
    init(_ provider: AppServices) {
        self.provider = provider
    }
    
    // MARK: - Data
    weak var delegate: HomeReviewModelDelegate?
    
    var numberOfReviews: Int {
        return reviews.count
    }
    
    var reviews: [Review] = []
    // MARK: - Logic
//    private func save(_ reviews: [Review]) {
//        self.reviews = reviews
//    }
    
    // MARK: - Networking
    func getReviews(with category: Category, filter: Sort) {
        if category == .all {
            getAllReview(filter)
        } else {
            
        }
    }
    
    private func getAllReview(_ filter: Sort) {
        let request = ReviewAllRequest(filter: filter.apiKey, offset: offset, size: size)
        provider.reviewService.reviewAll(request: request) { [weak self]  succeed, failed in
            guard let self else { return }
            if let succeed {
                // 검색 성공
//                self.offset += 1
                self.reviews = succeed.reviews
                self.delegate?.homeReview(self, didSuccess: self.reviews, isRefresh: true)
            } else {
                // 오류 발생
                if let code = failed as? APIError {
                    if code.isReviewError {
                        self.delegate?.homeReview(self, didRecieve: code)
                        return
                    } else if code.needsTokenRefresh {
                        AuthManager.default.refreshToken { [weak self] code in
                            guard let self else { return }
                            if code == .success {
                                self.getAllReview(filter)
                            } else {
                                Log.error("Refresh Token Error \(code)")
                                self.delegate?.homeReview(self, didRecieve: .unowned)
                            }
                        }
                        return
                    }
                }
                Log.error(failed?.localizedDescription ?? "Get ALL Review Error")
                self.delegate?.homeReview(self, didRecieve: .unowned)
            }
        }
        
    }
}
