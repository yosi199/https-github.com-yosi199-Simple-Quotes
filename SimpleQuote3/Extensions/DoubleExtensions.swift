//
//  DoubleExtensions.swift
//  My Properties
//
//  Created by Yosi Mizrachi on 31/05/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation

extension Double {
    
    private static let formatter = NumberFormatter()
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func toCurrency(locale: Locale = Locale.current) -> String {
        Double.formatter.locale = locale // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        Double.formatter.numberStyle = .currency
        if let formattedAmount = Double.formatter.string(from: NSNumber(value: self)) {
            return formattedAmount
        } else{
            return String(self)
        }
    }
}
