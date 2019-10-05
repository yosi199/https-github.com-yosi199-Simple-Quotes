//
//  CurrencyCell.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 04/08/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {
    
    @IBOutlet weak var currencySymbol: UILabel!
    @IBOutlet weak var currencyDescription: UILabel!
    @IBOutlet weak var currencyTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOpacity = 1
//        self.layer.shadowOffset = .zero
//        self.layer.shadowRadius = 5
//        self.layer.rasterizationScale = UIScreen.main.scale
//
//        self.layer.cornerRadius = 8
//        self.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
