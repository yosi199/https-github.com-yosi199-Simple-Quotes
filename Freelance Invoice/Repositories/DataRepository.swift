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
    static let NEW_QUOTE_SAVED = "newQuoteSaved"
    static let LINE_ITEM_SAVED = "lineItemSaved"
    
    private let notificationCenter = NotificationCenter.default
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
        try! realm.write {
            realm.add(quote, update: .all)
            // TODO - pass the quote in the notification so that anyone that listens to it will get the new quote
            NotificationCenter.default.post(name: Notification.Name(DataRepository.NEW_QUOTE_SAVED), object: nil)
            debugPrint("added quote id \(quote.id) to realm successfully")
        }
    }
    
    func remove(quote:Quote){
        debugPrint("Removing quote \(quote.id) from db")
        realm.delete(quote)
    }
    
    func saveLineItem(item: LineItemModel){
        try! realm.write {
            realm.add(item, update: .all)
            NotificationCenter.default.post(name: Notification.Name(DataRepository.LINE_ITEM_SAVED), object: nil)
            debugPrint("line item \(item.title) saved successfully")
        }
    }
    
    func getItems() -> Results<LineItemModel> {
        return realm.objects(LineItemModel.self)
    }
    
    class Defaults: FileHandler {
        static let shared = Defaults()
        
        private let userDefaults = UserDefaults.standard
        
        var currency: String  {
            get { return userDefaults.string(forKey: SETTINGS_CURRENCY_SYMBOL) ?? Locale.current.currencySymbol ?? "$"  }
            set { userDefaults.set(newValue, forKey: SETTINGS_CURRENCY_SYMBOL) }
        }
        
        var localeIdentifier: String {
            get { return userDefaults.string(forKey: SETTINGS_LOCALE_IDENTIFIER) ?? Locale.current.identifier }
            set { userDefaults.set(newValue, forKey: SETTINGS_LOCALE_IDENTIFIER) }
        }
        
        var tax: String {
            get { return String(userDefaults.double(forKey: SETTINGS_DEFAULT_TAX).rounded(toPlaces: 2)) }
            set { userDefaults.set(newValue, forKey: SETTINGS_DEFAULT_TAX) }
        }
        
        var image: UIImage? {
            get { return UIImage(contentsOfFile: getFileForName(name: COMPANY_LOGO).path) }
            set { saveImageFile(data: newValue?.pngData(), withName: COMPANY_LOGO) }
        }
        
        var quoteIDPrefix: String {
            get { return userDefaults.string(forKey: SETTINGS_INVOICE_ID_PREFIX) ?? "CMX" }
            set { userDefaults.set(newValue, forKey: SETTINGS_INVOICE_ID_PREFIX) }
        }
        
        var quoteIdString: String {
            get { return "\(String(describing: userDefaults.string(forKey: SETTINGS_INVOICE_ID_PREFIX) ?? "CMX"))\(String(describing: userDefaults.integer(forKey: SETTINGS_INVOICE_ID_COUNTER)))" }
        }
        
        var companyName: String {
            get { return userDefaults.string(forKey: SETTINGS_COMPANY_NAME) ?? "Company X" }
            set { userDefaults.set(newValue, forKey: SETTINGS_COMPANY_NAME) }
        }
    }
}
