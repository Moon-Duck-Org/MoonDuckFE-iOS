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
    @Persisted var rating: Int = 0
    
    @Persisted var createdAt: Date = Date()
    @Persisted var modifiedAt: Date = Date()
    
    @Persisted var categoryKey: String = ""
    
    @Persisted var programTitle: String = ""
    @Persisted var programSubTitle: String = ""
    
    @Persisted var title: String = ""
    @Persisted var link: String = ""
    @Persisted var content: String = ""
    @Persisted var image1: String = ""
    @Persisted var image2: String = ""
    @Persisted var image3: String = ""
    @Persisted var image4: String = ""
    @Persisted var image5: String = ""
}
