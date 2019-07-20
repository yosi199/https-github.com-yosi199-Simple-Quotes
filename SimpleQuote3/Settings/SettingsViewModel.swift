//
//  SettingsViewModel.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 17/07/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewModel  {
    
    private let userDefaults = UserDefaults.standard
    
    var currency: String  {
        get { return DataRepository.Defaults.shared.currency }
        set { DataRepository.Defaults.shared.currency = newValue}
    }
    
    var tax: String {
        get { return DataRepository.Defaults.shared.tax }
        set { DataRepository.Defaults.shared.tax = newValue}
    }
    
    var image: UIImage? {
        get { return DataRepository.Defaults.shared.image }
        set { DataRepository.Defaults.shared.image = newValue}
    }
    
    var quoteIDPrefix: String {
        get { return DataRepository.Defaults.shared.quoteIDPrefix }
        set { DataRepository.Defaults.shared.quoteIDPrefix = newValue}
    }
    
    var quoteIdString: String {
        get { return DataRepository.Defaults.shared.quoteIdString }
    }
}
