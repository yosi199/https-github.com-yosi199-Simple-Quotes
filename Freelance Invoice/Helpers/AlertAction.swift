//
//  AlertDeletion.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 23/07/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import UIKit

class AlertAction {
    private let title: String
    private let message: String
    private let confirmHandler: ((_ alert: UIAlertAction) -> Void)?
    private let cancellationHandler: ((_ alert: UIAlertAction) -> Void)?
    private let frame: CGRect
    private var positiveButtonText: String
    private var negativeButtonText: String
    
    private init(frame: CGRect, title:String, message: String, positiveButtonText:String, negativeButtonText:String, confirm:  ((_ alert: UIAlertAction) -> Void)?, cancellation:  ((_ alert: UIAlertAction) -> Void)?) {
        self.frame = frame
        self.title = title
        self.message = message
        self.positiveButtonText = positiveButtonText
        self.negativeButtonText = negativeButtonText
        self.confirmHandler = confirm
        self.cancellationHandler = cancellation
    }
    
    func prepare() -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let actionConfirm = UIAlertAction(title: positiveButtonText, style: .destructive, handler: confirmHandler)
        let actionCancel = UIAlertAction(title: negativeButtonText, style: .default, handler: cancellationHandler)
        alert.addAction(actionConfirm)
        alert.addAction(actionCancel)
        return alert
    }
    
    class Builder {
        private var title: String = "Delete Item"
        private var message: String = ""
        private var positiveButtonText: String = "Delete"
        private var negativeButtonText: String = "Cancel"
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
        
        func setPositiveButtonText(text:String) -> Builder {
            self.positiveButtonText = text
            return self
        }
        
        func setNegativeButtonText(text:String) -> Builder {
            self.negativeButtonText = text
            return self
        }
        
        func build() -> AlertAction {
            return AlertAction(frame: frame,
                               title: title,
                               message: message,
                               positiveButtonText: positiveButtonText,
                               negativeButtonText: negativeButtonText,
                               confirm: confirmHandler,
                               cancellation: cancellationHandler)
        }
    }
}
