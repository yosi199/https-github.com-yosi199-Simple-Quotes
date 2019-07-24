//
//  MenuViewModel.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 23/07/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import RealmSwift

class MenuViewModel {
    
    private let userDefaults = UserDefaults.standard
    private let defaults = DataRepository.Defaults.shared
    private let realm = try! Realm()
    private lazy var items:  Results<Quote> = {
        return realm.objects(Quote.self)
    }()
    
    func getItems() -> [Quote] {
        var itemsArray = [Quote]()
        items.forEach { quote in
            itemsArray.append(quote)
        }
        return itemsArray
    }
    
    func addNew() -> Quote {
        let counter = userDefaults.integer(forKey: SETTINGS_INVOICE_ID_COUNTER)
        userDefaults.set(counter + 1 , forKey: SETTINGS_INVOICE_ID_COUNTER)
        var emptyQuote: Quote!
        try! realm.write {
            emptyQuote = Quote()
            emptyQuote.invoiceId = defaults.quoteIdString
        }
        DataRepository.shared.saveQuote(quote: emptyQuote)
        return emptyQuote
    }
    
    func delete(quote: Quote) {
        try! realm.write {
            DataRepository.shared.remove(quote: quote)
        }
    }
    
    func isEmpty() -> Bool {
        return items.isEmpty
    }
}
