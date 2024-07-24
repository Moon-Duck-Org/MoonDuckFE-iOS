// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum LaunchScreen {
    }
  internal enum Localizable {
    /// Localizable.strings
    ///   MoonDuck
    /// 
    ///   Created by suni on 5/24/24.
    internal static let appName = L10n.tr("Localizable", "app_name", fallback: "문덕이")
    /// 더보기
    internal static let expand = L10n.tr("Localizable", "expand", fallback: "더보기")
    internal enum Button {
      /// 취소
      internal static let cancel = L10n.tr("Localizable", "button. cancel", fallback: "취소")
      /// 닫기
      internal static let close = L10n.tr("Localizable", "button. close", fallback: "닫기")
      /// 삭제
      internal static let delete = L10n.tr("Localizable", "button. delete", fallback: "삭제")
      /// 확인
      internal static let done = L10n.tr("Localizable", "button. done", fallback: "확인")
      /// 수정
      internal static let edit = L10n.tr("Localizable", "button. edit", fallback: "수정")
      /// 나중에 하기
      internal static let later = L10n.tr("Localizable", "button. later", fallback: "나중에 하기")
      /// 로그아웃
      internal static let logout = L10n.tr("Localizable", "button. logout", fallback: "로그아웃")
      /// 공유
      internal static let share = L10n.tr("Localizable", "button. share", fallback: "공유")
      /// 업데이트하러 가기
      internal static let update = L10n.tr("Localizable", "button. update", fallback: "업데이트하러 가기")
      /// 탈퇴
      internal static let withdraw = L10n.tr("Localizable", "button. withdraw", fallback: "탈퇴")
    }
    internal enum Category {
      /// ALL
      internal static let all = L10n.tr("Localizable", "category. all", fallback: "ALL")
      /// 책
      internal static let book = L10n.tr("Localizable", "category. book", fallback: "책")
      /// 공연
      internal static let concert = L10n.tr("Localizable", "category. concert", fallback: "공연")
      /// 드라마
      internal static let drama = L10n.tr("Localizable", "category. drama", fallback: "드라마")
      /// 영화
      internal static let movie = L10n.tr("Localizable", "category. movie", fallback: "영화")
    }
    internal enum ContractUs {
      /// 메일이 성공적으로 전송되었습니다.
      /// 문의해 주셔서 감사합니다.
      internal static let completeMessage = L10n.tr("Localizable", "contractUs. complete_message", fallback: "메일이 성공적으로 전송되었습니다.\n문의해 주셔서 감사합니다.")
      /// 메일 전송에 실패했습니다.
      /// 인터넷 연결을 확인하고 다시 시도해 주세요.
      internal static let errorMessage = L10n.tr("Localizable", "contractUs. error_message", fallback: "메일 전송에 실패했습니다.\n인터넷 연결을 확인하고 다시 시도해 주세요.")
      /// 더 많은 도움이 필요하시면 %@으로 문의해 주세요.
      internal static func notAvailableMailMessage(_ p1: Any) -> String {
        return L10n.tr("Localizable", "contractUs. not_available_mail_message", String(describing: p1), fallback: "더 많은 도움이 필요하시면 %@으로 문의해 주세요.")
      }
      /// 죄송합니다.
      /// 메일을 보낼 수 없습니다. 메일 설정을 확인해 주세요.
      internal static let notAvailableMailTitle = L10n.tr("Localizable", "contractUs. not_available_mail_title", fallback: "죄송합니다.\n메일을 보낼 수 없습니다. 메일 설정을 확인해 주세요.")
    }
    internal enum Error {
      /// 인증 정보가 유효하지 않습니다.
      /// 다시 로그인해 주세요.
      internal static let authMessage = L10n.tr("Localizable", "error. auth_message", fallback: "인증 정보가 유효하지 않습니다.\n다시 로그인해 주세요.")
      /// 유효하지 않은 링크입니다.
      internal static let linkMessage = L10n.tr("Localizable", "error. link_message", fallback: "유효하지 않은 링크입니다.")
      /// 로그인에 실패했어요. 다시 시도해 주세요.
      internal static let loginMessage = L10n.tr("Localizable", "error. login_message", fallback: "로그인에 실패했어요. 다시 시도해 주세요.")
      /// 문제가 지속되면 '설정 -> 문의하기'에 문의해 주세요.
      internal static let message = L10n.tr("Localizable", "error. message", fallback: "문제가 지속되면 '설정 -> 문의하기'에 문의해 주세요.")
      /// 이미지 용량을 초과했습니다.
      /// 다시 시도해 주세요.
      internal static let networkImageSizeMessage = L10n.tr("Localizable", "error. network_image_size_message", fallback: "이미지 용량을 초과했습니다.\n다시 시도해 주세요.")
      /// 네트워크 연결 상태를 확인해 주세요.
      internal static let networkMessage = L10n.tr("Localizable", "error. network_message", fallback: "네트워크 연결 상태를 확인해 주세요.")
      /// 용량이 크거나 확장자가 부적절한 %@개의 사진은 처리되지 않았어요.
      internal static func systemImageSizeMessage(_ p1: Any) -> String {
        return L10n.tr("Localizable", "error. system_image_size_message", String(describing: p1), fallback: "용량이 크거나 확장자가 부적절한 %@개의 사진은 처리되지 않았어요.")
      }
      /// 시스템 오류를 해결하기 위해 노력 중이에요. 잠시 후에 다시 확인해 주세요.
      internal static let systemMessage = L10n.tr("Localizable", "error. system_message", fallback: "시스템 오류를 해결하기 위해 노력 중이에요. 잠시 후에 다시 확인해 주세요.")
      /// %@에 실패하였습니다. 다시 시도해 주세요.
      internal static func title(_ p1: Any) -> String {
        return L10n.tr("Localizable", "error. title", String(describing: p1), fallback: "%@에 실패하였습니다. 다시 시도해 주세요.")
      }
    }
    internal enum Jalibroken {
      /// 루팅된 기기에서는 문덕이를 이용 하실 수 없습니다.
      internal static let message = L10n.tr("Localizable", "jalibroken. message", fallback: "루팅된 기기에서는 문덕이를 이용 하실 수 없습니다.")
    }
    internal enum Message {
      /// 취소하시겠어요?
      internal static let cancel = L10n.tr("Localizable", "message. cancel", fallback: "취소하시겠어요?")
    }
    internal enum My {
      /// 로그아웃하시겠어요?
      internal static let logoutAlertMessage = L10n.tr("Localizable", "my. logout_alert_message", fallback: "로그아웃하시겠어요?")
      /// 정말 탈퇴하시겠어요?
      internal static let withdrawAlertMessage = L10n.tr("Localizable", "my. withdraw_alert_message", fallback: "정말 탈퇴하시겠어요?")
      /// 회원 탈퇴가 성공적으로 완료되었습니다. 문덕이를 이용해 주셔서 감사합니다.
      internal static let withdrawCompleteMessage = L10n.tr("Localizable", "my. withdraw_complete_message", fallback: "회원 탈퇴가 성공적으로 완료되었습니다. 문덕이를 이용해 주셔서 감사합니다.")
    }
    internal enum NicknameSetting {
      /// 닉네임 설정 완료!
      internal static let completeToast = L10n.tr("Localizable", "nickname_setting. complete_toast", fallback: "닉네임 설정 완료!")
      /// 중복된 닉네임입니다.
      internal static let duplicateNameHint = L10n.tr("Localizable", "nickname_setting. duplicate_name_hint", fallback: "중복된 닉네임입니다.")
      /// 특수문자는 사용 불가해요.
      internal static let invalidNameHint = L10n.tr("Localizable", "nickname_setting. invalid_name_hint", fallback: "특수문자는 사용 불가해요.")
    }
    internal enum Push {
      /// %@님! 새로운 기록을 남기지 않으셨어요.
      /// 최근 즐긴 문화생활에 대해 이야기해 주세요!😊
      internal static func messageType1(_ p1: Any) -> String {
        return L10n.tr("Localizable", "push. message_type1", String(describing: p1), fallback: "%@님! 새로운 기록을 남기지 않으셨어요.\n최근 즐긴 문화생활에 대해 이야기해 주세요!😊")
      }
      /// %@님! 최근 어떤 멋진 문화생활을 즐기셨나요?
      /// 기록을 남겨주세요🌟
      internal static func messageType2(_ p1: Any) -> String {
        return L10n.tr("Localizable", "push. message_type2", String(describing: p1), fallback: "%@님! 최근 어떤 멋진 문화생활을 즐기셨나요?\n기록을 남겨주세요🌟")
      }
      /// [문덕이] 푸시 알림 거부가 완료되었습니다. (%@)
      internal static func offCompleteToast(_ p1: Any) -> String {
        return L10n.tr("Localizable", "push. off_complete_toast", String(describing: p1), fallback: "[문덕이] 푸시 알림 거부가 완료되었습니다. (%@)")
      }
      /// [문덕이] 푸시 알림 허용이 완료되었습니다! (%@)
      internal static func onCompleteToast(_ p1: Any) -> String {
        return L10n.tr("Localizable", "push. on_complete_toast", String(describing: p1), fallback: "[문덕이] 푸시 알림 허용이 완료되었습니다! (%@)")
      }
      /// 문덕이 이용에 유용한 알림을 보내드릴 수 있도록 푸시 알림 권한을 허용해 주세요!
      internal static let requestAlertMessage = L10n.tr("Localizable", "push. request_alert_message", fallback: "문덕이 이용에 유용한 알림을 보내드릴 수 있도록 푸시 알림 권한을 허용해 주세요!")
      /// 푸시 알림 요청
      internal static let requestAlertTitle = L10n.tr("Localizable", "push. request_alert_title", fallback: "푸시 알림 요청")
      /// 문덕이 이용에 유용한 알림을 보내드려요.
      internal static let settingText = L10n.tr("Localizable", "push. setting_text", fallback: "문덕이 이용에 유용한 알림을 보내드려요.")
      /// 푸시 알림을 받으려면 기기 설정에서 알림을 켜주세요.
      internal static let settingTextOs = L10n.tr("Localizable", "push. setting_text_os", fallback: "푸시 알림을 받으려면 기기 설정에서 알림을 켜주세요.")
      /// 알림을 켜주세요.
      internal static let settingTextOsEmphasize = L10n.tr("Localizable", "push. setting_text_os_emphasize", fallback: "알림을 켜주세요.")
      /// 문화생활덕후 🐥 문덕이
      internal static let title = L10n.tr("Localizable", "push. title", fallback: "문화생활덕후 🐥 문덕이")
    }
    internal enum Review {
      /// 삭제하시겠어요?
      internal static let deleteMessage = L10n.tr("Localizable", "review. delete_message", fallback: "삭제하시겠어요?")
      /// 기록 작성 완료!
      internal static let writeCompleteMessage = L10n.tr("Localizable", "review. write_complete_message", fallback: "기록 작성 완료!")
    }
    internal enum Search {
      /// %@ 검색어를 입력해 주세요
      internal static func placeholder(_ p1: Any) -> String {
        return L10n.tr("Localizable", "search. placeholder", String(describing: p1), fallback: "%@ 검색어를 입력해 주세요")
      }
      /// %@ 검색어를 입력해 주세요.
      internal static func toast(_ p1: Any) -> String {
        return L10n.tr("Localizable", "search. toast", String(describing: p1), fallback: "%@ 검색어를 입력해 주세요.")
      }
    }
    internal enum Sort {
      /// 최신순
      internal static let latestOrder = L10n.tr("Localizable", "sort. latest_order", fallback: "최신순")
      /// 오래된 순
      internal static let oldestFirst = L10n.tr("Localizable", "sort. oldest_first", fallback: "오래된 순")
      /// 별점순
      internal static let ratingOrder = L10n.tr("Localizable", "sort. rating_order", fallback: "별점순")
    }
    internal enum Title {
      /// 공지사항
      internal static let notice = L10n.tr("Localizable", "title. notice", fallback: "공지사항")
      /// 개인정보 처리방침
      internal static let policy = L10n.tr("Localizable", "title. policy", fallback: "개인정보 처리방침")
      /// 서비스 이용약관
      internal static let service = L10n.tr("Localizable", "title. service", fallback: "서비스 이용약관")
    }
    internal enum Update {
      /// 문덕이를 계속 사용하려면 새로운 버전으로 업데이트해야 해요. 지금 바로 업데이트해 주세요!
      internal static let forceUpdateMessage = L10n.tr("Localizable", "update. force_update_message", fallback: "문덕이를 계속 사용하려면 새로운 버전으로 업데이트해야 해요. 지금 바로 업데이트해 주세요!")
      /// 업데이트가 필요합니다.
      internal static let forceUpdateTitle = L10n.tr("Localizable", "update. force_update_title", fallback: "업데이트가 필요합니다.")
      /// 문덕이의 새로운 기능과 개선된 성능을 경험할 수 있어요. 앱을 지금 최신 버전으로 업데이트해 보세요!
      internal static let latestUpdateMessage = L10n.tr("Localizable", "update. latest_update_message", fallback: "문덕이의 새로운 기능과 개선된 성능을 경험할 수 있어요. 앱을 지금 최신 버전으로 업데이트해 보세요!")
      /// 새로운 버전 업데이트가 있어요
      internal static let latestUpdateText = L10n.tr("Localizable", "update. latest_update_text", fallback: "새로운 버전 업데이트가 있어요")
      /// 새로운 버전 업데이트가 있어요
      internal static let latestUpdateTitle = L10n.tr("Localizable", "update. latest_update_title", fallback: "새로운 버전 업데이트가 있어요")
      /// 가장 최신 버전이에요
      internal static let latestVersionText = L10n.tr("Localizable", "update. latest_version_text", fallback: "가장 최신 버전이에요")
      /// 현재 버전은 %@이에요.
      internal static func versionText(_ p1: Any) -> String {
        return L10n.tr("Localizable", "update. version_text", String(describing: p1), fallback: "현재 버전은 %@이에요.")
      }
    }
    internal enum Withdraw {
      /// %@님은 문덕이와
      /// %@번의 기록을 함께했어요.
      /// 정말 탈퇴하시겠어요? 너무 아쉬워요.
      internal static func text(_ p1: Any, _ p2: Any) -> String {
        return L10n.tr("Localizable", "withdraw. text", String(describing: p1), String(describing: p2), fallback: "%@님은 문덕이와\n%@번의 기록을 함께했어요.\n정말 탈퇴하시겠어요? 너무 아쉬워요.")
      }
    }
    internal enum Write {
      /// 작성된 내용은 모두 지워져요.
      internal static let backMessage = L10n.tr("Localizable", "write. back_message", fallback: "작성된 내용은 모두 지워져요.")
      /// 이전 화면으로 가시겠어요?
      internal static let backTitle = L10n.tr("Localizable", "write. back_title", fallback: "이전 화면으로 가시겠어요?")
      /// 내용을 입력해 주세요.
      internal static let emptyContentMessage = L10n.tr("Localizable", "write. empty_content_message", fallback: "내용을 입력해 주세요.")
      /// 별점을 입력해 주세요.
      internal static let emptyRatingMessage = L10n.tr("Localizable", "write. empty_rating_message", fallback: "별점을 입력해 주세요.")
      /// 제목을 입력해 주세요.
      internal static let emptyTitleMessage = L10n.tr("Localizable", "write. empty_title_message", fallback: "제목을 입력해 주세요.")
    }
  }
  internal enum Main {
    }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
