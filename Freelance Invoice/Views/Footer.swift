//
//  Footer.swift
//  My Properties
//
//  Created by Yosi Mizrachi on 31/05/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit
import RealmSwift

class Footer: UIView {
    
    let NAME = "Footer"

    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var itemsCount: UILabel!
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(NAME, owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    func update(items: [LineItemModel]){
        var total = 0.0
        items.forEach { (item) in
            total += item.total
        }
        self.itemsCount.text = "\(items.count) Items"
        let locale = Locale(identifier: DataRepository.Defaults.shared.localeIdentifier)
        self.total.text = "Total: \(String(total.rounded(toPlaces: 2).toCurrency(locale: locale)))"
    }

}
