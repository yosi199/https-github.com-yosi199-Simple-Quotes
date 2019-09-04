//
//  ReviewSuggester.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 04/09/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

class ReviewSuggester {
    
    private static let THRESHOLD = 5
    
    func maybeAskForReview(invoicesLeft: Int, delay: Double) {
        let currentVersion = getCurrentAppVersion()
        let showForVersion = maybeShowForVersion(currentAppVersion: currentVersion)
        
        if(showForVersion && invoicesLeft == ReviewSuggester.THRESHOLD) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: {
                SKStoreReviewController.requestReview()
                UserDefaults.standard.set(currentVersion, forKey: lastVersionPromptedForReviewKey)
            })
        }
    }
    
    private func getCurrentAppVersion() -> String {
        let infoDictionaryKey = kCFBundleVersionKey as String
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String
            else { fatalError("Expected to find a bundle version in the info dictionary") }
        return currentVersion
    }
    
    private func maybeShowForVersion(currentAppVersion: String) -> Bool {
        return currentAppVersion != UserDefaults.standard.string(forKey: lastVersionPromptedForReviewKey)
        
    }
}
