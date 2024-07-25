//
//  Constants.swift
//  MoonDuck
//
//  Created by suni on 6/25/24.
//

import Foundation

class Constants {
    static let isDebug: Bool = true
    
    static let appLanguage: String = "ko_KR"
    static let appMail: String = "poduck405@gmail.com"
    static let appScheme: String = "moonduck"
    static let appStoreId: String = "id6502997117"
    
    static let kakaoAppKey: String = Bundle.main.object(forInfoDictionaryKey: "KakaoAppKey") as? String ?? ""
    static let searchMovieKey: String = Bundle.main.object(forInfoDictionaryKey: "SearchMovieApiKey") as? String ?? ""
    static let searchConcertKey: String = Bundle.main.object(forInfoDictionaryKey: "SearchConcertApiKey") as? String ?? ""
    
    static let termsOfServiceUrl: String = MoonDuckAPI.baseUrl() + "/contract.html"
    static let privacyPolicyUrl: String = MoonDuckAPI.baseUrl() + "/privacy.html"
    static let noticeUrl: String = MoonDuckAPI.baseUrl() + "/notice.html"
    
    static func getSharePath(with boardId: String) -> String {
        return MoonDuckAPI.baseUrl() + "/share/\(boardId)"
    }
}
