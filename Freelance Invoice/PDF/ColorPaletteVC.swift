//
//  ColorPaletteVCViewController.swift
//  Freelance Invoice
//
//  Created by Yosi Mizrachi on 16/10/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit

class ColorPaletteVC: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var contentView: UIView!
    
    var chosenColorCallback: ((_ color: UIColor) -> Void)? {
        didSet {
            stackView.arrangedSubviews.forEach { (circle) in
                guard let circle = circle as? ColorCircle else { return }
                circle.chosenColorCallback = chosenColorCallback
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
