//
//  ReviewModel.swift
//  MoonDuck
//
//  Created by suni on 2/17/25.
//

import Foundation
import UIKit
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
    func writeReview(for review: Review, with images: [UIImage])
    func editReview(for review: Review, with images: [UIImage])
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
    
    func writeReview(for review: Review, with images: [UIImage]) {
        let realmReview = createRealmReview(from: review)
        provider.reviewStorage.add(realmReview)

        guard !images.isEmpty else {
            delegate?.writeReview(self, didSuccess: review)
            return
        }

        ImageManager.shared.saveImages(images: images, reviewID: realmReview.id.stringValue) { [weak self] paths in
            self?.updateReview(with: realmReview, paths: paths, review: review)
        }
    }
    
    private func createRealmReview(from review: Review) -> RealmReview {
        let realmReview = RealmReview()
        realmReview.rating = review.rating
        realmReview.categoryKey = review.category.apiKey
        realmReview.programTitle = review.program.title
        realmReview.programSubTitle = review.program.subInfo
        realmReview.title = review.title
        realmReview.link = review.link ?? ""
        realmReview.content = review.content
        return realmReview
    }
    
    private func updateReview(with realmReview: RealmReview, paths: [String], review: Review) {
        Log.info("✅ 저장된 이미지 경로: \(paths)")
        provider.reviewStorage.updateImages(for: realmReview, with: paths) { [weak self] isSuccess in
            guard let self else { return }
            if isSuccess {
                delegate?.writeReview(self, didSuccess: review)
            } else {
                delegate?.didFailToWriteReview(self)
            }
        }
    }
    
    func editReview(for review: Review, with images: [UIImage]) {
        guard let id = review.id else { return }
        
        let realmReview = createRealmReview(from: review)
        realmReview.id = id
        realmReview.modifiedAt = Date()

        guard !images.isEmpty else {
            updateReview(with: realmReview, paths: [], review: review)
            return
        }

        ImageManager.shared.saveImages(images: images, reviewID: id.stringValue) { [weak self] paths in
            guard let self else { return }
            applyImagePaths(to: realmReview, with: paths)
            updateReview(with: realmReview, paths: paths, review: review)
        }
    }
    
    private func applyImagePaths(to realmReview: RealmReview, with paths: [String]) {
        let imageKeys = [\RealmReview.image1, \.image2, \.image3, \.image4, \.image5]
        
        for (index, keyPath) in imageKeys.enumerated() {
            realmReview[keyPath: keyPath] = paths.indices.contains(index) ? paths[index] : ""
        }
    }

}
