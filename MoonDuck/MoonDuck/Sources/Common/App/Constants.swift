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
    
    static let signInAppleKeyId: String = Bundle.main.object(forInfoDictionaryKey: "SignInAppleKeyId") as? String ?? ""
    static let teamId: String = Bundle.main.object(forInfoDictionaryKey: "TeamId") as? String ?? ""
    
    static var appBundleId: String {
        return Bundle.main.bundleIdentifier ?? "com.poduck.moonduck"
    }
    
    static var appName: String {
        if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return appName
        } else {
            return L10n.Localizable.appName
        }
    }
    
    static var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.1"
    }
}
