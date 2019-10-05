//
//  DateExtensions.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 10/07/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation

extension Date{
    func getCurrentDate() -> String {
        let date = Date()
        let format = DateFormatter()
        format.dateStyle = .medium
        format.timeStyle = .none
        return format.string(from: date)
    }
}
