//
//  RealmReview.swift
//  MoonDuck
//
//  Created by suni on 2/10/25.
//

import Foundation

import RealmSwift

class RealmReview: Object {
    @Persisted(primaryKey: true) var id: ObjectId = ObjectId.generate()
    @objc dynamic var rating: Int = 0
    
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var modifiedAt: Date = Date()
    
    @objc dynamic var categoryKey: String = ""
    
    @objc dynamic var programTitle: String = ""
    @objc dynamic var programSubTitle: String = ""
    
    @objc dynamic var title: String = ""
    @objc dynamic var link: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var image1: String = ""
    @objc dynamic var image2: String = ""
    @objc dynamic var image3: String = ""
    @objc dynamic var image4: String = ""
    @objc dynamic var image5: String = ""
}
