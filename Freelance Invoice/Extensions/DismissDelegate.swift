//
//  DismissDelegate.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 18/08/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import UIKit

protocol DismissalDelegate : class
{
    func finishedShowing(viewController: UIViewController);
}

protocol Dismissable : class
{
    var dismissalDelegate : DismissalDelegate? { get set }
}

extension DismissalDelegate where Self: UIViewController
{
    func finishedShowing(viewController: UIViewController) {
        if viewController.isBeingPresented && viewController.presentingViewController == self
        {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}
