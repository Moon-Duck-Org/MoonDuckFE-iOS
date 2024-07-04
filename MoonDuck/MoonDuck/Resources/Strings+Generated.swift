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
    /// 취소
    internal static let cancel = L10n.tr("Localizable", "cancel", fallback: "취소")
    /// 닫기
    internal static let close = L10n.tr("Localizable", "close", fallback: "닫기")
    /// Localizable.strings
    ///   MoonDuck
    /// 
    ///   Created by suni on 5/24/24.
    internal static let done = L10n.tr("Localizable", "done", fallback: "확인")
    /// 중복된 닉네임입니다.
    internal static let duplicateNickname = L10n.tr("Localizable", "Duplicate nickname.", fallback: "중복된 닉네임입니다.")
    /// 로그아웃
    internal static let logout = L10n.tr("Localizable", "logout", fallback: "로그아웃")
    /// 닉네임 설정 완료!
    internal static let nicknameSetupComplete = L10n.tr("Localizable", "Nickname setup complete!", fallback: "닉네임 설정 완료!")
    /// 특수문자는 사용 불가해요.
    internal static let specialCharactersAreNotAllowed = L10n.tr("Localizable", "Special characters are not allowed.", fallback: "특수문자는 사용 불가해요.")
    /// 취소하시겠어요?
    internal static let wouldYouLikeToCancel = L10n.tr("Localizable", "Would you like to cancel?", fallback: "취소하시겠어요?")
    /// 로그아웃 하시겠어요?
    internal static let wouldYouLikeToLogOut = L10n.tr("Localizable", "Would you like to log out?", fallback: "로그아웃 하시겠어요?")
    internal enum LoginFailed {
      /// 로그인에 실패하였습니다. 다시 시도해주세요.
      internal static let pleaseTryAgain = L10n.tr("Localizable", "Login failed. Please try again.", fallback: "로그인에 실패하였습니다. 다시 시도해주세요.")
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
