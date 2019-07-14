//
//  SettingsViewController.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 14/07/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    

    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override var preferredContentSize: CGSize {
        get {
            let landscape = UIApplication.shared.statusBarOrientation.isLandscape
            if let fullSize = self.presentingViewController?.view.bounds.size {
                if(landscape){
                    return CGSize(width: fullSize.width * 0.5,
                                  height: fullSize.height * 0.75)
                } else {
                    return CGSize(width: fullSize.width * 2,
                                  height: fullSize.height * 0.75)
                }
            }
            return super.preferredContentSize
        }
        set {
            super.preferredContentSize = newValue
        }
    }
    
    @IBAction func save(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
