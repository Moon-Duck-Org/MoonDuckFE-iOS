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
    
    let confing: Config = Config(
        kakaoAppKey: "115f84135ae908760cadabb7d51a0e26"
    )
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        KakaoSDK.initSDK(appKey: confing.kakaoAppKey)
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
}

extension AppDelegate {
    func application(
        _ app: UIApplication,
        open url: URL, 
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            // Handle other custom URL types.
            return true
        }
        
        // If not handled by this app, return false.
        return false
    }
}
