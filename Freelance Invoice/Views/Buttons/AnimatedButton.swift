//
//  AnimatedBUtton.swift
//  Freelance Invoice
//
//  Created by Yosi Mizrachi on 15/10/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit

class AnimatedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonSetup()
    }
    
    private func commonSetup(){
        addTarget(self, action: #selector(down), for: .touchDown)
        addTarget(self, action: #selector(up), for: .touchUpInside)
    }
    
    @objc func down(){
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }, completion: nil)
    }
    
    @objc func up(){
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.transform = .identity
        }, completion: nil)
    }
    
}
