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
    
    var quote: Quote = Quote()
    var settingsChanged: (()-> Void)?
    
    init() {
        notificationCenter
            .addObserver(self, selector: #selector(onSettingsChanged), name: Notification.Name(SettingsViewController.EVENT_SETTINGS_CHANGED), object: nil)
        if(Double(DataRepository.Defaults.shared.tax) == 0){
            userDefaults.setValue(4.0, forKey: SETTINGS_DEFAULT_TAX)
        }
    }
    
    @objc func onSettingsChanged(){
        settingsChanged?()
    }
    
    func getLogoImage() -> UIImage? {
        return UIImage(contentsOfFile: getFileForName(name: COMPANY_LOGO).path)
    }
    
    func getInvoiceID() -> String {
        return DataRepository.Defaults.shared.quoteIDPrefix + quote.invoiceId
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
        // Once we are saving the quote - it becomes a manged object so if we
        // want to keep using it we must, again - get an umanged object
        self.quote = Quote(value: quote)
    }
}
