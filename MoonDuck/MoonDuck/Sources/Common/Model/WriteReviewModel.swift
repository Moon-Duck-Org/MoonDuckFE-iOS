//
//  WriteReviewModel.swift
//  MoonDuck
//
//  Created by suni on 6/20/24.
//

import Foundation

protocol WriteReviewModelDelegate: AnyObject {
    func writeReview(_ model: WriteReviewModel, didSuccess isSuccess: Bool)
    
}
protocol WriteReviewModelType: AnyObject {
    
}

class WriteReviewModel: WriteReviewModelType {
    
}
