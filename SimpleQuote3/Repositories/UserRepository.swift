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
    
    func getUser() -> User {
        return realm.objects(User.self).first ?? User()
    }
    
    func setUser(user: User) {
        try! realm.write {
            realm.add(user, update: .all)
            debugPrint("created user successfully)")
        }
    }
}
