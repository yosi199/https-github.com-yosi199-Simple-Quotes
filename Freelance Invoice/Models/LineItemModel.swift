//
//  LineItemModel.swift
//  My Properties
//
//  Created by Yosi Mizrachi on 29/05/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import RealmSwift

class LineItemModel : Object {
    
    @objc dynamic var title: String = "Item maintenance"
    @objc dynamic var itemDescription: String = "repair/replace"
    @objc dynamic var qty: Int = 1
    @objc dynamic var value: Double = 0.00
    @objc dynamic var tax: Double = 0.00
    @objc dynamic  var total: Double = 0.00

    override static func primaryKey() -> String? {
        return "title"
    }
}
