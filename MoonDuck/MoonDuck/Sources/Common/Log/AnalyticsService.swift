//
//  AnalyticsService.swift
//  MoonDuck
//
//  Created by suni on 8/2/24.
//

import Foundation

import FirebaseAnalytics

class AnalyticsService {
    static let shared = AnalyticsService()
    // swiftlint:disable identifier_name
    enum EventName: String {
        // APP
        case OPEN_APP_PUSH
        case OPEN_APP
        case OPEN_APP_DEEPLINK
        case TAP_PERMISSION_PUSH_YES
        case TAP_PERMISSION_PUSH_NO
        case TAP_PERMISSION_IDAF_YES
        case TAP_PERMISSION_IDAF_NO
        case TAP_UPDATE_GO
        case TAP_UPDATE_LATER
        case ALERT_ERROR_NETWORK
        case ALERT_ERROR_SYSTEM
        case FAIL_API
        
        // LOGIN
        case VIEW_LOGIN
        case SUCCESS_LOGIN_NEW
        case SUCCESS_LOGIN
        case FAIL_LOGIN
        case TAP_LOGOUT
        case SUCCESS_LOGOUT
        case FAIL_LOGOUT
        
        // MY
        case VIEW_MY
        case SUCCESS_NICKNAME_SETTING
        case FAIL_NICKNAME_SETTING_INVALID
        
        // SETTING
        case VIEW_SETTING
        case TAP_SETTING_PUSH_ON
        case TAP_SETTING_PUSH_OFF
        case TAP_CONTRACTUS
        case SUCCESS_CONTRACTUS
        case TAP_APPREVIEW_GO
        case TAP_WITHDRAW
        case SUCCESS_WITHDRAW
        case FAIL_WITHDRAW
        case FAIL_APPLE_LOGIN_AUTH
        
        // HOME
        case VIEW_HOME
        case TAP_HOME_CATEGORY
        case TAP_HOME_SORT
        case TAP_HOME_REVIEW_EDIT
        case TAP_HOME_REVIEW_SHARE
        case TAP_HOME_REVIEW_DELETE
        case TAP_HOME_REVIEW_LINK
        case SUCCESS_REVIEW_SHARE
        case SUCCESS_REVIEW_DELETE
        case FAIL_REVIEW_DELETE
        case SUCCESS_REVIEW_LINK_MOVE
        case FAIL_REVIEW_LINK_MOVE
        
        // WRITE REVIEW (SELECT CATEGORY)
        case VIEW_WRITE_REVIEW_CATEGORY
        
        // WRITE REVIEW (SEARCH PROGRAM)
        case VIEW_SEARCH_PROGRAM_MOVIE
        case TAP_SEARCH_PROGRAM_MOVIE
        case SUCCESS_SEARCH_PROGRAM_MOVIE
        case FAIL_SEARCH_PROGRAM_MOVIE
        case TAP_SEARCH_PROGRAM_MOVIE_USERINPUT
        case TAP_SEARCH_PROGRAM_MOVIE_INPUT
        case VIEW_SEARCH_PROGRAM_DRAMA
        case TAP_SEARCH_PROGRAM_DRAMA
        case SUCCESS_SEARCH_PROGRAM_DRAMA
        case FAIL_SEARCH_PROGRAM_DRAMA
        case TAP_SEARCH_PROGRAM_DRAMA_USERINPUT
        case TAP_SEARCH_PROGRAM_DRAMA_INPUT
        case VIEW_SEARCH_PROGRAM_BOOK
        case TAP_SEARCH_PROGRAM_BOOK
        case SUCCESS_SEARCH_PROGRAM_BOOK
        case FAIL_SEARCH_PROGRAM_BOOK
        case TAP_SEARCH_PROGRAM_BOOK_USERINPUT
        case TAP_SEARCH_PROGRAM_BOOK_INPUT
        case VIEW_SEARCH_PROGRAM_CONCERT
        case TAP_SEARCH_PROGRAM_CONCERT
        case SUCCESS_SEARCH_PROGRAM_CONCERT
        case FAIL_SEARCH_PROGRAM_CONCERT
        case TAP_SEARCH_PROGRAM_CONCERT_USERINPUT
        case TAP_SEARCH_PROGRAM_CONCERT_INPUT
        
