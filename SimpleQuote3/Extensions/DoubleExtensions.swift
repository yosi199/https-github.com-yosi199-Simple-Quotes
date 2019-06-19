//
//  DoubleExtensions.swift
//  My Properties
//
//  Created by Yosi Mizrachi on 31/05/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
