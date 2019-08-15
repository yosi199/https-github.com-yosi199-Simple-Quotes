//
//  Types.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 15/08/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation

struct ProductIdentifiers {
    /// Name of the resource file containing the product identifiers.
    let name = "ProductIds"
    /// Filename extension of the resource file containing the product identifiers.
    let fileExtension = "plist"
}

extension ProductIdentifiers {
    var isEmpty: String {
        return "\(name).\(fileExtension) is empty. Update resource)"
    }
    
    var wasNotFound: String {
        return "Could Not Find \(name).\(fileExtension)."
    }
    
    /// - returns: An array with the product identifiers to be queried.
    var identifiers: [String]? {
        guard let path = Bundle.main.path(forResource: self.name, ofType: self.fileExtension) else { return nil }
        return NSArray(contentsOfFile: path) as? [String]
    }
}

