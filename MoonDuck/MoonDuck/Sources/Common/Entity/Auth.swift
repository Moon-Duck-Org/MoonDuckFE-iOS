//
//  Auth.swift
//  MoonDuck
//
//  Created by suni on 6/7/24.
//

import Foundation
import UIKit

enum SnsLoginType: String {
    case kakao = "KAKAO"
    case google = "GOOGLE"
    case apple = "APPLE"
    
    var title: String {
        switch self {
        case .kakao:
            return "카카오"
        case .google:
            return "구글"
        case .apple:
            return "애플"
        }
    }
    
    var smallImage: UIImage {
        switch self {
        case .kakao:
            return Asset.Assets.kakaoLoginSmall.image
        case .google:
            return Asset.Assets.googleLoginSmall.image
        case .apple:
            return Asset.Assets.appleLoginSmall.image
        }
    }
}

struct Auth {
    let loginType: SnsLoginType
    let id: String
}

struct Token {
    let accessToken: String
    let refreshToken: String
}
