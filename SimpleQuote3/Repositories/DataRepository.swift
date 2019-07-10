//
//  DataRepository.swift
//  My Properties
//
//  Created by Yosi Mizrachi on 02/06/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import RealmSwift

class DataRepository {
    static let shared = DataRepository()
    private let realm: Realm
    
    private init() {
        try! self.realm = Realm()
    }
    
    func getData(id: String = "") -> Quote? {
        return realm.objects(Quote.self).first
    }
    
    func getAll() -> Results<Quote> {
        return realm.objects(Quote.self)
    }
    
    func saveQuote(quote: Quote) {
            realm.add(quote)
            debugPrint("added quote id \(quote.id) to realm successfully")
    }
    
    func remove(quote:Quote){
        debugPrint("Removing quote \(quote.id) from db")
        realm.delete(quote)
    }
}
