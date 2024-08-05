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
        case ALERT_PERMISSION_PUSH
        case TAP_PERMISSION_PUSH_YES
        case TAP_PERMISSION_PUSH_NO
        case TAP_PERMISSION_IDAF_YES
        case TAP_PERMISSION_IDAF_NO
        case ALERT_FORCEUPDATE
        case TAP_FORCEUPDATE_GO
        case ALERT_UPDATE
        case TAP_UPDATE_GO
        case TAP_UPDATE_LATER
        case ALERT_ERROR_NETWORK
        case ALERT_ERROR_SYSTEM
        case ALERT_JALIBROKEN
        case ALERT_REQUEST_APPREVIEW
        case FAIL_API
        
        // LOGIN
        case VIEW_LOGIN
        case SUCCESS_LOGIN_NEW
        case SUCCESS_LOGIN
        case FAIL_LOGIN
        case ALERT_LOGOUT
        case TAP_LOGOUT
        case SUCCESS_LOGOUT
        case FAIL_LOGOUT
        
        // MY
        case VIEW_MY
        case TAP_NICKNAME_SETTING
        case SUCCESS_NICKNAME_SETTING
        case FAIL_NICKNAME_SETTING_INVALID
        case FAIL_NICKNAME_SETTING
        
        // SETTING
        case VIEW_SETTING
        case TAP_SETTING_PUSH_ON
        case TAP_SETTING_PUSH_OFF
        case VIEW_TERMSOFSERVICE
        case VIEW_PRIVACY
        case TAP_CONTRACTUS
        case SUCCESS_CONTRACTUS
        case FAIL_CONTRACTUS
        case TAP_APPREVIEW_GO
        case VIEW_APPVERSION
        case TAP_APPVERSION_UPDATE_GO
        case VIEW_NOTICE
        case VIEW_WITHDRAW
        case TAP_WITHDRAW_CANCEL
        case TAP_WITHDRAW
        case SUCCESS_WITHDRAW
        case FAIL_WITHDRAW
        case FAIL_APPLE_LOGIN_AUTH
        
        // HOME
        case VIEW_HOME
        case TAP_HOME_CATEGORY
        case TAP_HOME_SORT
        case SUCCESS_REVIEW_LIST
        case FAIL_REVIEW_LIST
        case ALERT_HOME_REVIEW_OPTION
        case TAP_HOME_REVIEW_EDIT
        case TAP_HOME_REVIEW_SHARE
        case SUCCESS_HOME_REVIEW_SHARE
        case FAIL_HOME_REVIEW_SHARE
        case SUCCESS_HOME_REVIEW_DELETE
        case FAIL_HOME_REVIEW_DELETE
        case TAP_HOME_REVIEW_LINK
        case SUCCESS_HOME_REVIEW_LINK_MOVE
        case FAIL_HOME_REVIEW_LINK_MOVE
        case TAP_HOME_REVIEW_WRITE
        case TAP_HOME_REVIEW_DETAIL
        
        // WRITE REVIEW (SELECT CATEGORY)
        case VIEW_WRITE_REVIEW_CATEGORY
        case TAP_WRITE_REVIEW_CATEOGRY
        
        // WRITE REVIEW (SEARCH PROGRAM)
        case VIEW_SEARCH_PROGRAM
        case TAP_SEARCH_PROGRAM
        case SUCCESS_SEARCH_PROGRAM
        case FAIL_SEARCH_PROGRAM
        case SCROLL_SEARCH_PROGRAM
        case TAP_SEARCH_PROGRAM_USERINPUT
        
        // WRITE REVIEW (NEW)
        case VIEW_WRITE_REVIEW
        case SUCCESS_WRITE_IMAGE_ADD
        case FAIL_WRITE_IMAGE_ADD
        case TAP_WRITE_IMAGE_DELETE
        case ALERT_WIRTE_REVIEW_CANCEL
        case TAP_WRITE_REVIEW_CANCEL_NO
        case TAP_WRITE_REVIEW_CANCEL_YES
        case TAP_WRITE_REIVEW_COMPLETE
        case SUCCESS_WRITE_REIVEW
        case FAIL_WRITE_REVIEW
        
        // WRITE REVIEW (EDIT)
        case VIEW_EDIT_REIVEW
        case SUCCESS_EDIT_IMAGE_ADD
        case FAIL_EDIT_IMAGE_ADD
        case TAP_EDIT_IMAGE_DELETE
        case ALERT_EDIT_REVIEW_CANCEL
        case TAP_EDIT_REVIEW_CANCEL_NO
        case TAP_EDIT_REVIEW_CANCEL_YES
        case TAP_EDIT_REIVEW_COMPLETE
        case SUCCESS_EDIT_REIVEW
        case FAIL_EDIT_REVIEW
        
        // REVIEW DETAIL
        case VIEW_REVIEW_DETAIL
        case ALERT_DETAIL_REVIEW_OPTION
        case TAP_DETAIL_REVIEW_EDIT
        case TAP_DETAIL_REVIEW_SHARE
        case SUCCESS_DETAIL_REVIEW_SHARE
        case FAIL_DETAIL_REVIEW_SHARE
        case SUCCESS_DETAIL_REVIEW_DELETE
        case FAIL_DETAIL_REVIEW_DELETE
        case TAP_DETAIL_REVIEW_LINK
        case SUCCESS_DETAIL_REVIEW_LINK_MOVE
        case FAIL_DETAIL_REVIEW_LINK_MOVE
        case VIEW_DETAIL_REVIEW_IMAGE
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
        case STORE_VERSION
        case AUTH_TYPE
        case CATEGORY_TYPE
        case SORT_TYPE
        case IS_FIRST
        case IS_EMPTY
        case IS_LAST
        case SHARE_URL
        case REVIEW_ID
        case REVIEW_LINK
        case PROGRAM_NAME
        case PROGRAM_TOTAL_COUNT
        case CURRENT_PAGE
        case IMAGE_TYPE
        case REVIEW_TITLE_COUNT
        case REVIEW_CONTENT_COUNT
        case REVIEW_RATING
        case IS_REVIEW_LINK
        case REVIEW_IMAGE_COUNT
        case IMAGE_TOTAL_COUNT
    }
    // swiftlint:enable identifier_name
    
    private let errorEventNames: Set<EventName> = [
        .FAIL_API,
        .FAIL_LOGIN,
        .FAIL_LOGOUT,
        .FAIL_NICKNAME_SETTING,
        .FAIL_CONTRACTUS,
        .FAIL_WITHDRAW,
        .FAIL_APPLE_LOGIN_AUTH,
        .FAIL_REVIEW_LIST,
        .FAIL_HOME_REVIEW_SHARE,
        .FAIL_HOME_REVIEW_DELETE,
        .FAIL_SEARCH_PROGRAM,
        .FAIL_WRITE_IMAGE_ADD,
        .FAIL_WRITE_REVIEW,
        .FAIL_EDIT_IMAGE_ADD,
        .FAIL_EDIT_REVIEW,
        .FAIL_DETAIL_REVIEW_SHARE,
        .FAIL_DETAIL_REVIEW_DELETE
    ]
    
    private let eventParameters: [EventName: [EventParameter]] = [
        .OPEN_APP: [.TIME_STAMP],
        .OPEN_APP_PUSH: [.TIME_STAMP],
        .OPEN_APP_DEEPLINK: [.TIME_STAMP],
        .ALERT_JALIBROKEN: [.TIME_STAMP],
        .FAIL_API: [.API_TYPE, .API_URL, .API_METHOD, .ERROR_CODE, .ERROR_MESSAGE, .TIME_STAMP],
        .SUCCESS_LOGIN_NEW: [.SNS_TYPE],
        .SUCCESS_LOGIN: [.SNS_TYPE, .REVIEW_COUNT, .IS_PUSH],
        .FAIL_LOGIN: [.SNS_TYPE, .ERROR_CODE, .ERROR_MESSAGE, .TIME_STAMP],
        .TAP_LOGOUT: [.SNS_TYPE],
        .SUCCESS_LOGOUT: [.SNS_TYPE],
        .FAIL_LOGOUT: [.SNS_TYPE, .ERROR_CODE, .ERROR_MESSAGE, .TIME_STAMP],
        .SUCCESS_NICKNAME_SETTING: [.NICKNAME],
        .FAIL_NICKNAME_SETTING_INVALID: [.NICKNAME],
        .FAIL_NICKNAME_SETTING: [.NICKNAME, .ERROR_CODE, .ERROR_MESSAGE, .TIME_STAMP],
        .SUCCESS_CONTRACTUS: [.APP_VERSION],
        .FAIL_CONTRACTUS: [.APP_VERSION, .ERROR_CODE, .ERROR_MESSAGE, .TIME_STAMP],
        .VIEW_APPVERSION: [.APP_VERSION, .STORE_VERSION],
        .TAP_APPVERSION_UPDATE_GO: [.APP_VERSION, .STORE_VERSION],
        .TAP_WITHDRAW: [.SNS_TYPE, .REVIEW_COUNT],
        .SUCCESS_WITHDRAW: [.SNS_TYPE, .REVIEW_COUNT],
        .FAIL_WITHDRAW: [.SNS_TYPE, .REVIEW_COUNT, .ERROR_CODE, .ERROR_MESSAGE, .TIME_STAMP],
        .FAIL_APPLE_LOGIN_AUTH: [.AUTH_TYPE, .ERROR_CODE, .ERROR_MESSAGE, .TIME_STAMP],
        .VIEW_HOME: [.REVIEW_COUNT],
        .TAP_HOME_CATEGORY: [.CATEGORY_TYPE],
        .TAP_HOME_SORT: [.SORT_TYPE],
        .SUCCESS_REVIEW_LIST: [.CATEGORY_TYPE, .SORT_TYPE, .IS_FIRST, .IS_EMPTY, .IS_LAST],
        .FAIL_REVIEW_LIST: [.CATEGORY_TYPE, .SORT_TYPE, .ERROR_CODE, .ERROR_MESSAGE, .TIME_STAMP],
        .SUCCESS_HOME_REVIEW_SHARE: [.SHARE_URL],
        .FAIL_HOME_REVIEW_SHARE: [.REVIEW_ID, .ERROR_CODE, .ERROR_MESSAGE, .TIME_STAMP],
        .SUCCESS_HOME_REVIEW_DELETE: [.CATEGORY_TYPE],
        .FAIL_HOME_REVIEW_DELETE: [.CATEGORY_TYPE, .REVIEW_ID, .ERROR_CODE, .ERROR_MESSAGE, .TIME_STAMP],
        .SUCCESS_HOME_REVIEW_LINK_MOVE: [.REVIEW_LINK],
        .FAIL_HOME_REVIEW_LINK_MOVE: [.REVIEW_LINK],
        .TAP_WRITE_REVIEW_CATEOGRY: [.CATEGORY_TYPE],
        .VIEW_SEARCH_PROGRAM: [.CATEGORY_TYPE],
        .TAP_SEARCH_PROGRAM: [.CATEGORY_TYPE, .PROGRAM_NAME],
        .SUCCESS_SEARCH_PROGRAM: [.CATEGORY_TYPE, .PROGRAM_NAME, .PROGRAM_TOTAL_COUNT],
        .FAIL_SEARCH_PROGRAM: [.CATEGORY_TYPE, .PROGRAM_NAME, .ERROR_CODE, .ERROR_MESSAGE, .TIME_STAMP],
        .SCROLL_SEARCH_PROGRAM: [.CATEGORY_TYPE, .PROGRAM_NAME, .CURRENT_PAGE],
        .TAP_SEARCH_PROGRAM_USERINPUT: [.CATEGORY_TYPE, .PROGRAM_NAME],
        .SUCCESS_WRITE_IMAGE_ADD: [.IMAGE_TYPE],
        .FAIL_WRITE_IMAGE_ADD: [.ERROR_CODE, .ERROR_MESSAGE, .TIME_STAMP],
        .TAP_WRITE_IMAGE_DELETE: [.IMAGE_TYPE],
        .ALERT_WIRTE_REVIEW_CANCEL: [.CATEGORY_TYPE],
        .TAP_WRITE_REVIEW_CANCEL_NO: [.CATEGORY_TYPE],
        .TAP_WRITE_REVIEW_CANCEL_YES: [.CATEGORY_TYPE],
        .TAP_WRITE_REIVEW_COMPLETE: [.CATEGORY_TYPE, .PROGRAM_NAME, .REVIEW_TITLE_COUNT, .REVIEW_CONTENT_COUNT, .REVIEW_RATING, .IS_REVIEW_LINK, .REVIEW_IMAGE_COUNT],
        .SUCCESS_WRITE_REIVEW: [.CATEGORY_TYPE, .PROGRAM_NAME, .REVIEW_TITLE_COUNT, .REVIEW_CONTENT_COUNT, .REVIEW_RATING, .IS_REVIEW_LINK, .REVIEW_IMAGE_COUNT],
        .FAIL_WRITE_REVIEW: [.ERROR_CODE, .ERROR_MESSAGE, .TIME_STAMP],
        .SUCCESS_EDIT_IMAGE_ADD: [.IMAGE_TYPE],
        .FAIL_EDIT_IMAGE_ADD: [.ERROR_CODE, .ERROR_MESSAGE, .TIME_STAMP],
        .TAP_EDIT_IMAGE_DELETE: [.IMAGE_TYPE],
        .ALERT_EDIT_REVIEW_CANCEL: [.CATEGORY_TYPE],
        .TAP_EDIT_REVIEW_CANCEL_NO: [.CATEGORY_TYPE],
        .TAP_EDIT_REVIEW_CANCEL_YES: [.CATEGORY_TYPE],
        .TAP_EDIT_REIVEW_COMPLETE: [.REVIEW_ID, .CATEGORY_TYPE, .PROGRAM_NAME, .REVIEW_TITLE_COUNT, .REVIEW_CONTENT_COUNT, .REVIEW_RATING, .IS_REVIEW_LINK, .REVIEW_IMAGE_COUNT],
        .SUCCESS_EDIT_REIVEW: [.REVIEW_ID, .CATEGORY_TYPE, .PROGRAM_NAME, .REVIEW_TITLE_COUNT, .REVIEW_CONTENT_COUNT, .REVIEW_RATING, .IS_REVIEW_LINK, .REVIEW_IMAGE_COUNT],
        .FAIL_EDIT_REVIEW: [.REVIEW_ID, .ERROR_CODE, .ERROR_MESSAGE, .TIME_STAMP],
        .SUCCESS_DETAIL_REVIEW_SHARE: [.SHARE_URL],
        .FAIL_DETAIL_REVIEW_SHARE: [.REVIEW_ID, .ERROR_CODE, .ERROR_MESSAGE, .TIME_STAMP],
        .SUCCESS_DETAIL_REVIEW_DELETE: [.CATEGORY_TYPE],
        .FAIL_DETAIL_REVIEW_DELETE: [.REVIEW_ID, .ERROR_CODE, .ERROR_MESSAGE, .TIME_STAMP],
        .SUCCESS_DETAIL_REVIEW_LINK_MOVE: [.REVIEW_LINK],
        .FAIL_DETAIL_REVIEW_LINK_MOVE: [.REVIEW_LINK],
        .VIEW_DETAIL_REVIEW_IMAGE: [.IMAGE_TOTAL_COUNT]
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
             
             // eventParameters에 정의된 파라미터 추가
            if let requiredParams = eventParameters[event] {
                for param in requiredParams where fullParameters[param] == nil {
                    fullParameters[param] = "" // or provide a default value
                }
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
