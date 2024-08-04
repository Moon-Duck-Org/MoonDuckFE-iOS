//
//  AppDelegate.swift
//  MoonDuck
//
//  Created by suni on 5/22/24.
//

import UIKit

import FirebaseCore
import KakaoSDKCommon
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        KakaoSDK.initSDK(appKey: Constants.kakaoAppKey)
        
        incrementAppOpenCount()
        
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    private func handleNotification(userInfo: [AnyHashable: Any]) {
        // 푸시 노티피케이션을 통해 앱이 열릴 때 로그 전송
        AnalyticsService.shared.logEvent(.OPEN_PUSH, parameters: [
            .TIME_STAMP: Utils.getCurrentKSTTimestamp()
        ])
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        handleNotification(userInfo: userInfo)
        completionHandler()
    }
}

extension AppDelegate {
    func application(
        _ app: UIApplication,
        open url: URL, 
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        if url.scheme == Constants.appScheme {
            return true
        }
        
        var handled: Bool        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            // Handle other custom URL types.
            return true
        }
        
        // If not handled by this app, return false.
        return false
    }
    
    private func incrementAppOpenCount() {
        let currentCount = AppUserDefaults.getObject(forKey: .appOpenCount) as? Int ?? 0
        let newCount = currentCount + 1
        AppUserDefaults.set(newCount, forKey: .appOpenCount)
        
        if newCount == 5 {
            Utils.requestAppReview()
        }
    }
}
