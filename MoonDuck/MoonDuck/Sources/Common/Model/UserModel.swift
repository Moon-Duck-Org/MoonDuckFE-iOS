//
//  UserModel.swift
//  MoonDuck
//
//  Created by suni on 2/10/25.
//

import Foundation

protocol UserModelDelegate: AnyObject {
    func userModel(_ model: UserModelType, didChange user: User)
}
extension UserModelDelegate {
    func userModel(_ model: UserModelType, didChange user: User) { }
}

protocol UserModelType: AnyObject {
    // Data
    var delegate: UserModelDelegate? { get set }
    var user: User { get set }
    
    // DateBase
    func setNickname(nickname: String)
    func setPush(isPush: Bool)
}

class UserModel: UserModelType {
    
    private let provider: AppStorages
    
    init(_ provider: AppStorages) {
        self.provider = provider
        self.user = provider.userStorage.user()
    }
    
    // MARK: - Data
    weak var delegate: UserModelDelegate?
    var user: User
    
    // MARK: - Logic

    // MARK: - DataBase
    func setNickname(nickname: String) {
        provider.userStorage.update(nickname: nickname)
        self.user.nickname = nickname
        
        delegate?.userModel(self, didChange: user)
    }
    
    func setPush(isPush: Bool) {
        provider.userStorage.update(isPush: isPush)
        self.user.isPush = isPush
        
        delegate?.userModel(self, didChange: user)
    }
}
