//
//  NumberInputView.swift
//  My Properties
//
//  Created by Yosi Mizrachi on 29/05/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit

class NumberInputView: UITextField, UITextFieldDelegate {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    private let punctuation = CharacterSet.punctuationCharacters
    
    override func awakeFromNib() {
        delegate = self
    }
    
    func textField(_ textFieldToChange: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        if let _ = string.rangeOfCharacter(from: punctuation, options: .caseInsensitive) {
            return false // they're trying to add not allowed character(s)
        } else {
            return true // all characters to add are allowed
        }
    }
    
}
