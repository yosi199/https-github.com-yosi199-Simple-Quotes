//
//  DiscountVM.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 05/08/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation

class DiscountVM {
    
    private let quote: Quote
    
    init(quote: Quote) {
        self.quote = quote
    }
    
    func getMaxValue() -> Float {
        return self.quote.items.sum(ofProperty: "total")
    }
    
}
