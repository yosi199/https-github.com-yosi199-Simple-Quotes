//
//  ItemView.swift
//  My Properties
//
//  Created by Yosi Mizrachi on 29/05/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit

class ItemView: UIView {
    let NAME = "ItemView"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var title: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var itemValue: UITextField!
    @IBOutlet weak var totalValue: UITextField!
    @IBOutlet weak var taxValue: UITextField!
    
    private let userRepo = UserRepository.shared
    private var item = LineItemModel()

    var showButton: ((_ model: Bool)-> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    convenience init(frame: CGRect, item: LineItemModel) {
        self.init(frame: frame)
        self.item = item
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ItemView", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(NAME, owner: self, options: nil)
        contentView.fixInView(self)
        
        updateViews()
        updatePreviews()
        
        addTextListeners()
    }
    
    func getItem() -> LineItemModel {
        return item
    }
    
    func reset(){
        item = LineItemModel()
        updateViews()
        updatePreviews()
    }
    
    private func updatePreviews(){
        title.text = item.title
        descriptionField.text = item.itemDescription
        quantity.text = String(item.qty)
    }
    
    @objc private func updateViews(){
        removeTextListeners()
        
        itemValue.text = String(item.value.rounded(toPlaces: 2))
        taxValue.text = String(item.tax.rounded(toPlaces: 1))
        totalValue.text = String(item.total.rounded(toPlaces: 2))
        
        if (item.total>0) {
            self.showButton?(true)
        }
                
        addTextListeners()
    }
    
    private func addTextListeners(){
        quantity.addTarget(self, action: #selector(self.onQtyChanged), for: .editingChanged)
        quantity.addTarget(self, action: #selector(self.updateViews), for: .editingDidEnd)

        itemValue.addTarget(self, action: #selector(self.onValueChanged), for: .editingChanged)
        itemValue.addTarget(self, action: #selector(self.updateViews), for: .editingDidEnd)

        taxValue.addTarget(self, action: #selector(self.onTaxChanged), for: .editingChanged)
        taxValue.addTarget(self, action: #selector(self.updateViews), for: .editingDidEnd)
        
        title.addTarget(self, action: #selector(self.onTitleChanged), for: .editingChanged)
        descriptionField.addTarget(self, action: #selector(self.onDescriptionChanged), for: .editingChanged)
    }
    
    private func removeTextListeners(){
        quantity.removeTarget(self, action: #selector(self.onQtyChanged), for: .editingChanged)
        quantity.removeTarget(self, action: #selector(self.updateViews), for: .editingDidEnd)

        itemValue.removeTarget(self, action: #selector(self.onValueChanged), for: .editingChanged)
        itemValue.removeTarget(self, action: #selector(self.updateViews), for: .editingDidEnd)

        taxValue.removeTarget(self, action: #selector(self.onTaxChanged), for: .editingChanged)
        taxValue.removeTarget(self, action: #selector(self.updateViews), for: .editingDidEnd)
        
        title.removeTarget(self, action: #selector(self.onTitleChanged), for: .editingChanged)
        descriptionField.removeTarget(self, action: #selector(self.onDescriptionChanged), for: .editingChanged)
    }
    
    @objc func onQtyChanged(textField: UITextField) {
        if let value = textField.text { self.item.qty = Int(value) ?? 0 } else { self.item.qty = 0 }
        
        debugPrint(textField.text!)
        calculateTotal()
    }
    
    @objc func onValueChanged(textField: UITextField) {
        if let value = textField.text { self.item.value = Double(value) ?? 0 } else { self.item.value = 0 }
        
        debugPrint(textField.text!)
        calculateTotal()
    }
    
    @objc func onTaxChanged(textField: UITextField) {
        if let value = textField.text { self.item.tax = Double(value) ?? 0 } else { self.item.tax = 0 }
        
        debugPrint(textField.text!)
        calculateTotal()
    }
    
    @objc func onTitleChanged(textField: UITextField){
        if let value = textField.text { self.item.title = value} else { self.item.title = "" }
        debugPrint(textField.text!)
    }
    
    @objc func onDescriptionChanged(textField: UITextField){
        if let value = textField.text { self.item.itemDescription = value} else { self.item.itemDescription = "" }
        debugPrint(textField.text!)
    }
    
    private func calculateTotal() {
        let sum = Double(self.item.qty) * (self.item.value)
        let tax = (sum * (UserDefaults.standard.double(forKey: SETTINGS_DEFAULT_TAX) )) / 100
        self.item.tax = tax
        self.item.total = sum + tax
        debugPrint(self.item.total)
    }
}

extension UIView {
    func fixInView(_ container: UIView!) -> Void {
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
