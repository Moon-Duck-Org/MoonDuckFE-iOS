//
//  UserModel.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Foundation

protocol UserModelDelegate: AnyObject {
    func userModel(_ userModel: UserModel, didChange user: UserV2)
    func userModel(_ userModel: UserModel, didChange nickname: String)
    func userModel(_ userModel: UserModel, didRecieve error: UserModelError)
    func userModel(_ userModel: UserModel, didRecieve error: Error?)
}
extension UserModelDelegate {
    func userModel(_ userModel: UserModel, didChange user: UserV2) { }
    func userModel(_ userModel: UserModel, didChange nickname: String) { }
    func userModel(_ userModel: UserModel, didRecieve error: UserModelError) { }
    func userModel(_ userModel: UserModel, didRecieve error: Error?) { }
}

enum UserModelError {
    case authError
    case duplicateNickname
}

protocol UserModelType: AnyObject {
    var delegate: UserModelDelegate? { get set }
    
    var user: UserV2? { get }
    
    func updateNickname(_ nickname: String)
    func getUser()
    func nickname(_ name: String)
}

class UserModel: UserModelType {
    
    weak var delegate: UserModelDelegate?
    
    var user: UserV2?
    
    private let provider: AppServices
    
    init(_ provider: AppServices) {
        self.provider = provider
    }
    
    private func saveUser(_ user: UserV2) {
        self.user = user
        delegate?.userModel(self, didChange: user)
    }
    
    private func removeUser() {
        self.user = nil
    }
    
    func updateNickname(_ nickname: String) {
        if let user {
            var updateUser = user
            updateUser.nickname = nickname
            saveUser(updateUser)
        } else {
            delegate?.userModel(self, didChange: nickname)
        }
    }

    func getUser() {
        provider.userService.user { [weak self] succeed, failed in
            guard let self else { return }
            if let succeed {
                // User 정보 조회 성공
                self.saveUser(succeed)
            } else {
                // User 정보 조회 실패
                Log.error(failed?.localizedDescription ?? "User Error")
                delegate?.userModel(self, didRecieve: .authError)
            }
        }
    }
    
    func nickname(_ name: String) {
        let request = UserNicknameRequest(nickname: name)
        provider.userService.nickname(request: request) { [weak self] succeed, failed in
            guard let self else { return }
            if let succeed {
                // 닉네임 변경 성공
                self.updateNickname(succeed.nickname)
            } else {
                // 오류 발생
                if let code = failed as? APIError {
                    if code.isAuthError {
                        Log.error("Auth Error \(code)")
                        delegate?.userModel(self, didRecieve: .authError)
                        return
                    } else if code.needsTokenRefresh {
                        AuthManager.default.refreshToken { [weak self] code in
                            guard let self else { return }
                            if code == .success {
                                self.nickname(name)
                            } else {
                                Log.error("Refresh Token Error \(code)")
                                delegate?.userModel(self, didRecieve: .authError)
                            }
                        }
                        return
                    } else if code.duplicateNickname {
                        // 중복된 닉네임
                        delegate?.userModel(self, didRecieve: .duplicateNickname)
                        return
                    }
                }
                Log.error(failed?.localizedDescription ?? "Nickname Error")
                delegate?.userModel(self, didRecieve: failed)
            }
        }
    }
}
