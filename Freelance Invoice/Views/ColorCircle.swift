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
    }
    
    override func prepareForInterfaceBuilder() {
        common()
    }
}
