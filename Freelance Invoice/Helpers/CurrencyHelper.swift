//
//  CurrencyHelper.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 04/08/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation

class CurrencyHelper {
    
    static let shared = CurrencyHelper()
    private var localesMap: [String: Locale] = [:]
    
    private init(){
        DispatchQueue.global().async {
            for locale in Locale.availableIdentifiers {
                let locale = Locale(identifier: locale)

                if let currencyCode = locale.currencyCode {
                    if(self.localesMap[currencyCode] == nil){
                        self.localesMap[currencyCode] = locale
                    }
                }
            }
        }
    }
    
    
    func getLocale(forCurrencyCode:String) -> Locale? {
        return localesMap[forCurrencyCode]
    }
}
