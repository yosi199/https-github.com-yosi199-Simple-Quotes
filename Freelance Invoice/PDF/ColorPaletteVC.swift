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
    
    var chosenColorCallback: ((_ color: UIColor) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.arrangedSubviews.forEach { (circle) in
            guard let circle = circle as? ColorCircle else { return }
            circle.chosenColorCallback = { color, circle in
                self.chosenColorCallback?(color)
                self.selectCircle(selectedCircle: circle)
            }
        }
    }
    
    private func selectCircle(selectedCircle: ColorCircle){
        stackView.arrangedSubviews.forEach { (colorCircle) in
            guard let circle = colorCircle as? ColorCircle else { return }
            circle.deSelect()
        }
        selectedCircle.select()
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
