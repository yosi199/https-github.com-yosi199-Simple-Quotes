//
//  AnalyticsManager.swift
//  Freelance Invoice
//
//  Created by Yosi Mizrachi on 05/10/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import Firebase

class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    private init(){}
    
    func showPDFScreen(quote: Quote){
         Analytics.logEvent("Show_PDF_Screen", parameters: [
             "name" : "Qoute Line Items",
             "full_text" : "\(quote.items.count)"])
    }
    
    func askingForReview(){
        Analytics.logEvent("Asking_Review_From_USer", parameters: ["name" : "ask_for_review"])
    }
    
    func buyItemSuccess(value: String){
        Analytics.logEvent("User_Bought_Item", parameters: ["name" : value])
    }
    
    func buyItemFailure(value: String){
        Analytics.logEvent("Failed_to_buy_item", parameters: ["name" : value])
    }
    
    func imageSelectedFromQuoteVC(value: String){
        Analytics.logEvent("User_choose_image_from_QuoteVC", parameters: ["name" : value])
    }
    
    func imageSelectedFromSettingsVC(value: String){
         Analytics.logEvent("User_choose_image_from_SettingsVC", parameters: ["name" : value])
     }
    
    func addedToSavedItems(value: String){
        Analytics.logEvent("Added_to_saved_items", parameters: ["name" : value])
    }
}
