//
//  SavedItemsViewModel.swift
//  Freelance Invoice
//
//  Created by Yosi Mizrachi on 15/10/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import RealmSwift

class SavedItemsViewModel {
    private let notificationCenter = NotificationCenter.default
    private let realm = try! Realm()

    
    func getItems() -> [LineItemModel] {
        let items = realm.objects(LineItemModel.self).sorted(byKeyPath: "title", ascending: false)
        var itemsArray = [LineItemModel]()
        items.forEach { item in
            itemsArray.append(item)
        }
        return itemsArray
    }
}
