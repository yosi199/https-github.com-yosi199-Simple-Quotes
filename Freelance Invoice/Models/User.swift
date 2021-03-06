//
//  User.swift
//  My Properties
//
//  Created by Yosi Mizrachi on 02/06/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import RealmSwift

class User : Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = "Company X"
    @objc dynamic var phone = ""
    @objc dynamic var email = ""
    @objc dynamic var address = ""
    @objc dynamic var currencySymbol = ""
    @objc dynamic var taxPercentage = 0.0
    @objc dynamic var uniqueID = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