        // WRITE REVIEW (NEW)
        case VIEW_WRITE_REVIEW
        case TAP_WRITE_REIVEW_COMPLETE
        case SUCCESS_WRITE_REIVEW
        case FAIL_WRITE_REVIEW
        case TOAST_WRITE_REVIEW_EMPTY_TITLE
        case TOAST_WRITE_REVIEW_EMPTY_CONTENT
        case TOAST_WRITE_REVIEW_EMPTY_RATING
        
        // WRITE REVIEW (EDIT)
        case VIEW_EDIT_REIVEW
        case TAP_EDIT_REIVEW_COMPLETE
        case SUCCESS_EDIT_REIVEW
        case FAIL_EDIT_REVIEW
        
        // REVIEW DETAIL
        case VIEW_REVIEW_DETAIL
        case TAP_DETAIL_REVIEW_EDIT
        case TAP_DETAIL_REVIEW_SHARE
        case TAP_DETAIL_REVIEW_DELETE
    }
    
    enum EventParameter: String {
        case API_TYPE
        case API_URL
        case API_METHOD
        case ERROR_CODE
        case ERROR_MESSAGE
        case TIME_STAMP
        case SNS_TYPE
        case REVIEW_COUNT
        case IS_PUSH
        case NICKNAME
        case APP_VERSION
        case AUTH_TYPE
        case CATEGORY_TYPE
        case SORT_TYPE
        case SHARE_URL
        case REVIEW_ID
        case REVIEW_LINK
        case PROGRAM_NAME
        case PROGRAM_TOTAL_COUNT
        case IS_REVIEW_LINK
        case REVIEW_IMAGE_COUNT
    }
    // swiftlint:enable identifier_name
    
    private let errorEventNames: Set<EventName> = [
        .FAIL_API,
        .FAIL_LOGIN,
        .FAIL_LOGOUT,
        .FAIL_WITHDRAW,
        .FAIL_APPLE_LOGIN_AUTH,
        .FAIL_REVIEW_DELETE,
        .FAIL_SEARCH_PROGRAM_MOVIE,
        .FAIL_SEARCH_PROGRAM_DRAMA,
        .FAIL_SEARCH_PROGRAM_BOOK,
        .FAIL_SEARCH_PROGRAM_CONCERT,
        .FAIL_WRITE_REVIEW,
        .FAIL_EDIT_REVIEW,
        .FAIL_REVIEW_DELETE
    ]
    
    // 이벤트 로깅 메서드
    func logEvent(_ event: EventName, parameters: [EventParameter: Any]? = nil) {
        if let parameters {
            var fullParameters = parameters
             
             // 오류 이벤트의 경우 기본 파라미터 추가
             if errorEventNames.contains(event) {
                 fullParameters[.ERROR_CODE] = fullParameters[.ERROR_CODE] ?? ""
                 fullParameters[.ERROR_MESSAGE] = fullParameters[.ERROR_MESSAGE] ?? ""
                 fullParameters[.TIME_STAMP] = fullParameters[.TIME_STAMP] ?? Utils.getCurrentKSTTimestamp()
             }
             
             let params = fullParameters.reduce(into: [String: Any]()) { result, param in
                 result[param.key.rawValue] = param.value
             }
             
            Log.debug("Analytics.logEvent - \(event.rawValue) : \(params)")
             Analytics.logEvent(event.rawValue, parameters: params)
        } else {
            Log.debug("Analytics.logEvent - \(event.rawValue)")
            Analytics.logEvent(event.rawValue, parameters: nil)
        }
    }
}
