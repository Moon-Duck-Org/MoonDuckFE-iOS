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
    
    static let kakaoAppKey: String = "115f84135ae908760cadabb7d51a0e26"
    static let searchMovieKey: String = "31263527c9b0f3dba1f669b2990459c4"
    static let searchConcertKey: String = "4e6e495762687975313031746b705741"
    
    static let termsOfServiceUrl: String = MoonDuckAPI.baseUrl() + "/contract.html"
    static let privacyPolicyUrl: String = MoonDuckAPI.baseUrl() + "/privacy.html"
    static let noticeUrl: String = MoonDuckAPI.baseUrl() + "/notice.html"
    
    static func getSharePath(with boardId: String) -> String {
        return MoonDuckAPI.baseUrl() + "/share/\(boardId)"
    }
}
