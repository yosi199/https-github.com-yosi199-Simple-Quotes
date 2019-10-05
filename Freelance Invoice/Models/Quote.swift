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
    
    @objc dynamic  var invoiceId: String = "0"
    @objc dynamic  var companyName: String = COMPANY_NAME_STRING
    @objc dynamic  var clientName: String = "Client Name"
    @objc dynamic  var date: String = Date().getCurrentDate()
    @objc dynamic  var address: String = "Address N/A"
    @objc dynamic  var email: String = "clientmail@mail.xyz"
    @objc dynamic  var notes: String = "Client notes"
    @objc dynamic  var imagePath:String = ""
    @objc dynamic  var withLogo: Bool = true
    
    // Money related
    var items = List<LineItemModel>()
    @objc dynamic  var discountAmount: Double = 0.0
    @objc dynamic  var discountPercentage: Double = 0.0
    @objc dynamic  var taxAmount: Double = 0.0
    @objc dynamic  var taxPercentage: Double = 0.0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Quote {
    func isNew() -> Bool {
        return id.isEmpty
    }
    
    func getTotal() -> Double {
        return (items.sum(ofProperty: "total") - discountAmount) + taxAmount
    }
}

extension List where Element == LineItemModel {
    func toArray() -> [LineItemModel]{
        var array = [LineItemModel]()
        forEach { item in
            array.append(item)
        }
        return array
    }
}

extension Array where Element == LineItemModel {
    func getSubTotal() -> Double {
        return reduce(0, {$0 + $1.total})
    }
    
    func toList() -> List<LineItemModel> {
        let list = List<LineItemModel>()
        forEach { item in
            list.append(item)
        }
        return list
    }
}
