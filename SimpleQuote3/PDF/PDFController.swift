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

class PDFController: UIViewController {
    
    var quote: Quote? = nil
    var template: Template?
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    private var url: URL?
    private let factory = TextFactory.shared
    
    @IBAction func shareAction(_ sender: Any) {
        if let url = self.url{
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            activityVC.popoverPresentationController?.barButtonItem = shareButton
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If for some reason our quote is unavailable - go back
        let user = UserRepository.shared.getUser()
        guard let quote = self.quote else {
            // TODO - show error alert
            dismiss(animated: true, completion: nil)
            return }
        self.template =  Template1(quote: quote, user: user)
        
        let document = PDFDocument(format: .a4)

        template?.setHeader(document: document)
        template?.setContent(document: document)
        template?.setFooter(document: document)
        
  
        generate(document: document)
    }
    
    private func generate(document: PDFDocument){
        do {
            url = try PDFGenerator.generateURL(document: document, filename: "Example.pdf")
            webview.loadFileURL(url!, allowingReadAccessTo: url!)
        } catch {
            print("Error while generating PDF: " + error.localizedDescription)
            
        }
    }
    

}
