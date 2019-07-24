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
    
    @objc dynamic  var invoiceId: String = "0"
    @objc dynamic  var companyName: String = "Company Name"
    @objc dynamic  var clientName: String = "Client Name"
    @objc dynamic  var date: String = Date().getCurrentDate()
    @objc dynamic  var address: String = "Address N/A"
    @objc dynamic  var email: String = "clientmail@mail.xyz"
    @objc dynamic  var notes: String = "Client notes"
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Quote {
    func isNew() -> Bool {
        return id.isEmpty
    }
}
