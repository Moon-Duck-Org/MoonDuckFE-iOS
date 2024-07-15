//
//  Utils.swift
//  MoonDuck
//
//  Created by suni on 6/25/24.
//

import Foundation
import UIKit

import SafariServices
import Kingfisher
import FirebaseRemoteConfig
import StoreKit

class Utils {
    static func getToday() -> String {
        return Date().formatted("yyyy년 MM월 dd일")
    }
    
    static func getNow() -> Date {
        let now = Date()
        let timeZone = TimeZone.current
        let secondsFromGMT = timeZone.secondsFromGMT(for: now)
        
        guard let date = Calendar.current.date(byAdding: .second, value: secondsFromGMT, to: now) else {
            return now
        }
        
        return date
    }
    
    static func formattedDate(createdAt date: String) -> String {
        let splitDate = date.split(separator: "T")
        if splitDate.count > 0 {
            let dateStr = String(splitDate[0]).split(separator: "-")
            if dateStr.count > 2 {
                let (year, month, day) = (dateStr[0], dateStr[1], dateStr[2])
                return "\(year)년 \(month)월 \(day)일"
            }
        }
        return date
    }
    
    static func openSafariViewController(urlString: String) {
        let viewController = Navigator.default.root
        
        guard let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url) else {
            viewController.showToast(message: L10n.Localizable.Error.linkMessage)
            return
        }
        
        if url.scheme == "http" || url.scheme == "https" {
            let safariViewController = SFSafariViewController(url: url)
            DispatchQueue.main.async {
                viewController.present(safariViewController, animated: true, completion: nil)
            }
        } else {
            viewController.showToast(message: L10n.Localizable.Error.linkMessage)
        }
    }
    
    static func downloadImage(from url: URL, completion: @escaping (UIImage) -> Void) {
        let downloader = KingfisherManager.shared.downloader

        downloader.downloadImage(with: url, options: nil) { result in
            switch result {
            case .success(let value):
                // 성공적으로 이미지를 다운로드한 경우 UIImage를 반환
                completion(value.image)
            case .failure(let error):
                // 에러 처리
                Log.error("Error downloading image: \(error)")
                completion(Asset.Assets.imageEmpty.image)
            }
        }
    }
    
    static var appVersion: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    static var appName: String {
        if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            return appName
        } else {
            return L10n.Localizable.appName
        }
    }
    
    static func moveAppStore() {
        if let appStoreURL = URL(string: "https://apps.apple.com/app/id6502997117") {
            DispatchQueue.main.async {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    static func moveAppSetting() {
        if let appSetting = URL(string: UIApplication.openSettingsURLString) {
            DispatchQueue.main.async {
                UIApplication.shared.open(appSetting, options: [:], completionHandler: nil)
            }            
        }
    }
    
    static var remoteConfig: RemoteConfig?
    
    static func initConfig() {
        if remoteConfig == nil {
            remoteConfig = RemoteConfig.remoteConfig()
            // 개발 모드에서는 신속한 테스트를 위해 최소 페치 간격을 설정합니다.
            let settings = RemoteConfigSettings()
            settings.minimumFetchInterval = 0
            remoteConfig?.configSettings = settings
            
            // 디폴트 값 설정 (옵션)
            remoteConfig?.setDefaults(fromPlist: "RemoteConfigDefaults")
        }
    }
    
    enum AppUpdate {
        case forceUpdate
        case latestUpdate
        case none
    }
    
    static func checkForUpdate(completion: @escaping (AppUpdate) -> Void) {
        guard let remoteConfig else {
            completion(.none)
            return
        }
        // Remote Config 값 가져오기
        remoteConfig.fetch { status, error -> Void in
            if error != nil {
                // 실패
                completion(.none)
            }
            if status == .success {
                remoteConfig.activate { _, error in
                    if error != nil {
                        // 실패
                        completion(.none)
                    }
                    
                    // 값을 사용할 수 있습니다.
                    let forceVersion = remoteConfig["forceUpdateVersion"].stringValue ?? "1.0.0"
                    let latestVersion = remoteConfig["latestUpdateVersion"].stringValue ?? "1.0.0"
                    let currentVersion = Utils.appVersion ?? "1.0.0"
                    
                    let currentComponents = currentVersion.split(separator: ".").map { Int($0) ?? 0 }
                    
                    // 강제 업데이트 확인
                    let forceComponents = forceVersion.split(separator: ".").map { Int($0) ?? 0 }
                    
                    for index in 0..<max(currentComponents.count, forceComponents.count) {
                        let current = index < currentComponents.count ? currentComponents[index] : 0
                        let new = index < forceComponents.count ? forceComponents[index] : 0
                        
                        if current < new {
                            // 강제 업데이트 필요
                            completion(.forceUpdate)
                            return
                        }
                    }
                    
                    // 최선 업데이트 확인
                    let latestComponents = latestVersion.split(separator: ".").map { Int($0) ?? 0 }
                    
                    for index in 0..<max(currentComponents.count, latestComponents.count) {
                        let current = index < currentComponents.count ? currentComponents[index] : 0
                        let new = index < latestComponents.count ? latestComponents[index] : 0
                        
                        if current < new {
                            // 최신 업데이트 확인
                            completion(.latestUpdate)
                            return
                        }
                    }
                    
                    completion(.none)
                }
            } else {
                // 실패
                completion(.none)
            }
        }
    }
    
    static func requestReview() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}
