//
//  TextFactory.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 08/08/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import UIKit

class TextFactory {
    static let shared = TextFactory()
    
    private static let sizeSmall: CGFloat = 10
    private static let sizeMedium: CGFloat = 12
    private static let sizeLarge: CGFloat = 14
    private static let sizeExraLarge: CGFloat = 26
    
    private let regularFont = UIFont.init(name: "ArialMT", size: sizeLarge)!
    private let boldFont = UIFont.init(name: "ArialRoundedMTBold", size: sizeLarge)!
    
    enum Size: CGFloat { case small = 10, medium = 12, large = 14, extra = 26}
    
    func normal(text: String, size: Size = Size.medium, color: UIColor = UIColor.black) -> NSMutableAttributedString {
        return textWithAttributes(text: text, font: regularFont.withSize(size.rawValue) , color: color)
    }
    
    func bold(text: String, size: Size = Size.medium, color: UIColor = UIColor.black) -> NSMutableAttributedString {
        return textWithAttributes(text: text, font: boldFont.withSize(size.rawValue), color: color)
    }
    
    private func textWithAttributes(text: String, font: UIFont, color: UIColor) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor : color])
    }
}
