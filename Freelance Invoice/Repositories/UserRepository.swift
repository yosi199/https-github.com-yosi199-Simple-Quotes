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
    
    class Defaults: FileHandler {
          static let shared = Defaults()
          
          private let userDefaults = UserDefaults.standard
          
          var pdfColor: UIColor? {
            get { return UIColor(hexString: userDefaults.string(forKey: CHOOSEN_PDF_ACCENT_COLOR) ?? APP_DEFAULT_ACCENT_COLOR) }
            set { userDefaults.set(newValue?.toHexString(), forKey: CHOOSEN_PDF_ACCENT_COLOR) }
          }
      }
}
