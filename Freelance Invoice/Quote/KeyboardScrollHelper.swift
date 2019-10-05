//
//  KeyboardScrollHelper.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 08/08/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import UIKit

class KeyboardScrollHelper {
    
    private var activeField: UIView?
    private var scrollView: UIScrollView?
    private var hostView: UIView?
    
    func register(hostView: UIView, scrollView: UIScrollView){
        self.hostView = hostView
        self.scrollView = scrollView
        registerForKeyboardNotifications()
    }
    
    func unregister(){
        unregisterForKeyboardNotifications()
    }
    
    private func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterForKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let scrollView = self.scrollView, let view = self.hostView else { return }
        //Need to calculate keyboard exact size due to Apple suggestions
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            
            var aRect : CGRect = view.frame
            aRect.size.height -= keyboardSize!.height
            if self.activeField != nil
            {
                if (!aRect.contains(self.activeField!.frame.origin))
                {
                    scrollView.scrollRectToVisible(self.activeField!.frame, animated: true)
                }
            }
        })
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let scrollView = self.scrollView, let view = self.hostView else { return }

        //Once keyboard disappears, restore original positions
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(field: UIView!){
        activeField = field
    }
    
    func textFieldDidEndEditing(field: UIView!){
        activeField = nil
    }
    
    
}
