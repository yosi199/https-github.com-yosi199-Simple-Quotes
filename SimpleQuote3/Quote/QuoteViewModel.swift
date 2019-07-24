//
//  QuoteViewModel.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 17/07/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class QuoteViewModel: FileHandler {
    
    private let notificationCenter = NotificationCenter.default
    private let userDefaults = UserDefaults.standard
    private let realm = try! Realm()
    
    var quote: Quote!
    var settingsChanged: (()-> Void)?
    
    init() {
        notificationCenter
            .addObserver(self, selector: #selector(onSettingsChanged), name: Notification.Name(SettingsViewController.EVENT_SETTINGS_CHANGED), object: nil)
        
//        quote.invoiceId = userDefaults.string(forKey: SETTINGS_INVOICE_ID_COUNTER).orOther(other: "0")
    }
    
    @objc func onSettingsChanged(){
        settingsChanged?()
    }
    
    func getLogoImage() -> UIImage? {
        return UIImage(contentsOfFile: getFileForName(name: COMPANY_LOGO).path)
    }
    
    func getInvoiceID() -> String {
        return DataRepository.Defaults.shared.quoteIdString
    }
    
    func getCurrencySymbol() -> String {
        return userDefaults.string(forKey: SETTINGS_CURRENCY_SYMBOL) ?? "$"
    }
    
    func getTaxPercentage() -> String {
        return userDefaults.string(forKey: SETTINGS_DEFAULT_TAX) ?? "0"
    }
    
    func getCompanyName() -> String {
        return userDefaults.string(forKey: SETTINGS_COMPANY_NAME) ?? ""
    }
    
    func saveQuote() {
        DataRepository.shared.saveQuote(quote: quote)
    }
}
