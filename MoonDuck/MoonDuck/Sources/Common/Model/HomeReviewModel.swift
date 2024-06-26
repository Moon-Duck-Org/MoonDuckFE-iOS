//
//  HomeReviewModel.swift
//  MoonDuck
//
//  Created by suni on 6/23/24.
//

import Foundation

protocol HomeReviewModelDelegate: AnyObject {
    func homeReview(_ model: HomeReviewModel, didSuccess list: ReviewList)
    func homeReview(_ model: HomeReviewModel, didRecieve error: APIError?)
    func homeReviewDidRecieveLastReviews(_ model: HomeReviewModel)
    
}
protocol HomeReviewModelType: AnyObject {
    // Data
    var delegate: HomeReviewModelDelegate? { get set }
    
    func numberOfReviews(with category: Category) -> Int
    func reviews(with category: Category) -> [Review]
    func review(with category: Category, at index: Int) -> Review?
    func reviewList(with category: Category) -> ReviewList?
    
    // Logic
    
    // Networking
    func loadReviews(with category: Category, filter: Sort)
    func reloadReviews(with category: Category, filter: Sort)
}

class HomeReviewModel: HomeReviewModelType {
    private let provider: AppServices
    
    init(_ provider: AppServices) {
        self.provider = provider
    }
    
    // MARK: - Data
    weak var delegate: HomeReviewModelDelegate?
    
    private var reviewLists: [ReviewList] = []
    
    func numberOfReviews(with category: Category) -> Int {
        return reviews(with: category).count
    }
    
    func reviews(with category: Category) -> [Review] {
        if let reviewList = reviewList(with: category) {
            return reviewList.reviews
        }
        return []
    }
    
    func review(with category: Category, at index: Int) -> Review? {
        let reviews = reviews(with: category)
        if index < reviews.count {
            return reviews[index]
        }
        return nil
    }
    
    func reviewList(with category: Category) -> ReviewList? {
        if let list = reviewLists.first(where: { $0.category == category }) {
            return list
        }
        return nil
    }
    
    // MARK: - Logic
    private func removeReviewList(with category: Category) {
        if let findIndex = reviewLists.firstIndex(where: { $0.category == category }) {
            reviewLists.remove(at: findIndex)
        }
    }
    
    private func saveReviewList(_ list: ReviewList) {
        let category = list.category
        if list.isFirst {
            removeReviewList(with: category)
        }
        
        if let findIndex = reviewLists.firstIndex(where: { $0.category == category }) {
            reviewLists[findIndex].update(list)
            delegate?.homeReview(self, didSuccess: reviewLists[findIndex])
        } else {
            reviewLists.append(list)
            delegate?.homeReview(self, didSuccess: list)
        }
    }
    
    // MARK: - Networking
    func loadReviews(with category: Category, filter: Sort) {
        if category == .all {
            getAllReview(filter, isReload: false)
        } else {
            getReview(with: category, filter: filter, isReload: false)
        }
    }
    
    func reloadReviews(with category: Category, filter: Sort) {
        if category == .all {
            getAllReview(filter, isReload: true)
        } else {
            getReview(with: category, filter: filter, isReload: true)
        }
    }
    
    private func getReview(with category: Category, filter: Sort, isReload: Bool) {
        var offset: Int = 0
        var size: Int = 30
        
        if !isReload, let list = reviewList(with: category) {
            if list.isLast {
                self.delegate?.homeReview(self, didRecieve: nil)
                return
            }
            offset = list.currentPage + 1
            size = list.size
        }
        
        let request = GetReviewRequest(category: category.apiKey, filter: filter.apiKey, offset: offset, size: size)
        provider.reviewService.getReview(request: request) { [weak self]  succeed, failed in
            guard let self else { return }
            if let succeed {
                // 검색 성공
                var list = succeed
                list.category = category
                self.saveReviewList(list)
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
                                self.getReview(with: category, filter: filter, isReload: isReload)
                            } else {
                                Log.error("Refresh Token Error \(code)")
                                self.delegate?.homeReview(self, didRecieve: .unowned)
                            }
                        }
                        return
                    }
                }
                Log.error(failed?.localizedDescription ?? "Get Review Error")
                self.delegate?.homeReview(self, didRecieve: .unowned)
            }
        }
    }
    
    private func getAllReview(_ filter: Sort, isReload: Bool) {
        var offset: Int = 0
        var size: Int = 30
        
        if !isReload, let list = reviewList(with: .all) {
            if list.isLast {
                self.delegate?.homeReview(self, didRecieve: nil)
                return
            }
            offset = list.currentPage + 1
            size = list.size
        }
        
        let request = ReviewAllRequest(filter: filter.apiKey, offset: offset, size: size)
        provider.reviewService.reviewAll(request: request) { [weak self]  succeed, failed in
            guard let self else { return }
            if let succeed {
                // 검색 성공
                var list = succeed
                list.category = .all
                self.saveReviewList(list)
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
                                self.getAllReview(filter, isReload: isReload)
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
