//
//  PDFController.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 08/08/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit
import TPPDF
import WebKit
import StoreKit

class PDFController: UIViewController {
    
    var quote: Quote? = nil
    var template: Template?
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var colorPaletteButton: UIBarButtonItem!
    @IBOutlet weak var colorPaletteContainerView: UIView!
    @IBOutlet weak var colorPaletteHeight: NSLayoutConstraint!
    private var url: URL?
    private var userSelectedColor: UIColor? = UserRepository.Defaults.shared.pdfColor
    private let factory = TextFactory.shared
    
    // IN APP Purchases
    private var products: [SKProduct]?
    
    // App review
    var maybeShowReview: ((_ invoicesLeft: Int) -> Void)?
    
    @IBAction func shareAction(_ sender: Any) {
        if let url = self.url{
            if (BuyInvoicesHelper.shared.getAvailableInvoicesCount() <= 0){
                StoreManager.shared.delegate = self
                fetchProducts()
                return
            } else{
                let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                activityVC.popoverPresentationController?.barButtonItem = shareButton
                activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
                    if completed { BuyInvoicesHelper.shared.useOneInvoice()
                        self.maybeShowReview?(BuyInvoicesHelper.shared.getAvailableInvoicesCount())
                    }
                }
                self.present(activityVC, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination.children.count > 0){
            if let vc = segue.destination.children[0] as? BuyInvoicesVC {
                vc.products = products
                vc.dismissalDelegate = self
            }
        }
    }
    
    @IBAction func pickColor(_ sender: Any) {
        perform(#selector(showColorPalette), with: nil, afterDelay: 0.3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCallbacks()
        self.create()
        
        self.colorPaletteContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(tap)
        
        if #available(iOS 13.0, *) {
            self.colorPaletteButton.image = UIImage(systemName: "circle.grid.3x3")
        } else {
            self.colorPaletteButton.image = UIImage(named: "circle.grid.3x3")
        }
        
    }
    
    private func create(){
        // If for some reason our quote is unavailable - go back
        let user = UserRepository.shared.getUser()
        guard let quote = self.quote else {
            // TODO - show error alert
            dismiss(animated: true, completion: nil)
            return }
        self.template =  Template1(quote: quote, user: user)
        
        let document = PDFDocument(format: .a4)
        
        if let color = userSelectedColor {
            template?.setColor(color: color)
        }
        template?.setHeader(document: document)
        template?.setContent(document: document)
        template?.setFooter(document: document)
        
        generate(document: document)
    }
    
    private func setupCallbacks(){
        guard let colorPaletteVC = self.children[0] as? ColorPaletteVC else { return }
        colorPaletteVC.chosenColorCallback = { color in
            self.userSelectedColor = color
            self.create()
        }
    }
    
    @objc fileprivate func viewTapped(){
        if(self.colorPaletteHeight.constant == 80){
            hideColorPalette()
        }
    }
    
    @objc fileprivate func showColorPalette(){
        // Do any additional setup after loading the view.
        self.colorPaletteHeight.isActive = false
        self.colorPaletteHeight = self.colorPaletteContainerView.heightAnchor.constraint(equalToConstant: 80)
        self.colorPaletteHeight.isActive = true
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.colorPaletteContainerView.alpha = 1
            self.view.layoutIfNeeded()
        }) { (Bool) in}
    }
    
    @objc fileprivate func hideColorPalette(){
        // Do any additional setup after loading the view.
        self.colorPaletteHeight.isActive = false
        self.colorPaletteHeight = self.colorPaletteContainerView.heightAnchor.constraint(equalToConstant: 0)
        self.colorPaletteHeight.isActive = true
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.colorPaletteContainerView.alpha = 0
            self.view.layoutIfNeeded()
        }) { (Bool) in}
    }
    
    private func generate(document: PDFDocument){
        do {
            let fileName = DataRepository.Defaults.shared.quoteIDPrefix + String(quote?.invoiceId ?? "")
            url = try PDFGenerator.generateURL(document: document, filename: "\(fileName).pdf")
            webview.loadFileURL(url!, allowingReadAccessTo: url!)
        } catch {
            print("Error while generating PDF: " + error.localizedDescription)
            
        }
    }
    
    fileprivate func fetchProducts(){
        if StoreObserver.shared.isAuthorizedForPayments {
            let productsResource = ProductIdentifiers()
            guard let identifiers = productsResource.identifiers else {
                // Warn the user that the resource file could not be found.
                print("Identifiers not found")
                return
            }
            
            if !identifiers.isEmpty {
                StoreManager.shared.fetchProducts(matchingIdentifiers: identifiers)
            }
        }
    }
    
}

extension PDFController : StoreManagerDelegate {
    func noAvailableProductsFound() {
        
    }
    
    func onAvailableProducts(products: [SKProduct]) {
        self.products = products
        performSegue(withIdentifier: "buyVC", sender: self)
    }
}

extension PDFController : DismissalDelegate {
    
    func finishedShowing(viewController: UIViewController){
        viewController.dismiss(animated: true, completion: nil)
    }
    
}
