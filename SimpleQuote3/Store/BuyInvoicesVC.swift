//
//  BuyInvoicesVCViewController.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 15/08/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit
import StoreKit

class BuyInvoicesVC: UIViewController {
    
    @IBOutlet weak var levelOnePrice: UILabel!
    @IBOutlet weak var levelOneName: UILabel!
    
    @IBOutlet weak var levelTwoName: UILabel!
    @IBOutlet weak var levelTwoPrice: UILabel!
    
    @IBOutlet weak var levelThreeName: UILabel!
    @IBOutlet weak var levelThreePrice: UILabel!
    
    @IBOutlet weak var product1: UIView!
    @IBOutlet weak var product2: UIView!
    @IBOutlet weak var product3: UIView!
    
    var products: [SKProduct]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        products.forEach { (product) in
            print("Identifier: \(product.productIdentifier)")
            print("Regular price: \(product.regularPrice)")
            
            //            StoreObserver.shared.buy(product)
        }
        
        if(products.count == 3){
            levelOneName.text = products[0].productIdentifier
            levelTwoName.text = products[1].productIdentifier
            levelThreeName.text = products[2].productIdentifier
            
            levelOnePrice.text = products[0].regularPrice
            levelTwoPrice.text = products[1].regularPrice
            levelThreePrice.text = products[2].regularPrice
        }
        
        let tapProduct1 = UITapGestureRecognizer(target: self, action: #selector(onProduct1Tapped))
        product1.addGestureRecognizer(tapProduct1)
        
        let tapProduct2 = UITapGestureRecognizer(target: self, action: #selector(onProduct2Tapped))
        product2.addGestureRecognizer(tapProduct2)
        
        let tapProduct3 = UITapGestureRecognizer(target: self, action: #selector(onProduct3Tapped))
        product3.addGestureRecognizer(tapProduct3)
        
    }
    
    @objc func onProduct1Tapped() {
        StoreObserver.shared.buy(products[0])
    }
    
    @objc func onProduct2Tapped() {
        StoreObserver.shared.buy(products[1])
    }
    
    @objc func onProduct3Tapped() {
        StoreObserver.shared.buy(products[2])
    }
}
