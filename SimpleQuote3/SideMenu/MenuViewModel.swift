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
    
    private let realm = try! Realm()
    private lazy var items:  Results<Quote> = {
        return realm.objects(Quote.self)
    }()
    
    func getItems() -> Results<Quote> {
        return items
    }
    
    func addNew() -> Quote {
        let emptyQuote = Quote()
        DataRepository.shared.saveQuote(quote: emptyQuote)
        return emptyQuote
    }
    
    func delete(quote: Quote) {
        try! realm.write {
            DataRepository.shared.remove(quote: quote)
        }
    }
}
