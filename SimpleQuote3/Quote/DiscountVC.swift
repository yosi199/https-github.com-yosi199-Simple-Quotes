//
//  DiscountVC.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 05/08/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit

class DiscountVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var discountSlider: UISlider!
    @IBOutlet weak var discountValueInput: UITextField!
    @IBOutlet weak var discountPercentageInput: UITextField!
    
    var subTotal: Double = 0.0
    var currentDiscount: Double = 0.0
    var discountCallback: ((_ discountAmount: Double, _ discountPercentage: Double) -> Void)?
    
    private let locale = Locale(identifier: DataRepository.Defaults.shared.localeIdentifier)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.discountPercentageInput.delegate = self
        self.discountValueInput.delegate = self
        self.discountSlider.minimumValue = 0
        
        let maxValue = self.subTotal
        self.discountSlider.maximumValue = Float(maxValue)
        self.discountValueInput.text = String(0.0.toCurrency(locale: locale))
        self.discountPercentageInput.text = "%0"
        self.discountSlider.value = Float(currentDiscount)
        onValueChanged(self)
        
        let frameTap = UITapGestureRecognizer(target: self, action: #selector(self.tappedOutside))
        self.view.addGestureRecognizer(frameTap)
        
        let saveTap = UITapGestureRecognizer(target: self, action: #selector(save))
        self.saveButton.addGestureRecognizer(saveTap)
    }
    
    @objc func save() {
        let value = Double(self.discountSlider.value)
        let percentage = (value * Double(self.subTotal)) / 100
        self.discountCallback?(value, percentage)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onValueChanged(_ sender: Any) {
        self.discountValueInput.text = String(Double(self.discountSlider.value).rounded(toPlaces: 2).toCurrency(locale: locale))
        self.discountPercentageInput.text = "%\(String(Double((self.discountSlider.value / Float(self.subTotal)) * 100.0).rounded(toPlaces: 2)))"
    }
    
    @objc func tappedOutside(){
        
        if(self.discountValueInput.isFirstResponder) {
            if let value = self.discountValueInput.text, self.discountValueInput.text.orOther(other: "").isValidDouble(maxDecimalPlaces: 2) {
                self.discountSlider.value = Float(value)!
            }
        }
        
        if(self.discountPercentageInput.isFirstResponder) {
            if let value = self.discountPercentageInput.text, value.isValidDouble(maxDecimalPlaces: 2) {
                let result = (Double(value)! * Double(self.subTotal)) / 100
                self.discountSlider.value = Float(result)
            }
        }
        
        onValueChanged(self)
        
        textFieldDidEndEditing(self.discountValueInput)
        textFieldDidEndEditing(self.discountPercentageInput)
        
        self.discountValueInput.resignFirstResponder()
        self.discountPercentageInput.resignFirstResponder()
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.text.orEmpty().isValidDouble(maxDecimalPlaces: 2)){
            if(textField.restorationIdentifier == "discountValue"){
                textField.text = Double(textField.text.orOther(other: "0"))?.toCurrency(locale: locale)
            } else if(textField.restorationIdentifier == "discountPercentage"){
                textField.text = "%\(String(describing: textField.text.orOther(other: "0")))"
            }
        }
    }
}
