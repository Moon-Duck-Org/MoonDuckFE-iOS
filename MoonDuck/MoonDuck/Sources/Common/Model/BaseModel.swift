//
//  BaseModel.swift
//  MoonDuck
//
//  Created by suni on 7/25/24.
//

import Foundation

protocol BaseModelDelegate: AnyObject {
    func error(didRecieve error: APIError?)
}

protocol BaseModelType: AnyObject {
    
}
