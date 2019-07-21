//
//  DoubleInputValidator.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 21/07/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import UIKit

class DoubleInputValidator: NSObject, UITextFieldDelegate {
    
    static let shared = DoubleInputValidator()
    
    private override init() {}
    
    //Textfield delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { // return NO to not change text
        let numberCharSet = CharacterSet(charactersIn: ".").union(CharacterSet.decimalDigits)
        let characterSet = CharacterSet(charactersIn: string)
        return numberCharSet.isSuperset(of: characterSet)
    }
}
