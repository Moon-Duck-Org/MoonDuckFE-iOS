//
//  UserModel.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Foundation

protocol UserModelDelegate: AnyObject {
    func userModel(_ model: UserModel, didChange user: User)
    func userModel(_ model: UserModel, didRecieve error: APIError?)
    func userModelDidFailLogin(_ model: UserModel)
    func userModelDidFailFetchingUser(_ model: UserModel)
    func userModelDidFailNickname(_ model: UserModel)
    func userModelDidAuthError(_ model: UserModel)
}
extension UserModelDelegate {
    func userModel(_ model: UserModel, didChange user: User) { }
    func userModel(_ model: UserModel, didRecieve error: APIError?) { }
    func userModelDidFailLogin(_ model: UserModel) { }
    func userModelDidFailFetchingUser(_ model: UserModel) { }
    func userModelDidFailNickname(_ model: UserModel) { }
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
                delegate?.userModel(self, didChange: user)
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
                // 오류 발생
                if let error = failed {
                    if error.isAuthError {
                        self.delegate?.userModelDidAuthError(self)
                        return
                    } else if error.needsTokenRefresh {
                        AuthManager.default.refreshToken { [weak self] code in
                            guard let self else { return }
                            if code == .success {
                                self.getUser()
                            } else {
                                self.delegate?.userModelDidAuthError(self)
                            }
                        }
                        return
                    }
                }
                // User 정보 조회 실패
                self.delegate?.userModelDidFailFetchingUser(self)
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
                if let error = failed {
                    if error.isAuthError {
                        self.delegate?.userModelDidAuthError(self)
                        return
                    } else if error.needsTokenRefresh {
                        AuthManager.default.refreshToken { [weak self] code in
                            guard let self else { return }
                            if code == .success {
                                self.nickname(name)
                            } else {
                                self.delegate?.userModelDidAuthError(self)
                            }
                        }
                        return
                    } else if error.duplicateNickname {
                        // 중복된 닉네임
                        self.delegate?.userModelDidFailNickname(self)
                        return
                    }
                }
                self.delegate?.userModel(self, didRecieve: failed)
            }
        }
    }
}
