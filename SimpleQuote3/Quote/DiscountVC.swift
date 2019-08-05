//
//  DiscountVC.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 05/08/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit

class DiscountVC: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var discountSlider: UISlider!
    @IBOutlet weak var discountValueInput: UITextField!
    @IBOutlet weak var discountPercentageInput: UITextField!
    
    var quote: Quote?
    private lazy var vm: DiscountVM = {DiscountVM(quote: quote!)}()
    
    private let locale = Locale(identifier: DataRepository.Defaults.shared.localeIdentifier)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.discountSlider.minimumValue = 0
        
        let maxValue = self.vm.getMaxValue()
        self.discountSlider.maximumValue = maxValue
        self.discountValueInput.text = String(0.0.toCurrency(locale: locale))
        self.discountPercentageInput.text = "%0"
    }
    
    @IBAction func onValueChanged(_ sender: Any) {
        self.discountValueInput.text = String(Double(self.discountSlider.value).rounded(toPlaces: 2).toCurrency(locale: locale))
        self.discountPercentageInput.text = "%\(String(Double((self.discountSlider.value / vm.getMaxValue()) * 100.0).rounded(toPlaces: 2)))"
    }
}
