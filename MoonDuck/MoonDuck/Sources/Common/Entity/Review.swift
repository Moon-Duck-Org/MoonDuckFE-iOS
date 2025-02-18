//
//  Review.swift
//  MoonDuck
//
//  Created by suni on 2/18/25.
//

import RealmSwift

struct Review {
    var id: ObjectId?
    var rating: Int
    
    var createdAt: String
    
    var category: Category
    var program: Program
    
    var title: String
    var link: String?
    var content: String
    var imageUrlList: [String]
    
    init(id: ObjectId?, rating: Int, createdAt: String, category: Category, program: Program, title: String, link: String?, content: String, imageUrlList: [String]) {
        self.id = id
        self.rating = rating
        self.createdAt = createdAt
        self.category = category
        self.program = program
        self.title = title
        self.link = link
        self.content = content
        self.imageUrlList = imageUrlList
    }
    
    init(realm: RealmReview) {
        self.id = realm.id
        self.rating = realm.rating
        self.createdAt = realm.createdAt.formatted("yyyy-MM-dd")
        self.category = Category(rawValue: realm.categoryKey) ?? .none
        self.program = Program(category: self.category, title: realm.programTitle, subTitle: realm.programSubTitle)
        self.title = realm.title
        self.link = realm.link
        self.content = realm.content
        self.imageUrlList = [realm.image1, realm.image2, realm.image3, realm.image4, realm.image5].filter { $0.isNotEmpty }
    }
}
