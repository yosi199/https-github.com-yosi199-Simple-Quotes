//
//  SettingsViewModel.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 17/07/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewModel : FileHandler {
    
    private let userDefaults = UserDefaults.standard
    
    var currency: String  {
        get { return userDefaults.string(forKey: SETTINGS_CURRENCY_SYMBOL) ?? "$" }
        set { userDefaults.set(newValue, forKey: SETTINGS_CURRENCY_SYMBOL) }
    }
    
    var tax: String {
        get { return String(userDefaults.double(forKey: SETTINGS_DEFAULT_TAX).rounded(toPlaces: 2)) }
        set { userDefaults.set(newValue, forKey: SETTINGS_DEFAULT_TAX) }
    }
    
    var image: UIImage? {
        get { return UIImage(contentsOfFile: getFileForName(name: COMPANY_LOGO).path) }
        set { saveImageFile(data: newValue?.pngData(), withName: COMPANY_LOGO) }
    }
    
    var quoteID: String {
        get { return userDefaults.string(forKey: SETTINGS_INVOICE_ID) ?? "CMX" }
        set { userDefaults.set(newValue, forKey: SETTINGS_INVOICE_ID) }
    }
}
