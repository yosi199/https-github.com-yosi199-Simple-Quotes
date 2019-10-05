//
//  NumberInputView.swift
//  My Properties
//
//  Created by Yosi Mizrachi on 29/05/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit

class DoubleInputView: UITextField, UITextFieldDelegate {
    
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
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // User pressed the delete-key to remove a character, this is always valid, return true to allow change
        if string.isEmpty { return true }
        
        // Build the full current string: TextField right now only contains the
        // previous valid value. Use provided info to build up the new version.
        // Can't just concat the two strings because the user might've moved the
        // cursor and delete something in the middle.
        let currentText = textField.text ?? ""
        let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Use our string extensions to check if the string is a valid double and
        // only has the specified amount of decimal places.
        return replacementText.isValidDouble(maxDecimalPlaces: 2)
    }
    
}
