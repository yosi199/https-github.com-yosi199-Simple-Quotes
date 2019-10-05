//
//  AlertDeletion.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 23/07/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import UIKit

class AlertDeletion {
    private let title: String
    private let message: String
    private let confirmHandler: ((_ alert: UIAlertAction) -> Void)?
    private let cancellationHandler: ((_ alert: UIAlertAction) -> Void)?
    private let frame: CGRect
    
    private init(frame: CGRect, title:String, message: String, confirm:  ((_ alert: UIAlertAction) -> Void)?, cancellation:  ((_ alert: UIAlertAction) -> Void)?) {
        self.frame = frame
        self.title = title
        self.message = message
        self.confirmHandler = confirm
        self.cancellationHandler = cancellation
    }
    
    func prepare() -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let actionConfirm = UIAlertAction(title: "Delete", style: .destructive, handler: confirmHandler)
        let actionCancel = UIAlertAction(title: "Cancel", style: .destructive, handler: cancellationHandler)
        alert.addAction(actionConfirm)
        alert.addAction(actionCancel)
        return alert
    }
    
    class Builder {
        private var title: String = "Delete Item"
        private var message: String = ""
        private var confirmHandler: ((_ alert: UIAlertAction) -> Void)? = nil
        private var cancellationHandler: ((_ alert: UIAlertAction) -> Void)? = nil
        private let frame: CGRect
        
        init(frame: CGRect) {
            self.frame = frame
        }
        
        func setTitle(title: String) -> Builder {
            self.title = title
            return self
        }
        
        func setMessage(message: String) -> Builder {
            self.message = message
            return self
        }
        
        func setConfirmationHandler(handler: @escaping (_ alert: UIAlertAction) -> Void) -> Builder {
            self.confirmHandler = handler
            return self
        }
        
        func setCancellationHandler(handler: @escaping (_ alert: UIAlertAction) -> Void) -> Builder {
            self.cancellationHandler = handler
            return self
        }
        
        func build() -> AlertDeletion {
            return AlertDeletion(frame: frame, title: title, message: message, confirm: confirmHandler, cancellation: cancellationHandler)
        }
    }
}
