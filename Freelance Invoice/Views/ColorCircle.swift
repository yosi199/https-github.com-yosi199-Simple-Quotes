//
//  ColorCircle.swift
//  Freelance Invoice
//
//  Created by Yosi Mizrachi on 16/10/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

@IBDesignable class ColorCircle: UIView {
    
    private var circleView: UIView!
    var chosenColorCallback: ((_ color: UIColor) -> Void)?

    @IBInspectable var colorOption: UIColor = .blue {
      didSet {
        circleView.backgroundColor = self.colorOption
      }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        common()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        common()
    }
    
    private func common(){
        circleView = UIView(frame: CGRect(x: self.frame.midX, y: self.frame.midY, width: 50, height: 50))
        circleView.backgroundColor = .orange
        addSubview(circleView)
        
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        circleView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        circleView.layer.cornerRadius = 25
        circleView.layer.borderColor = UIColor.gray.cgColor
        circleView.layer.borderWidth = 2.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selected))
        self.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func selected(){
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }) { (Bool) in
            self.chosenColorCallback?(self.colorOption)
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.transform = .identity
            }, completion: nil)
        }
    }
    
    override func prepareForInterfaceBuilder() {
        common()
    }
}
