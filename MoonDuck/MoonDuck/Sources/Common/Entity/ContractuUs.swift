//
//  ContractuUs.swift
//  MoonDuck
//
//  Created by suni on 7/3/24.
//

import Foundation

struct ContractUs {
    let mail: String = "pocuk405@gmail.com"
    let subject: String = "[문덕이 문의] "
    var nickName: String
    var appVersion: String
    let appName: String = "문덕이"
    
    func getBody() -> String {
        return """
                ℹ️ 앱 및 계정 정보\n
                앱 이름 : \(appName)\n
                앱 버전 : \(appVersion)\n
                닉네임 : \(nickName)\n
                
                💡 문의 내용\n
                
                """
    }
}
