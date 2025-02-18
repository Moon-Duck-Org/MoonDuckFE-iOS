//
//  ReviewStorage.swift
//  MoonDuck
//
//  Created by suni on 2/13/25.
//

import Foundation
import RealmSwift

class ReviewStorage {
    private let realm: AppRealm = AppRealm.shared
    
    func count(with category: Category) -> Int {
        return realm.fetch(RealmReview.self)?.filter("categoryKey == %@", category.apiKey).count ?? 0
    }
    
    func count() -> Int {
        return realm.fetch(RealmReview.self)?.count ?? 0
    }
    
    func getReview(for id: ObjectId) -> RealmReview? {
        if let review = realm.fetch(RealmReview.self, primaryKey: id) {
            return review
        } else {
            return nil
        }
    }
    
    func getReviews(with category: Category, sort: Sort) -> [RealmReview] {
                        
        switch sort {
        case .latestOrder:
            if let reviews = realm.fetch(RealmReview.self)?.filter("categoryKey == %@", category.apiKey).sorted(byKeyPath: "createdAt", ascending: false) {
                return Array(reviews)
            }
            
        case .ratingOrder:
            if let reviews = realm.fetch(RealmReview.self)?.filter("categoryKey == %@", category.apiKey).sorted(byKeyPath: "rating", ascending: false) {
                return Array(reviews)
            }

        case .oldestFirst:
            if let reviews = realm.fetch(RealmReview.self)?.filter("categoryKey == %@", category.apiKey).sorted(byKeyPath: "createdAt", ascending: true) {
                return Array(reviews)
            }
        }
        
        return []
    }
    
    func getAllReviews(sort: Sort) -> [RealmReview] {
                        
        switch sort {
        case .latestOrder:
            if let reviews = realm.fetch(RealmReview.self)?.sorted(byKeyPath: "createdAt", ascending: false) {
                return Array(reviews)
            }
            
        case .ratingOrder:
            if let reviews = realm.fetch(RealmReview.self)?.sorted(byKeyPath: "rating", ascending: false) {
                return Array(reviews)
            }

        case .oldestFirst:
            if let reviews = realm.fetch(RealmReview.self)?.sorted(byKeyPath: "createdAt", ascending: true) {
                return Array(reviews)
            }
        }
        
        return []
    }
    
    func deleteReview(for id: ObjectId, completion: @escaping (Bool) -> Void) {
        guard let review = realm.fetch(RealmReview.self, primaryKey: id) else {
            completion(false)
            return
        }
        
        realm.delete(object: review) { isSuccess, _ in
            completion(isSuccess)
        }
        
    }
    
    func add(_ review: RealmReview) {
        realm.add(review)
    }
    
    func update(for edit: RealmReview, completion: @escaping (Bool) -> Void) {
        if let review = realm.fetch(RealmReview.self, primaryKey: edit.id) {
            realm.update {
                review.title = edit.title
                review.content = edit.content
                review.rating = edit.rating
                review.modifiedAt = edit.modifiedAt
                review.link = edit.link
                review.image1 = edit.image1
                review.image2 = edit.image2
                review.image3 = edit.image3
                review.image4 = edit.image4
                review.image5 = edit.image5
            } completion: { isSuccess, _ in
                completion(isSuccess)
            }
        } else {
            completion(false)
        }
    }
}
