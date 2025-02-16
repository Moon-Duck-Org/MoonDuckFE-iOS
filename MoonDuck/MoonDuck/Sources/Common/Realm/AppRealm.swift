//
//  AppRealm.swift
//  MoonDuck
//
//  Created by suni on 2/10/25.
//

import Foundation

import RealmSwift

class AppRealm {
    
    private var realm: Realm
    
    init() {
        realm = AppRealm.initializeRealm()
        print("Realm file location: \(realm.configuration.fileURL?.path)")
    }
    
    static let shared = AppRealm()

    private static func initializeRealm() -> Realm {
        do {
            let config = Realm.Configuration(
                schemaVersion: 1,
                migrationBlock: { migration, oldSchemaVersion in
                    // MARK: - Perform Migration
//                    self.performMigration(migration: migration, oldSchemaVersion: oldSchemaVersion)
                }
            )
            return try Realm(configuration: config)
        } catch let error as NSError {
            fatalError("Failed to open Realm database: \(error.localizedDescription)")
        }
    }
    
    func add<T: Object>(_ object: T, update: Realm.UpdatePolicy = .error) {
        do {
            try realm.write {
                realm.add(object, update: update)
            }
        } catch let error as NSError {
            print("Failed to add object to Realm: \(error.localizedDescription)")
        }
    }
    
    func delete<T: Object>(object: T, completion: @escaping (_ isSuccess: Bool, _ error: Error?) -> Void) {
        do {
            try realm.write {
                realm.delete(object)
                completion(true, nil)
            }
        } catch let error as NSError {
            print("Failed to delete object from Realm: \(error.localizedDescription)")
            completion(false, error)
        }
    }
    
    func delete<T: Object>(object: Results<T>, completion: @escaping (_ isSuccess: Bool, _ error: Error?) -> Void) {
        do {
            try realm.write {
                realm.delete(object)
                completion(true, nil)
            }
        } catch let error as NSError {
            print("Failed to delete object from Realm: \(error.localizedDescription)")
            completion(false, error)
        }
    }
    
    func fetch<T: Object>(_ type: T.Type) -> Results<T>? {
        return realm.objects(type)
    }
    
    func fetch<T: Object>(_ type: T.Type, primaryKey: ObjectId) -> T? {
        return realm.object(ofType: type, forPrimaryKey: primaryKey)
    }
    
    func update(block: () -> Void, completion: @escaping (_ isSuccess: Bool, _ error: Error?) -> Void) {
        do {
            try realm.write {
                block()
                completion(true, nil)
            }
        } catch let error as NSError {
            print("Failed to update object in Realm: \(error.localizedDescription)")
            completion(false, error)
        }
    }
}
