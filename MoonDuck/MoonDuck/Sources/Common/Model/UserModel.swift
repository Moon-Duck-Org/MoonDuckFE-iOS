//
//  UserModel.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Foundation

protocol UserModelDelegate: AnyObject {
    func user(_ model: UserModel, didChange user: User)
    func user(_ model: UserModel, didRecieve error: UserModelError)
    func user(_ model: UserModel, didRecieve error: Error?)
}
extension UserModelDelegate {
    func user(_ model: UserModel, didChange user: User) { }
}

enum UserModelError {
    case authError
    case duplicateNickname
}

protocol UserModelType: AnyObject {
    // Data
    var delegate: UserModelDelegate? { get set }
    var user: User? { get set }
    
    // Logic
    func save(nickname: String)
    func save(user: User)
    func logout()
    func deleteReview(category: Category)
    func createReview(category: Category)
    
    // Networking
    func getUser()
    func nickname(_ name: String)
}

class UserModel: UserModelType {
    
    private let provider: AppServices
    
    init(_ provider: AppServices) {
        self.provider = provider
    }
    
    // MARK: - Data
    weak var delegate: UserModelDelegate?
    var user: User? {
        didSet {
            if let user {
                delegate?.user(self, didChange: user)
            }
        }
    }
    
    // MARK: - Logic
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
    
    func save(user: User) {
        self.user = user
    }
    
    func deleteReview(category: Category) {
        if let user {
            var tempUser = user
            tempUser.all -= 1
            switch category {
            case .movie:
                tempUser.movie -= 1
            case .book:
                tempUser.book -= 1
            case .drama:
                tempUser.drama -= 1
            case .concert:
                tempUser.concert -= 1
            default: break
            }
            save(user: user)
        }
    }
    
    func createReview(category: Category) {
        if let user {
            var tempUser = user
            tempUser.all += 1
            switch category {
            case .movie:
                tempUser.movie += 1
            case .book:
                tempUser.book += 1
            case .drama:
                tempUser.drama += 1
            case .concert:
                tempUser.concert += 1
            default: break
            }
            save(user: user)
        }
    }

    // MARK: - Networking
    
    func getUser() {
        provider.userService.user { [weak self] succeed, failed in
            guard let self else { return }
            if let succeed {
                // User 정보 조회 성공
                self.save(user: succeed)
            } else {
                // User 정보 조회 실패
                Log.error(failed?.localizedDescription ?? "User Error")
                self.delegate?.user(self, didRecieve: .authError)
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
                        self.delegate?.user(self, didRecieve: .authError)
                        return
                    } else if code.needsTokenRefresh {
                        AuthManager.default.refreshToken { [weak self] code in
                            guard let self else { return }
                            if code == .success {
                                self.nickname(name)
                            } else {
                                Log.error("Refresh Token Error \(code)")
                                self.delegate?.user(self, didRecieve: .authError)
                            }
                        }
                        return
                    } else if code.duplicateNickname {
                        // 중복된 닉네임
                        self.delegate?.user(self, didRecieve: .duplicateNickname)
                        return
                    }
                }
                Log.error(failed?.localizedDescription ?? "Nickname Error")
                self.delegate?.user(self, didRecieve: failed)
            }
        }
    }
}
