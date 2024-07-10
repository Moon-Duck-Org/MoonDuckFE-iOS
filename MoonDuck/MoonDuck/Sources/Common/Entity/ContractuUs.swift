//
//  ContractuUs.swift
//  MoonDuck
//
//  Created by suni on 7/3/24.
//

import Foundation

struct ContractUs {
    let mail: String = Utils.appMail
    let subject: String = "[\(Utils.appName) 문의] "
    var nickName: String
    let appVersion: String = Utils.appVersion ?? "알 수 없음"
    let appName: String = Utils.appName
    
    func getBody() -> String {
        return """
                ℹ️ 앱 및 계정 정보 ℹ️\n
                앱 이름 : \(appName)\n
                앱 버전 : \(appVersion)\n
                계정 닉네임 : \(nickName)\n
                
                
                💡 문의 내용 💡\n
                - 이 곳에 문의 내용을 적어주세요.
                
                
                
                """
    }
}
