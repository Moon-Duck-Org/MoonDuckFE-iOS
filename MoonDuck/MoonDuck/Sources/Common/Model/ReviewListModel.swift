//
//  ReviewListModel.swift
//  MoonDuck
//
//  Created by suni on 6/23/24.
//

import Foundation

protocol ReviewListModelDelegate: AnyObject {
    func reviewList(_ model: ReviewListModelType, didSuccess list: ReviewList)
    func reviewList(_ model: ReviewListModelType, didRecieve error: APIError?)
    func reviewList(_ model: ReviewListModelType, didDelete review: Review)
    func reviewList(_ model: ReviewListModelType, didAync list: ReviewList)
}
protocol ReviewListModelType: AnyObject {
    // Data
    var delegate: ReviewListModelDelegate? { get set }
    
    func numberOfReviews(with category: Category) -> Int
    func review(with category: Category, at index: Int) -> Review?
    func reviewList(with category: Category) -> ReviewList?
    
    // Logic
    
    // Networking
    func loadReviews(with category: Category, filter: Sort)
    func reloadReviews(with category: Category, filter: Sort)
    func deleteReview(for review: Review)
    func syncReviewList(with category: Category, review: Review)
}

class ReviewListModel: ReviewListModelType {
    
    struct Config {
        let defaultSize: Int = 10
    }
    
    private let config: Config = Config()
    private let provider: AppServices
    
    init(_ provider: AppServices) {
        self.provider = provider
    }
    
    // MARK: - Data
    weak var delegate: ReviewListModelDelegate?
    
    private var isLoading: Bool = false
    private var reviewLists: [ReviewList] = []
    
    func numberOfReviews(with category: Category) -> Int {
        return reviews(with: category).count
    }
    
    func review(with category: Category, at index: Int) -> Review? {
        let reviews = reviews(with: category)
        if index < reviews.count {
            return reviews[index]
        }
        return nil
    }
    
    func reviewList(with category: Category) -> ReviewList? {
        return reviewLists.first(where: { $0.category == category })
    }
    
    private func reviews(with category: Category) -> [Review] {
        if let reviewList = reviewList(with: category) {
            return reviewList.reviews
        }
        return []
    }
    
    private func reviewListIndex(with category: Category) -> Int? {
        return reviewLists.firstIndex(where: { $0.category == category })
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
            delegate?.reviewList(self, didSuccess: reviewLists[findIndex])
        } else {
            reviewLists.append(list)
            delegate?.reviewList(self, didSuccess: list)
        }
    }
}

// MARK: - Networking
extension ReviewListModel {
    func loadReviews(with category: Category, filter: Sort) {
        guard !isLoading else { return }
        
        var offset: Int = 0
        let size: Int = config.defaultSize
        
        if let list = reviewList(with: category) {
            if list.isLast {
                self.delegate?.reviewList(self, didRecieve: nil)
                return
            }
            offset = list.currentPage + 1
        }
        
        if category == .all {
            getAllReview(with: filter, offset: offset, size: size)
        } else {
            getReview(with: category, filter: filter, offset: offset, size: size)
        }
    }
    
    func reloadReviews(with category: Category, filter: Sort) {
        guard !isLoading else { return }
        
        let offset: Int = 0
        let size: Int = config.defaultSize
        
        if category == .all {
            getAllReview(with: filter, offset: offset, size: size)
        } else {
            getReview(with: category, filter: filter, offset: offset, size: size)
        }
    }
    
    private func getReview(with category: Category, filter: Sort, offset: Int, size: Int) {
        isLoading = true
        let request = GetReviewRequest(category: category.apiKey, filter: filter.apiKey, offset: offset, size: size)
        provider.reviewService.getReview(request: request) { [weak self] succeed, failed in
            guard let self else { return }
            self.isLoading = false
            if let succeed {
                // 검색 성공
                var list = succeed
                list.category = category
                list.sortOption = filter
                self.saveReviewList(list)
            } else {
                // 오류 발생
                if let code = failed as? APIError {
                    if code.isReviewError {
                        self.delegate?.reviewList(self, didRecieve: code)
                        return
                    } else if code.needsTokenRefresh {
                        AuthManager.default.refreshToken { [weak self] code in
                            guard let self else { return }
                            if code == .success {
                                self.getReview(with: category, filter: filter, offset: offset, size: size)
                            } else {
                                Log.error("Refresh Token Error \(code)")
                                self.delegate?.reviewList(self, didRecieve: .unowned)
                            }
                        }
                        return
                    }
                }
                Log.error(failed?.localizedDescription ?? "Get Review Error")
                self.delegate?.reviewList(self, didRecieve: .unowned)
            }
        }
    }
    
