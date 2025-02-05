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
import AppTrackingTransparency
import AdSupport
import FirebaseAnalytics

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
    
    static func getCurrentKSTTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    static func openSafariViewController(urlString: String) {
        let viewController = Navigator.default.root
        
        guard let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url) else {
            AnalyticsService.shared.logEvent(.FAIL_REVIEW_LINK_MOVE, parameters: [.REVIEW_LINK: urlString])
            
            viewController.showToast(message: L10n.Localizable.Error.linkMessage)
            return
        }
        
        if url.scheme == "http" || url.scheme == "https" {
            AnalyticsService.shared.logEvent(.SUCCESS_REVIEW_LINK_MOVE, parameters: [.REVIEW_LINK: urlString])
            
            let safariViewController = SFSafariViewController(url: url)
            DispatchQueue.main.async {
                viewController.present(safariViewController, animated: true, completion: nil)
            }
        } else {
            AnalyticsService.shared.logEvent(.FAIL_REVIEW_LINK_MOVE, parameters: [.REVIEW_LINK: urlString])
            
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
    
    static func moveAppStore() {
        if let appStoreURL = URL(string: "https://apps.apple.com/app/\(Constants.appStoreId)") {
            DispatchQueue.main.async {
                UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    static func moveAppReviewInStore() {
        if let appStoreURL = URL(string: "https://apps.apple.com/app/\(Constants.appStoreId)?action=write-review") {
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
    
    enum AppVersionKey: String {
        case forceUpdateVersion
        case latestUpdateVersion
        
        func getKey() -> String {
        #if DEBUG
            return self.rawValue + "_dev"
        #else
            return self.rawValue
        #endif
        }
    }
    
    static func checkForUpdate(completion: @escaping (_ update: AppUpdate, _ storeVersion: String?) -> Void) {
        guard let remoteConfig else {
            completion(.none, nil)
            return
        }
        // Remote Config 값 가져오기
        remoteConfig.fetch { status, error -> Void in
            if error != nil {
                // 실패
                completion(.none, nil)
            }
            if status == .success {
                remoteConfig.activate { _, error in
                    if error != nil {
                        // 실패
                        completion(.none, nil)
                    }
                    
                    // 값을 사용할 수 있습니다.
                    let forceVersion = remoteConfig[AppVersionKey.forceUpdateVersion.getKey()].stringValue
                    let latestVersion = remoteConfig[AppVersionKey.latestUpdateVersion.getKey()].stringValue
                    let currentVersion = Constants.appVersion
                    
                    let currentComponents = currentVersion.split(separator: ".").map { Int($0) ?? 0 }
                    
                    // 강제 업데이트 확인
                    let forceComponents = forceVersion.split(separator: ".").map { Int($0) ?? 0 }
                    
                    for index in 0..<max(currentComponents.count, forceComponents.count) {
                        let current = index < currentComponents.count ? currentComponents[index] : 0
                        let new = index < forceComponents.count ? forceComponents[index] : 0
                        
                        if current < new {
                            // 강제 업데이트 필요
                            completion(.forceUpdate, forceVersion)
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
                            completion(.latestUpdate, latestVersion)
                            return
                        }
                    }
                    
                    completion(.none, latestVersion)
                }
            } else {
                // 실패
                completion(.none, nil)
            }
        }
    }
    
    static func showSystemShare(_ viewController: UIViewController, url: URL) {
        DispatchQueue.main.async {
            // UIActivityViewController 생성
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            
            // iPad에서 UIActivityViewController가 크래시되지 않도록 처리
            activityViewController.popoverPresentationController?.sourceView = viewController.view
            
            // UIActivityViewController를 화면에 표시
            viewController.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    static func isJailbroken() -> Bool {
        #if targetEnvironment(simulator)
        // 시뮬레이터에서는 탈옥 확인을 하지 않습니다.
        return false
        #else
        // 탈옥된 디바이스에서 발견될 수 있는 경로들
        let jailbreakFilePaths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/private/var/lib/apt/",
            "/private/var/stash"
        ]
        
        // 탈옥 관련 파일 존재 여부 확인
        for path in jailbreakFilePaths where FileManager.default.fileExists(atPath: path) {
            return true
        }
        
        // 시스템 디렉토리에 쓰기 권한 테스트
        let testPath = "/private/jailbreakTest.txt"
        do {
            try "This is a test.".write(toFile: testPath, atomically: true, encoding: .utf8)
            // 쓰기 성공 시 탈옥된 것으로 간주
            try FileManager.default.removeItem(atPath: testPath)
            return true
        } catch {
            // 쓰기 실패 시 탈옥되지 않은 것으로 간주
        }
        
        // Cydia URL Scheme 확인
        if let cydiaUrl = URL(string: "cydia://package/com.example.package"), UIApplication.shared.canOpenURL(cydiaUrl) {
            return true
        }
        
        return false
        #endif
    }
    
    static func requestAppReview() {
        let maxRequestCount = 2
        let currentCount = AppUserDefaults.getObject(forKey: .appReviewRequestCount) as? Int ?? 0
        
        guard currentCount < maxRequestCount else {
            return
        }
        
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
                
                AppUserDefaults.set(currentCount + 1, forKey: .appReviewRequestCount)
            }
        }
    } 
    
    static func requestTrackingAuthorization(completion: @escaping () -> Void) {
        ATTrackingManager.requestTrackingAuthorization { status in
            let isShowRequestIDAFAuth = AppUserDefaults.getObject(forKey: .isShowRequestIDAFAuth)
            switch status {
            case .authorized:
                Log.debug("requestTrackingAuthorization authorized")
                if !(isShowRequestIDAFAuth as? Bool ?? false) {
                    AnalyticsService.shared.logEvent(.TAP_PERMISSION_IDAF_YES)
                    AppUserDefaults.set(true, forKey: .isShowRequestIDAFAuth)
                }
                Analytics.setAnalyticsCollectionEnabled(true)
                completion()
            case.denied:
                Log.debug("requestTrackingAuthorization denied")
                if !(isShowRequestIDAFAuth as? Bool ?? false) {
                    AnalyticsService.shared.logEvent(.TAP_PERMISSION_IDAF_NO)
                    AppUserDefaults.set(true, forKey: .isShowRequestIDAFAuth)
                }
                Analytics.setAnalyticsCollectionEnabled(false)
                completion()
            case.notDetermined:
                Log.debug("requestTrackingAuthorization notDetermined")
                Utils.retryRequestTrackingPermission(completion: completion)
            case.restricted:
                Log.debug("requestTrackingAuthorization restricted")
                Analytics.setAnalyticsCollectionEnabled(false)
                completion()
            default:
                Log.debug("requestTrackingAuthorization default")
                Analytics.setAnalyticsCollectionEnabled(false)
                completion()
            }
        }
    }
    
    static func retryRequestTrackingPermission(completion: @escaping () -> Void) {
        // 권한이 아직 결정되지 않은 상태
        ATTrackingManager.requestTrackingAuthorization { status in
            let isShowRequestIDAFAuth = AppUserDefaults.getObject(forKey: .isShowRequestIDAFAuth)
            switch status {
            case .authorized:
                Log.debug("requestTrackingAuthorization authorized")
                if !(isShowRequestIDAFAuth as? Bool ?? false) {
                    AnalyticsService.shared.logEvent(.TAP_PERMISSION_IDAF_YES)
                    AppUserDefaults.set(true, forKey: .isShowRequestIDAFAuth)
                }
                Analytics.setAnalyticsCollectionEnabled(true)
            case .denied:
                Log.debug("requestTrackingAuthorization denied")
                if !(isShowRequestIDAFAuth as? Bool ?? false) {
                    AnalyticsService.shared.logEvent(.TAP_PERMISSION_IDAF_NO)
                    AppUserDefaults.set(true, forKey: .isShowRequestIDAFAuth)
                }
                Analytics.setAnalyticsCollectionEnabled(false)
            case .restricted, .notDetermined:
                Log.debug("requestTrackingAuthorization not authorized")
                Analytics.setAnalyticsCollectionEnabled(false)
            @unknown default:
                Analytics.setAnalyticsCollectionEnabled(false)
            }
            completion()
        }
    }
    
}
