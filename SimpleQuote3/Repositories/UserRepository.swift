//
//  UserRepository.swift
//  My Properties
//
//  Created by Yosi Mizrachi on 02/06/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import RealmSwift

class UserRepository {
    
    static let shared = UserRepository()
    private let realm: Realm
    
    private init() {
        try! self.realm = Realm()
    }
    
    func getUser() -> User? {
        return realm.objects(User.self).first
    }
    
    func setUser() {
        try! realm.write {
            realm.create(User.self)
            debugPrint("created user successfully)")
        }
    }
}
