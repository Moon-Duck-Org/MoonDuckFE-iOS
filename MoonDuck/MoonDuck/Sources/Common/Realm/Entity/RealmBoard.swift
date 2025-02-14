//
//  RealmBoard.swift
//  MoonDuck
//
//  Created by suni on 2/10/25.
//

import Foundation

import RealmSwift

class RealmBoard: Object {
    @objc dynamic let boardId: Int = 0
    @objc dynamic var score: Int = 0
    
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var modifiedAt: Date = Date()
    
    @objc dynamic var categoryKey: String = ""
    
    @objc dynamic var programId: Int = 0
    @objc dynamic var programDate: Date = Date()
    @objc dynamic var programGenre: String = ""
    @objc dynamic var programDirector: String = ""
    @objc dynamic var programPublisher: String = ""
    @objc dynamic var programPlace: String = ""
    
    @objc dynamic var title: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var image1: String = ""
    @objc dynamic var image2: String = ""
    @objc dynamic var image3: String = ""
    @objc dynamic var image4: String = ""
    @objc dynamic var image5: String = ""
}
