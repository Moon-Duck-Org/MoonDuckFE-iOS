//
//  AppNotification.swift
//  MoonDuck
//
//  Created by suni on 7/11/24.
//

import Foundation

import UserNotifications

class AppNotification {
    static let `default` = AppNotification()
    
    // Notification 권한 요청
    func requestNotificationAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                Log.error("Error requesting notification access: \(error)")
                completion(false)
                return
            }
            completion(granted)
        }
    }
    
    func checkNotificationSettings(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion(settings.authorizationStatus == .authorized)
        }
    }
    
    // 기존 알림 제거 및 새로운 알림 설정
    func resetAndScheduleNotification(with nickname: String) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        scheduleRepeatingNotification(with: nickname)
    }
    
    func scheduleRepeatingNotification(with nickname: String) {
        // Notification 콘텐츠 생성
        let content = UNMutableNotificationContent()
        content.title = L10n.Localizable.Push.title
        
        let messages = [L10n.Localizable.Push.messageType1(nickname),
                        L10n.Localizable.Push.messageType2(nickname)]
        content.body = messages.randomElement() ?? messages[0]
        content.sound = .default

        // 날짜 컴포넌트 설정
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 0

        // Trigger 설정 - 10일마다 반복
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        // Notification 요청 생성
        let identifier = "RemindNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        // Notification 요청 추가
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                Log.error("Error adding notification request: \(error)")
            }
        }
    }
}
