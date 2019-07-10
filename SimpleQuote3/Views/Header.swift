//
//  Header.swift
//  My Properties
//
//  Created by Yosi Mizrachi on 31/05/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit

class Header: UIView, FileHandler {
    
    let NAME = "Header"
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var clientName: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var logo: UIImageView!
    
    private let userRepo = UserRepository.shared
    
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
        containerView.fixInView(self)
        
        self.date.text = Date().getCurrentDate()
        setLogo()
    }
    
    func saveData(quote: Quote){
        quote.companyName = companyName.text ?? ""
        quote.address = address.text ?? ""
        quote.clientName = clientName.text ?? ""
        quote.date = date.text ?? ""
        quote.email = email.text ?? ""
        quote.invoiceId = id.text ?? ""
    }
    
    func restore(quote: Quote){
        companyName.text = quote.companyName
        address.text = quote.address
        clientName.text = quote.clientName
        date.text = quote.date
        email.text = quote.email
        id.text = quote.invoiceId
    }
    
    private func setLogo(){
        if let image = UIImage(contentsOfFile: getFileForName(name: COMPANY_LOGO).path){
            logo.image = image
        }
    }
    

}
