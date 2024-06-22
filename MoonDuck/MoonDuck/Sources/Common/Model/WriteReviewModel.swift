//
//  WriteReviewModel.swift
//  MoonDuck
//
//  Created by suni on 6/20/24.
//

import Foundation

protocol WriteReviewModelDelegate: AnyObject {
    func writeReview(_ model: WriteReviewModel, didSuccess isSuccess: Bool)
    func writeReview(_ model: WriteReviewModel, didRecieve error: Error?)
    
}
protocol WriteReviewModelType: AnyObject {
    
}

class WriteReviewModel: WriteReviewModelType {
    
}
