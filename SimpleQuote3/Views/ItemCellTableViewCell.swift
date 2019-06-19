//
//  ItemCellTableViewCell.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 19/06/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit

class ItemCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var itemValue: UITextField!
    @IBOutlet weak var totalValue: UITextField!
    @IBOutlet weak var taxValue: UITextField!
    
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var trailing: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    required override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    private func commonInit(){
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func willTransition(to state: UITableViewCell.StateMask) {
      
        if(state.contains(.showingEditControl)){
            
            leading.constant = leading.constant + 20
            trailing.constant = trailing.constant + 20
        } else {
            leading.constant = 0
            trailing.constant = 0
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutIfNeeded()
        })
    }
    
}
