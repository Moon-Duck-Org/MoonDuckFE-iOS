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
    func reviewList(_ model: ReviewListModelType, didUpdate list: ReviewList)
}
protocol ReviewListModelType: AnyObject {
    // Data
    var delegate: ReviewListModelDelegate? { get set }
    
    func numberOfReviews(with category: Category) -> Int
    func reviews(with category: Category) -> [Review]
    func review(with category: Category, at index: Int) -> Review?
    func reviewList(with category: Category) -> ReviewList?
    
    // Logic
    
    // Networking
    func loadReviews(with category: Category, filter: Sort)
    func reloadReviews(with category: Category, filter: Sort)
    func deleteReview(for review: Review)
    func syncReviewList(with category: Category, filter: Sort)
}

class ReviewListModel: ReviewListModelType {
    
    struct Config {
        let defaultSize: Int = 30
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
            delegate?.reviewList(self, didSuccess: reviewLists[findIndex])
        } else {
            reviewLists.append(list)
            delegate?.reviewList(self, didSuccess: list)
        }
    }
    
    private func removeReview(for review: Review) {
        if let listIndex = reviewLists.firstIndex(where: { $0.category == .all }),
           let reviewIndex = reviewLists[listIndex].reviews.firstIndex(where: { $0.id == review.id }) {
            reviewLists[listIndex].reviews.remove(at: reviewIndex)
        }
        
        if let listIndex = reviewLists.firstIndex(where: { $0.category == review.category }),
           let reviewIndex = reviewLists[listIndex].reviews.firstIndex(where: { $0.id == review.id }) {
            reviewLists[listIndex].reviews.remove(at: reviewIndex)
        }
    }
    
    private func updateReviews(with category: Category, for reviews: [Review]) {
        if let listIndex = reviewLists.firstIndex(where: { $0.category == category }) {
            reviewLists[listIndex].reviews = reviews
        }
    }
    
    // MARK: - Networking
    func loadReviews(with category: Category, filter: Sort) {
        guard !isLoading else { return }
        
        var offset: Int = 0
        var size: Int = config.defaultSize
        
        if let list = reviewList(with: category) {
            if list.isLast {
                self.delegate?.reviewList(self, didRecieve: nil)
                return
            }
            offset = list.currentPage + 1
            size = list.size
        }
        
        if category == .all {
            getAllReview(with: filter, offset: offset, size: size)
        } else {
            getReview(with: category, filter: filter, offset: offset, size: size)
        }
    }
    
    func reloadReviews(with category: Category, filter: Sort) {
        guard !isLoading else { return }
        
        var offset: Int = 0
        var size: Int = config.defaultSize
        
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
    
    func syncReviewList(with category: Category, filter: Sort) {
        guard !isLoading else { return }
        
        if let list = reviewList(with: category) {
            let offset = list.size * list.currentPage
            let size = list.size
            syncGetReview(with: category, filter: filter, offset: offset, size: size)
        }
        
        if let list = reviewList(with: .all) {
            let offset = list.size * list.currentPage
            let size = list.size
            syncGetAllReview(with: filter, offset: offset, size: size)
        }
        
    }
    
    private func syncGetReview(with category: Category, filter: Sort, offset: Int, size: Int) {
        isLoading = true
        let request = GetReviewRequest(category: category.apiKey, filter: filter.apiKey, offset: offset, size: size)
        provider.reviewService.getReview(request: request) { [weak self] succeed, failed in
            guard let self else { return }
            self.isLoading = false
            if let succeed {
                self.updateReviews(with: category, for: succeed.reviews)
            } else {
                // 오류 발생
                if let code = failed as? APIError {
                    if code.isReviewError {
                        return
                    } else if code.needsTokenRefresh {
                        AuthManager.default.refreshToken { [weak self] code in
                            guard let self else { return }
                            if code == .success {
                                self.syncGetReview(with: category, filter: filter, offset: offset, size: size)
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
    
    private func syncGetAllReview(with filter: Sort, offset: Int, size: Int) {
        isLoading = true
        let allRequest = ReviewAllRequest(filter: filter.apiKey, offset: offset, size: size)
        provider.reviewService.reviewAll(request: allRequest) { [weak self]  succeed, failed in
            guard let self else { return }
            self.isLoading = false
            if let succeed {
                // 검색 성공
                self.updateReviews(with: .all, for: succeed.reviews)
            } else {
                // 오류 발생
                if let code = failed as? APIError {
                    if code.isReviewError {
                        return
                    } else if code.needsTokenRefresh {
                        AuthManager.default.refreshToken { [weak self] code in
                            guard let self else { return }
                            if code == .success {
                                self.syncGetAllReview(with: filter, offset: offset, size: size)
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
