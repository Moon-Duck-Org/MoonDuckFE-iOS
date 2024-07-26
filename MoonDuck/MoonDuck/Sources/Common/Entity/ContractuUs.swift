//
//  ContractuUs.swift
//  MoonDuck
//
//  Created by suni on 7/3/24.
//

import Foundation

struct ContractUs {
    let mail: String = Constants.appMail
    let subject: String = "[\(Utils.appName) 문의] "
    var nickName: String
    let appVersion: String = Utils.appVersion ?? "알 수 없음"
    let appName: String = Utils.appName
    
    func getBody() -> String {
        return """
                ℹ️ 앱 및 계정 정보 ℹ️
                앱 이름 : \(appName)
                앱 버전 : \(appVersion)
                계정 닉네임 : \(nickName)
                
                💡 문의 내용 💡                
                - 이곳에 문의하실 내용을 적어 주세요.
                
                
                
                """
    }
}
