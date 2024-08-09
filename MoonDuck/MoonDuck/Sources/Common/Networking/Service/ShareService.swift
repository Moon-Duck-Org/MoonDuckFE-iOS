//
//  ShareService.swift
//  MoonDuck
//
//  Created by suni on 7/15/24.
//

import Foundation

class ShareService {
    func getShareUrl(request: GetShareUrlRequest, completion: @escaping (_ succeed: String?, _ failed: APIError?) -> Void) {
        MoonDuckAPI.getShareUrl(request).performRequest(responseType: GetShareUrlResponse.self, completion: {  result in
            switch result {
            case .success(let response):
                completion(response.toDomain(), nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }
}
