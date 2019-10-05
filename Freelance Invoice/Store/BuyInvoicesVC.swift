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
    
    weak var dismissalDelegate: DismissalDelegate?
    private let progress = ProgressView()
    
    var products: [SKProduct]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var identifiers: [String]? {
            guard let path = Bundle.main.path(forResource: "ProductIds", ofType: "plist") else { return nil }
            return NSArray(contentsOfFile: path) as? [String]
        }
        
        if(identifiers!.contains(products[0].productIdentifier)){
            let product = products[0]
            levelTwoName.text = "\(product.localizedTitle)"
            levelTwoPrice.text = "\(String(describing: product.regularPrice!))"
        }
        
        if(identifiers!.contains(products[1].productIdentifier)){
            let product = products[1]
            
            levelThreeName.text = "\(product.localizedTitle)"
            levelThreePrice.text = "\(String(describing: product.regularPrice!))"
        }
        
        if(identifiers!.contains(products[2].productIdentifier)){
            let product = products[2]
            levelOneName.text = "\(product.localizedTitle)"
            levelOnePrice.text = "\(String(describing: product.regularPrice!))"
        }
        
        products.forEach { (product) in
            if(identifiers!.contains(product.productIdentifier)) {
                print("Product Identifier \(product.productIdentifier)")
                print("Identifier: \(product.localizedDescription)")
                print("Title: \(product.localizedTitle)")
                print("Regular price: \(String(describing: product.regularPrice!))")
            }
            //            StoreObserver.shared.buy(product)
        }
        
        let tapProduct1 = UITapGestureRecognizer(target: self, action: #selector(onProduct1Tapped))
        product1.addGestureRecognizer(tapProduct1)
        
        let tapProduct2 = UITapGestureRecognizer(target: self, action: #selector(onProduct2Tapped))
        product2.addGestureRecognizer(tapProduct2)
        
        let tapProduct3 = UITapGestureRecognizer(target: self, action: #selector(onProduct3Tapped))
        product3.addGestureRecognizer(tapProduct3)
        
    }
    
    @objc func onProduct1Tapped() {
        StoreObserver.shared.buy(products[2])
        buyingInProgress()
    }
    
    @objc func onProduct2Tapped() {
        StoreObserver.shared.buy(products[0])
        buyingInProgress()
    }
    
    @objc func onProduct3Tapped() {
        StoreObserver.shared.buy(products[1])
        buyingInProgress()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismissalDelegate?.finishedShowing(viewController: self)
    }
    
    private func buyingInProgress(){
        self.progress.show(parent: self)
        
        StoreObserver.shared.purchaseStatusCallbacks = { self.progress.hide(parent: self)
            self.dismiss(self)
        }
    }
}
