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
    private let notificationCenter = NotificationCenter.default
    private let userDefaults = UserDefaults.standard
    private let defaults = DataRepository.Defaults.shared
    private let realm = try! Realm()
    private lazy var items:  Results<Quote> = {
        
        return realm.objects(Quote.self).sorted(byKeyPath: "invoiceId", ascending: false)
    }()
    
    var settingsChanged: (()-> Void)?
    
    init() {
        notificationCenter
            .addObserver(self, selector: #selector(onSettingsChanged), name: Notification.Name(SettingsViewController.EVENT_SETTINGS_CHANGED), object: nil)
    }
    
    @objc func onSettingsChanged(){
        settingsChanged?()
    }
    
    func getItems() -> [Quote] {
        var itemsArray = [Quote]()
        items.forEach { quote in
            itemsArray.append(quote)
        }
        return itemsArray
    }
    
    func addNew() -> Quote {
        let counter = userDefaults.integer(forKey: SETTINGS_INVOICE_ID_COUNTER) + 1
        userDefaults.set(counter , forKey: SETTINGS_INVOICE_ID_COUNTER)
        var emptyQuote: Quote!
        try! realm.write {
            emptyQuote = Quote()
            emptyQuote.invoiceId = String(counter)
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
