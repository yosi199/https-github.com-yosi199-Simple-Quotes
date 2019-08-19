//
//  BuyInvoicesHelper.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 19/08/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import UIKit

class BuyInvoicesHelper {
    
    static let shared = BuyInvoicesHelper()
    private let userDefaults = UserDefaults.standard
    
    private init(){ }
    
    func getAvailableInvoicesCount() -> Int {
        return userDefaults.integer(forKey: AVAILABLE_INVOICES_COUNT)
    }
    
    func useOneInvoice() {
        let available = getAvailableInvoicesCount()
        if(available > 0){
            userDefaults.set(available - 1, forKey: AVAILABLE_INVOICES_COUNT)
        }
    }
    
}
