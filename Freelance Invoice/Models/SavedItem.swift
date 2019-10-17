//
//  SavedItem.swift
//  Freelance Invoice
//
//  Created by Yosi Mizrachi on 17/10/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import RealmSwift

class SavedItem: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String = "Item maintenance"
    @objc dynamic var itemDescription: String = "repair/replace"
    @objc dynamic var qty: Int = 1
    @objc dynamic var value: Double = 0.00
    @objc dynamic var tax: Double = 0.00
    @objc dynamic  var total: Double = 0.00

    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toLineItem() -> LineItemModel{
        let lineItem = LineItemModel()
        lineItem.id = self.id
        lineItem.title = self.title
        lineItem.itemDescription = self.itemDescription
        lineItem.qty = self.qty
        lineItem.value = self.value
        lineItem.tax = self.tax
        lineItem.total = self.total
        return lineItem
    }
    
    static func fromLineItem(item: LineItemModel) -> SavedItem{
        let savedItem = SavedItem()
        savedItem.id = item.id
        savedItem.title = item.title
        savedItem.itemDescription = item.itemDescription
        savedItem.qty = item.qty
        savedItem.value = item.value
        savedItem.tax = item.tax
        savedItem.total = item.total
        return savedItem
    }
}
