//
//  UserModel.swift
//  MoonDuck
//
//  Created by suni on 6/9/24.
//

import Foundation

protocol UserModelDelegate: BaseModelDelegate {
    func userModel(_ model: UserModelType, didChange user: User?)
}
extension UserModelDelegate {
    func userModel(_ model: UserModelType, didChange user: User?) { }
}

protocol UserModelType: BaseModelType {
    // Data
    var delegate: UserModelDelegate? { get set }
    var user: User? { get set }
    
    // Logic
    func save(nickname: String)
    func save(isPush: Bool)
    func save(user: User)
    func deleteReview(category: Category)
    func createReview(category: Category)
    
    // Networking
    func getUser()
    func nickname(_ name: String)
    func deleteUser()
    func push(_ isPush: Bool)
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
            delegate?.userModel(self, didChange: user)
        }
    }
    
    // MARK: - Logic
    func save(nickname: String) {
        if let user {
            var updateUser = user
            updateUser.nickname = nickname
            save(user: updateUser)
        } else {
            getUser()
        }
    }
    
    func save(isPush: Bool) {
        if let user {
            var updateUser = user
            updateUser.isPush = isPush
            save(user: updateUser)
        }
    }
    
    func save(user: User) {
        self.user = user
    }
    
    func logout() {
        self.user = nil
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
            save(user: tempUser)
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
            save(user: tempUser)
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
                self.delegate?.error(didRecieve: failed)
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
                self.delegate?.error(didRecieve: failed)
            }
        }
    }
    
    func deleteUser() {
        provider.userService.deleteUser { [weak self] succeed, failed in
            guard let self else { return }
            if let succeed, succeed {
                self.logout()
            } else {
                // 오류 발생
                self.delegate?.error(didRecieve: failed)
            }
        }
    }
    
    func push(_ isPush: Bool) {
        let request = UserPushRequest(push: isPush.toYn())
        provider.userService.push(request: request) { [weak self] succeed, failed in
            guard let self else { return }
            if let succeed {
                // 푸시 변경 성공
                self.save(isPush: succeed)
            } else {
                // 오류 발생
                self.delegate?.error(didRecieve: failed)
            }
        }
    }
}
