//
//  AppNotification.swift
//  MoonDuck
//
//  Created by suni on 7/11/24.
//

import Foundation

import UserNotifications

class AppNotification {
    
    // Notification 권한 요청
    static func requestNotificationAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                Log.error("Error requesting notification access: \(error)")
                completion(false)
                return
            }
            completion(granted)
        }
    }
    
    static func getNotificationSettingStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }
    
    static func removeNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // 기존 알림 제거 및 새로운 알림 설정
    static func resetAndScheduleNotification(with nickname: String) {
        removeNotification()
        scheduleRepeatingNotification(with: nickname)
    }
    
    static func scheduleRepeatingNotification(with nickname: String) {
        // Notification 콘텐츠 생성
        let content = UNMutableNotificationContent()
        content.title = L10n.Localizable.Push.title
        
        let messages = [L10n.Localizable.Push.messageType1(nickname),
                        L10n.Localizable.Push.messageType2(nickname)]
        content.body = messages.randomElement() ?? messages[0]
        content.sound = .default
        // 현재 날짜와 시간
        let currentDate = Date()
        let calendar = Calendar.current
        
        let intervalCount = 9
        
        for count in 1...intervalCount {
            // TODO: - 날짜 시간 수정 currentDate -> futureDate 로 수정
            let interval = count * 1
            if let futureDate = calendar.date(byAdding: .day, value: interval, to: currentDate) {
                var dateComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
                dateComponents.hour = 12 // 12 -> 10 수정
                dateComponents.minute = 0
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                let request = UNNotificationRequest(identifier: "notification_\(interval)_days", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        Log.error("알림 요청 추가 중 오류 발생: \(error)")
                    }
                }
            }
        }
    }
}
