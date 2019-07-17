//
//  QuoteViewModel.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 17/07/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import UIKit

class QuoteViewModel: FileHandler {
    
    private let notificationCenter = NotificationCenter.default
    var quote: Quote = Quote()
    var settingsChanged: (()-> Void)?
    
    init() {
       notificationCenter
            .addObserver(self, selector: #selector(onSettingsChanged), name: Notification.Name(SettingsViewController.EVENT_SETTINGS_CHANGED), object: nil)
    }
    
    @objc func onSettingsChanged(){
        settingsChanged?()
    }
    
    func getLogoImage() -> UIImage? {
        return UIImage(contentsOfFile: getFileForName(name: COMPANY_LOGO).path)
    }
    
    func getInvoiceID() -> String {
        return UserDefaults.standard.string(forKey: SETTINGS_INVOICE_ID) ?? "CMX" + quote.id
    }
    
}
