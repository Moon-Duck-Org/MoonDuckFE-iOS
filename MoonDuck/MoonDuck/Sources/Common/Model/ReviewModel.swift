//
//  ReviewModel.swift
//  MoonDuck
//
//  Created by suni on 2/17/25.
//

import Foundation
import RealmSwift

protocol ReviewModelDelegate: AnyObject {
    func getReviews(_ model: ReviewModelType, didSuccess reviews: [Review])
    func getReview(_ model: ReviewModelType, didSuccess review: Review)
    func deleteReview(_ model: ReviewModelType, didSuccess review: Review)
    func writeReview(_ model: ReviewModelType, didSuccess review: Review)
    func editReview(_ model: ReviewModelType, didSuccess review: Review)
    
    func didFailToGetReviews(_ model: ReviewModelType)
    func didFailToGetReview(_ model: ReviewModelType)
    func didFailToDeleteReview(_ model: ReviewModelType)
    func didFailToWriteReview(_ model: ReviewModelType)
    func didFailToEditReview(_ model: ReviewModelType)
}
extension ReviewModelDelegate {
    func getReviews(_ model: ReviewModelType, didSuccess reviews: [Review]) { }
    func getReview(_ model: ReviewModelType, didSuccess review: Review) { }
    func deleteReview(_ model: ReviewModelType, didSuccess review: Review) { }
    func writeReview(_ model: ReviewModelType, didSuccess review: Review) { }
    func editReview(_ model: ReviewModelType, didSuccess review: Review) { }
    
    func didFailToGetReviews(_ model: ReviewModelType) { }
    func didFailToGetReview(_ model: ReviewModelType) { }
    func didFailToDeleteReview(_ model: ReviewModelType) { }
    func didFailToWriteReview(_ model: ReviewModelType) { }
    func didFailToEditReview(_ model: ReviewModelType) { }
}

protocol ReviewModelType: AnyObject {
    // Data
    var delegate: ReviewModelDelegate? { get set }
    
    var reviews: [Review] { get }
    
    func numberOfReviews(with category: Category) -> Int
    func review(at index: Int) -> Review?
    
    // DateBase
    func loadReviews(with category: Category, sort: Sort)
    func getReview(_ id: ObjectId)
    func deleteReview(for review: Review)
    func writeReview(for review: Review)
    func editReview(for review: Review)
}

class ReviewModel: ReviewModelType {
    
    private let provider: AppStorages
    
    init(_ provider: AppStorages) {
        self.provider = provider
    }
    
    private var isLoading: Bool = false
    var reviews: [Review] = []
    
    // MARK: - Data
    weak var delegate: ReviewModelDelegate?
    
    func numberOfReviews(with category: Category) -> Int {
        if category == .all {
            return provider.reviewStorage.count()
        } else {
            return provider.reviewStorage.count(with: category)
        }
    }
    
    func review(at index: Int) -> Review? {
        if index < reviews.count {
            return reviews[index]
        }
        return nil
    }
    
    // MARK: - Logic
    
    // MARK: - DataBase
    func loadReviews(with category: Category, sort: Sort) {
        var realms: [RealmReview] = []
        if category == .all {
            realms = provider.reviewStorage.getAllReviews(sort: sort)
        } else {
            realms = provider.reviewStorage.getReviews(with: category, sort: sort)
        }
        reviews = realms.map { $0.toDomain() }
        delegate?.getReviews(self, didSuccess: reviews)
    }
    
    func getReview(_ id: ObjectId) {
        if let realm = provider.reviewStorage.getReview(for: id) {
            delegate?.getReview(self, didSuccess: realm.toDomain())
        } else {
            delegate?.didFailToGetReview(self)
        }
    }
    
    func deleteReview(for review: Review) {
        guard let id = review.id else { return }
        
        provider.reviewStorage.deleteReview(for: id) { [weak self] isSuccess in
            guard let self else { return }
            if isSuccess {
                self.reviews.removeAll { $0.id == review.id }
                self.delegate?.deleteReview(self, didSuccess: review)
            } else {
                self.delegate?.didFailToDeleteReview(self)
            }
        }
    }
    
    func writeReview(for review: Review) {
        
        let realm = RealmReview()
        realm.rating = review.rating
        realm.categoryKey = review.category.apiKey
        realm.programTitle = review.program.title
        realm.programSubTitle = review.program.subInfo
        realm.title = review.title
        realm.link = review.link ?? ""
        realm.content = review.content
        
        if review.imageUrlList.count > 0 { realm.image1 = review.imageUrlList[0] }
        if review.imageUrlList.count > 1 { realm.image2 = review.imageUrlList[1] }
        if review.imageUrlList.count > 2 { realm.image3 = review.imageUrlList[2] }
        if review.imageUrlList.count > 3 { realm.image4 = review.imageUrlList[3] }
        if review.imageUrlList.count > 4 { realm.image5 = review.imageUrlList[4] }
        
        provider.reviewStorage.add(realm)
        delegate?.writeReview(self, didSuccess: review)
    }
    
    func editReview(for review: Review) {
        guard let id = review.id else { return }
        
        let realm = RealmReview()
        realm.id = id
        realm.rating = review.rating
        realm.title = review.title
        realm.link = review.link ?? ""
        realm.content = review.content
        realm.modifiedAt = Date()
        
        if review.imageUrlList.count > 0 { realm.image1 = review.imageUrlList[0] }
        if review.imageUrlList.count > 1 { realm.image2 = review.imageUrlList[1] }
        if review.imageUrlList.count > 2 { realm.image3 = review.imageUrlList[2] }
        if review.imageUrlList.count > 3 { realm.image4 = review.imageUrlList[3] }
        if review.imageUrlList.count > 4 { realm.image5 = review.imageUrlList[4] }
        
        provider.reviewStorage.update(for: realm) { [weak self] isSuccess in
            guard let self else { return }
            if isSuccess {
                delegate?.editReview(self, didSuccess: review)
            } else {
                delegate?.didFailToEditReview(self)
            }
        }
    }
}
