//
//  Quote.swift
//  My Properties
//
//  Created by Yosi Mizrachi on 02/06/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import RealmSwift

class Quote : Object {
    @objc dynamic var id: String = UUID().uuidString
    
    let items = List<LineItemModel>()
    
    @objc dynamic  var invoiceId: String = ""
    @objc dynamic  var companyName: String = ""
    @objc dynamic  var clientName: String = ""
    @objc dynamic  var date: String = ""
    @objc dynamic  var address: String = ""
    @objc dynamic  var email: String = ""
    @objc dynamic  var notes: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Quote {
    func isNew() -> Bool {
        return id.isEmpty
    }
}
