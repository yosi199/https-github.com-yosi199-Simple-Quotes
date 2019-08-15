/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Retrieves product information from the App Store using SKRequestDelegate, SKProductsRequestDelegate, SKProductsResponse, and SKProductsRequest.
 Notifies its observer with a list of products available for sale along with a list of invalid product identifiers. Logs an error message if the
 product request failed.
 */

import StoreKit
import Foundation

class StoreManager: NSObject {
    // MARK: - Types
    
    static let shared = StoreManager()
    
    fileprivate var productRequest: SKProductsRequest!
    fileprivate var availableProducts = [SKProduct]()
//    fileprivate var storeResponse = [Section]()
    /// Keeps track of all invalid product identifiers.
    fileprivate var invalidProductIdentifiers = [String]()
//    weak var delegate: StoreManagerDelegate?

    
    // MARK: - Initializer
    private override init() {}
    
    func fetchProducts(matchingIdentifiers identifiers: [String]) {
        // Create a set for the product identifiers.
        let productIdentifiers = Set(identifiers)
        
        // Initialize the product request with the above identifiers.
        productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest.delegate = self
        
        // Send the request to the App Store.
        productRequest.start()
    }
    
}

extension StoreManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let available = response.products
        
        available.forEach { (product) in
            print("Identifier: \(product.productIdentifier)")
            print("Regular price: \(product.regularPrice)")
            
            StoreObserver.shared.buy(product)
        }
        
//        if !storeResponse.isEmpty {
//            storeResponse.removeAll()
//        }
//
//        // products contains products whose identifiers have been recognized by the App Store. As such, they can be purchased.
//        if !response.products.isEmpty {
//            availableProducts = response.products
//            storeResponse.append(Section(type: .availableProducts, elements: availableProducts))
//        }
//
//        // invalidProductIdentifiers contains all product identifiers not recognized by the App Store.
//        if !response.invalidProductIdentifiers.isEmpty {
//            invalidProductIdentifiers = response.invalidProductIdentifiers
//            storeResponse.append(Section(type: .invalidProductIdentifiers, elements: invalidProductIdentifiers))
//        }
//
//        if !storeResponse.isEmpty {
//            DispatchQueue.main.async {
//                self.delegate?.storeManagerDidReceiveResponse(self.storeResponse)
//            }
//        }
    }
    
    
    
}

// MARK: - SKProduct
extension SKProduct {
    /// - returns: The cost of the product formatted in the local currency.
    var regularPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)
    }
}


