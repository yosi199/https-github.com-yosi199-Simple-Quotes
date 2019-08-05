//
//  QuoteCellItemTableViewCell.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 08/07/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit

class QuoteCellItemTableViewCell: UITableViewCell {
   
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var itemsCount: UILabel!
    @IBOutlet weak var totalValue: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func loadItem(item: Quote){
        self.clientName.text = item.clientName
        self.date.text = item.date
        self.itemsCount.text = "Items: \(String(item.items.count))"
        
        let sum: Double = item.items.sum(ofProperty: "total")
        let tax = (sum * (UserDefaults.standard.double(forKey: SETTINGS_DEFAULT_TAX) ) / 100)

        self.totalValue.text = String((sum + tax).rounded(toPlaces: 2).toCurrency(locale: getLocale()))
    }
    
    private func getLocale() -> Locale {
        let identifier = DataRepository.Defaults.shared.localeIdentifier
        return Locale(identifier: identifier)
    }
    
}
