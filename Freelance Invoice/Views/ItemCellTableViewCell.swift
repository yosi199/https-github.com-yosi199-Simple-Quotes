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
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var rightBounds: UIView!
    @IBOutlet weak var leftBounds: UIView!
    @IBOutlet weak var topBounds: UIView!
    @IBOutlet weak var middleBounds: UIView!
    @IBOutlet weak var bottomBounds: UIView!
    
    func hideBounds(){
        rightBounds.isHidden = true
        leftBounds.isHidden = true
        topBounds.isHidden = true
        bottomBounds.isHidden = true
        middleBounds.isHidden = true
        
        title.bottomAnchor.constraint(equalTo: middleBounds.topAnchor, constant: 0).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        interactionState(enabled: false)
    }
    
    func interactionState(enabled: Bool){
        isUserInteractionEnabled = enabled
        title.isUserInteractionEnabled = enabled
        descriptionField.isUserInteractionEnabled = enabled
        quantity.isUserInteractionEnabled = enabled
        itemValue.isUserInteractionEnabled = enabled
        totalValue.isUserInteractionEnabled = enabled
        taxValue.isUserInteractionEnabled = enabled
    }
    
    func loadCell(item: LineItemModel){
        title.text = item.title
        descriptionField.text = item.itemDescription
        quantity.text = String(item.qty)
        itemValue.text = String(item.value.rounded(toPlaces: 2))
        taxValue.text = String(item.tax.rounded(toPlaces: 2))
        totalValue.text = String(item.total.rounded(toPlaces: 2))
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
