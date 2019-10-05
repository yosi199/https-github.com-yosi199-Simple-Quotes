//
//  DispatchQueues.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 12/08/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation

class DispatchQueues {
    static let serialQueue = DispatchQueue(label: "queue", qos: .utility, attributes: [], autoreleaseFrequency: .workItem, target: nil)

}
