//
//  UserModel.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Foundation

protocol UserModelDelegate: AnyObject {
    func userModel(_ model: UserModel, didChange user: UserV2)
    func userModel(_ model: UserModel, didRecieve error: UserModelError)
    func userModel(_ model: UserModel, didRecieve error: Error?)
}
extension UserModelDelegate {
    func userModel(_ model: UserModel, didChange user: UserV2) { }
}

enum UserModelError {
    case authError
    case duplicateNickname
}

protocol UserModelType: AnyObject {
    /// Data
    var delegate: UserModelDelegate? { get set }
    var user: UserV2? { get }
    
    /// Action
    func save(nickname: String)
    func logout()
    
    /// Networking
    func getUser()
    func nickname(_ name: String)
}

class UserModel: UserModelType {
    
    private let provider: AppServices
    
    init(_ provider: AppServices, user: UserV2? = nil) {
        self.provider = provider
        self.user = user
    }
    
    // MARK: - Data
    weak var delegate: UserModelDelegate?
    var user: UserV2? {
        didSet {
            if let user {
                delegate?.userModel(self, didChange: user)
            }
        }
    }
    
    // MARK: - Action
    func logout() {
        self.user = nil
    }
    
    func save(nickname: String) {
        if let user {
            var updateUser = user
            updateUser.nickname = nickname
            save(user: updateUser)
        } else {
            getUser()
        }
    }

    // MARK: - Networking
    private func save(user: UserV2) {
        self.user = user
    }
    
    func getUser() {
        provider.userService.user { [weak self] succeed, failed in
            guard let self else { return }
            if let succeed {
                // User 정보 조회 성공
                self.save(user: succeed)
            } else {
                // User 정보 조회 실패
                Log.error(failed?.localizedDescription ?? "User Error")
                self.delegate?.userModel(self, didRecieve: .authError)
            }
        }
    }
    
    func nickname(_ name: String) {
        let request = UserNicknameRequest(nickname: name)
        provider.userService.nickname(request: request) { [weak self] succeed, failed in
            guard let self else { return }
            if let succeed {
                // 닉네임 변경 성공
                self.save(nickname: succeed.nickname)
            } else {
                // 오류 발생
                if let code = failed as? APIError {
                    if code.isAuthError {
                        Log.error("Auth Error \(code)")
                        self.delegate?.userModel(self, didRecieve: .authError)
                        return
                    } else if code.needsTokenRefresh {
                        AuthManager.default.refreshToken { [weak self] code in
                            guard let self else { return }
                            if code == .success {
                                self.nickname(name)
                            } else {
                                Log.error("Refresh Token Error \(code)")
                                self.delegate?.userModel(self, didRecieve: .authError)
                            }
                        }
                        return
                    } else if code.duplicateNickname {
                        // 중복된 닉네임
                        self.delegate?.userModel(self, didRecieve: .duplicateNickname)
                        return
                    }
                }
                Log.error(failed?.localizedDescription ?? "Nickname Error")
                self.delegate?.userModel(self, didRecieve: failed)
            }
        }
    }
}
