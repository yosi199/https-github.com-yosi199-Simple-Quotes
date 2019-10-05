//
//  HighlightedButton.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 13/08/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit

class HighlightedButton: UIButton {
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? #colorLiteral(red: 0.9568627451, green: 0.7921568627, blue: 0.2823529412, alpha: 0.8) : #colorLiteral(red: 0.9568627451, green: 0.7921568627, blue: 0.2823529412, alpha: 1)
        }
    }
    
    override open var isSelected: Bool {
        didSet {
            backgroundColor = isHighlighted ? #colorLiteral(red: 0.9568627451, green: 0.7921568627, blue: 0.2823529412, alpha: 0.8) : #colorLiteral(red: 0.9568627451, green: 0.7921568627, blue: 0.2823529412, alpha: 1)
        }
    }

}
