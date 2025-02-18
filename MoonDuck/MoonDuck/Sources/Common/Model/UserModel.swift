//
//  UserModel.swift
//  MoonDuck
//
//  Created by suni on 2/10/25.
//

import Foundation

protocol UserModelDelegate: AnyObject {
    
}

extension UserModelDelegate {
    
}

protocol UserModelType: AnyObject {
    // Data
    var delegate: UserModelDelegate? { get set }
    var nickname: String? { get }
    var isPush: Bool { get }
    
    // DateBase
    func setNickname(nickname: String)
    func setPush(isPush: Bool)
}

class UserModel: UserModelType {
    private let provider: AppStorages
    
    init(_ provider: AppStorages) {
        self.provider = provider
    }
    
    // MARK: - Data
    weak var delegate: UserModelDelegate?
    var nickname: String? {
        return provider.userStorage.nickname()
    }
    var isPush: Bool {
        return provider.userStorage.isPush()
    }
    
    // MARK: - Logic

    // MARK: - DataBase
    func setNickname(nickname: String) {
        provider.userStorage.update(nickname: nickname)
    }
    
    func setPush(isPush: Bool) {
        provider.userStorage.update(isPush: isPush)
    }
}
