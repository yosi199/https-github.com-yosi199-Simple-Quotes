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
    @IBOutlet weak var logoSwitch: UISwitch!
    
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

    private func setLogo(){
        if let image = UIImage(contentsOfFile: getFileForName(name: COMPANY_LOGO).path){
            logo.image = image
        }
    }
    
    @IBAction func onLogoToggled(_ sender: UISwitch) {
        setLogoState(enabled: sender.isOn)
    }
    
    func setLogoState(enabled: Bool){
        self.logo.isUserInteractionEnabled = enabled
        
        UIView.animate(withDuration: 0.25) {
            if (enabled) {
                self.logo.alpha = 1
            } else{
                self.logo.alpha = 0.3
            }
        }
    }
}