    private func getAllReview(with filter: Sort, offset: Int, size: Int) {
        isLoading = true
        let request = ReviewAllRequest(filter: filter.apiKey, offset: offset, size: size)
        provider.reviewService.reviewAll(request: request) { [weak self]  succeed, failed in
            guard let self else { return }
            self.isLoading = false
            if let succeed {
                // 검색 성공
                var list = succeed
                list.category = .all
                list.sortOption = filter
                self.saveReviewList(list)
            } else {
                // 오류 발생
                if let code = failed as? APIError {
                    if code.isReviewError {
                        self.delegate?.reviewList(self, didRecieve: code)
                        return
                    } else if code.needsTokenRefresh {
                        AuthManager.default.refreshToken { [weak self] code in
                            guard let self else { return }
                            if code == .success {
                                self.getAllReview(with: filter, offset: offset, size: size)
                            } else {
                                Log.error("Refresh Token Error \(code)")
                                self.delegate?.reviewList(self, didRecieve: .unowned)
                            }
                        }
                        return
                    }
                }
                Log.error(failed?.localizedDescription ?? "Get ALL Review Error")
                self.delegate?.reviewList(self, didRecieve: .unowned)
            }
        }
    }
    
    func syncReviewList(with category: Category, review: Review) {
            if category == .all {
                syncGetAllReview(with: review)
            } else {
                syncGetReview(with: category, review: review)
            }
    }
    
    private func syncGetReview(with category: Category, review: Review) {
        guard let listIndex = reviewListIndex(with: category) else { return }
        let list = reviewLists[listIndex]
        
        guard let reviewIndex = list.reviews.firstIndex(where: { $0.id == review.id }) else { return }
        let filter = list.sortOption
        let offset = reviewIndex / config.defaultSize
        let size = config.defaultSize * 2
        
        let request = GetReviewRequest(category: category.apiKey, filter: filter.apiKey, offset: offset, size: size)
        provider.reviewService.getReview(request: request) { [weak self] succeed, failed in
            guard let self else { return }
            if let succeed {
                // 현재 페이지 데이터 갱신
                let startIndex = offset * size
                let endIndex = min(startIndex + size, self.reviewLists[listIndex].reviews.count)
                self.reviewLists[listIndex].updateSync(succeed, startIndex: startIndex)
                self.delegate?.reviewList(self, didAync: self.reviewLists[listIndex])
            } else {
                // 오류 발생
                if let code = failed as? APIError {
                    if code.isReviewError {
                        return
                    } else if code.needsTokenRefresh {
                        AuthManager.default.refreshToken { [weak self] code in
                            guard let self else { return }
                            if code == .success {
                                self.syncGetReview(with: category, review: review)
                            } else {
                                Log.error("Refresh Token Error \(code)")
                            }
                        }
                        return
                    }
                }
                Log.error(failed?.localizedDescription ?? "Get Review Error")
            }
        }
    }
    
    private func syncGetAllReview(with review: Review) {
        guard let listIndex = reviewListIndex(with: .all) else { return }
        let list = reviewLists[listIndex]
        
        guard let reviewIndex = list.reviews.firstIndex(where: { $0.id == review.id }) else { return }
        let filter = list.sortOption
        let offset = reviewIndex / config.defaultSize
        let size = config.defaultSize * 2
        
        let allRequest = ReviewAllRequest(filter: filter.apiKey, offset: offset, size: size)
        provider.reviewService.reviewAll(request: allRequest) { [weak self]  succeed, failed in
            guard let self else { return }
            if let succeed {
                // 현재 페이지 데이터 갱신
                let startIndex = offset * config.defaultSize
                self.reviewLists[listIndex].updateSync(succeed, startIndex: startIndex)
                self.delegate?.reviewList(self, didAync: self.reviewLists[listIndex])
            } else {
                // 오류 발생
                if let code = failed as? APIError {
                    if code.isReviewError {
                        return
                    } else if code.needsTokenRefresh {
                        AuthManager.default.refreshToken { [weak self] code in
                            guard let self else { return }
                            if code == .success {
                                self.syncGetAllReview(with: review)
                            } else {
                                Log.error("Refresh Token Error \(code)")
                            }
                        }
                        return
                    }
                }
                Log.error(failed?.localizedDescription ?? "Get ALL Review Error")
            }
        }
    }
        
    func deleteReview(for review: Review) {
        guard let id = review.id else { return }
        
        let request = DeleteReviewRequest(boardId: id)
        provider.reviewService.deleteReview(request: request) { [weak self] succeed, failed in
            guard let self else { return }
            if let succeed {
                self.delegate?.reviewList(self, didDelete: review)
            } else {
                // 오류 발생
                if let code = failed as? APIError {
                    if code.isReviewError {
                        self.delegate?.reviewList(self, didRecieve: code)
                        return
                    } else if code.needsTokenRefresh {
                        AuthManager.default.refreshToken { [weak self] code in
                            guard let self else { return }
                            if code == .success {
                                self.deleteReview(for: review)
                            } else {
                                Log.error("Refresh Token Error \(code)")
                                self.delegate?.reviewList(self, didRecieve: .unowned)
                            }
                        }
                        return
                    }
                }
                Log.error(failed?.localizedDescription ?? "Get Review Error")
                self.delegate?.reviewList(self, didRecieve: .unowned)
            }
        }
    }
}
