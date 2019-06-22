//
//  PDFController.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 20/06/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit
import PDFKit
import CoreGraphics

class PDFController: UIViewController, FileHandler {
    
    private var filePath: URL?
    var quote: Quote? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pdfView = PDFView(frame: self.view.frame)
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.frame.size = self.view.frame.size
        self.view.addSubview(pdfView)
        
        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        if let path = getFilePath() {
            let document =  PDFDocument(url: path)
            pdfView.document = document
            beginWritingPDFContext(path: path)
            create()
            
        }
    }
    
    private func getMetaData() -> [AnyHashable : Any] {
        let pdfMetadata = [
            // The name of the application creating the PDF.
            kCGPDFContextCreator: "Your iOS App",
            
            // The name of the PDF's author.
            kCGPDFContextAuthor: "Foo Bar",
            
            // The title of the PDF.
            kCGPDFContextTitle: "Lorem Ipsum",
            
            // Encrypts the document with the value as the owner password. Used to enable/disable different permissions.
            kCGPDFContextOwnerPassword: "myPassword123"
        ]
        return pdfMetadata
    }
    
    private func getFilePath() -> URL? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        return documentsDirectory.appendingPathComponent("invoice.pdf") // MARK: get name dynamically from quote
    }
    
    private func beginWritingPDFContext(path:URL){
        UIGraphicsBeginPDFContextToFile(path.path, self.view.frame, getMetaData())
    }
    
    private func create(){
        
        // Creates a new page in the current PDF context.
        //        UIGraphicsBeginPDFPageWithInfo(self.view.frame, nil)
        UIGraphicsBeginPDFPage()
        
        // Default size of the page is 612x72.
        let pageSize = self.view.frame.size
        
        // set title
        setTitle(pageSize: pageSize)
        logo(pageSize: pageSize)
        company(pageSize: pageSize)
        email(pageSize: pageSize)
        client(pageSize: pageSize)
        date(pageSize: pageSize)
        invoice(pageSize: pageSize)
        descriptionString(pageSize: pageSize)
        total(pageSize: pageSize)
        line(pageSize: pageSize)
        
        
        // Closes the current PDF context and ends writing to the file.
        UIGraphicsEndPDFContext()
    }
    
    private func setTitle(pageSize: CGSize){
        let pdfTitle = "Quote"
        let font = UIFont.preferredFont(forTextStyle: .largeTitle)
        
        // Let's draw the title of the PDF on top of the page.
        let attributedPDFTitle = NSAttributedString(string: pdfTitle, attributes: [NSAttributedString.Key.font: font])
        let stringSize = attributedPDFTitle.size()
        let stringRect = CGRect(x: (pageSize.width / 2) - (stringSize.width / 2), y: 20, width: stringSize.width, height: stringSize.height)
        attributedPDFTitle.draw(in: stringRect)
    }
    
    private func logo(pageSize: CGSize){
        if let image = UIImage(named: "stumbleupon"){
            let rect = CGRect(x: 50, y: 100, width: 57, height: 57)
            image.scale(with: CGSize(width: 57, height: 57))?.draw(in: rect)
        }
    }
    
    private func company(pageSize:CGSize){
        let companyName = "Company X"
        
        let font = UIFont.boldSystemFont(ofSize: 17)
        
        // Let's draw the title of the PDF on top of the page.
        let attributedCompanyName = NSAttributedString(string: companyName, attributes: [NSAttributedString.Key.font: font])
        let stringSize = attributedCompanyName.size()
        let stringRect = CGRect(x: 50, y: 180, width: stringSize.width, height: stringSize.height)
        attributedCompanyName.draw(in: stringRect)
    }
    
    private func email(pageSize:CGSize){
        let email = "companyX@gmail.com"
        
        let font = UIFont.systemFont(ofSize: 17)
        
        // Let's draw the title of the PDF on top of the page.
        let attributedEmail = NSAttributedString(string: email, attributes: [NSAttributedString.Key.font: font])
        let stringSize = attributedEmail.size()
        let stringRect = CGRect(x: 50, y: 210, width: stringSize.width, height: stringSize.height)
        attributedEmail.draw(in: stringRect)
    }
    
    private func client(pageSize:CGSize){
        let email = "To: John Snow"
        
        let font = UIFont.systemFont(ofSize: 17)
        
        // Let's draw the title of the PDF on top of the page.
        let attributedEmail = NSAttributedString(string: email, attributes: [NSAttributedString.Key.font: font])
        let stringSize = attributedEmail.size()
        let stringRect = CGRect(x: (pageSize.width / 2), y: 180, width: stringSize.width, height: stringSize.height)
        attributedEmail.draw(in: stringRect)
    }
    
    private func date(pageSize:CGSize){
        let date = "Date: 29.6.2019"
        
        let font = UIFont.systemFont(ofSize: 17)
        
        // Let's draw the title of the PDF on top of the page.
        let attributedDate = NSAttributedString(string: date, attributes: [NSAttributedString.Key.font: font])
        let stringSize = attributedDate.size()
        let stringRect = CGRect(x: (pageSize.width / 2), y: 210, width: stringSize.width, height: stringSize.height)
        attributedDate.draw(in: stringRect)
    }
    
    private func invoice(pageSize:CGSize){
        let invoice = "INVC-001"
        
        let font = UIFont.systemFont(ofSize: 17)
        
        // Let's draw the title of the PDF on top of the page.
        let attributedInvoice = NSAttributedString(string: invoice, attributes: [NSAttributedString.Key.font: font])
        let stringSize = attributedInvoice.size()
        let stringRect = CGRect(x: 50, y: 250, width: stringSize.width, height: stringSize.height)
        attributedInvoice.draw(in: stringRect)
    }
    
    func descriptionString(pageSize:CGSize){
        let descriptionTitle = "Description"
        
        let font = UIFont.boldSystemFont(ofSize: 17)
        
        // Let's draw the title of the PDF on top of the page.
        let attributedDescriptionTitle = NSAttributedString(string: descriptionTitle, attributes: [NSAttributedString.Key.font: font])
        let stringSize = attributedDescriptionTitle.size()
        let stringRect = CGRect(x: 50, y: 330, width: stringSize.width, height: stringSize.height)
        attributedDescriptionTitle.draw(in: stringRect)
    }
    
    func total(pageSize:CGSize){
        let total = "Total"
        
        let font = UIFont.boldSystemFont(ofSize: 17)
        
        // Let's draw the title of the PDF on top of the page.
        let attributedTotal = NSAttributedString(string: total, attributes: [NSAttributedString.Key.font: font])
        let stringSize = attributedTotal.size()
        let stringRect = CGRect(x: (pageSize.width-50) - stringSize.width, y: 330, width: stringSize.width, height: stringSize.height)
        attributedTotal.draw(in: stringRect)
    }
    
    func line(pageSize:CGSize) {
        
        /* Get the current graphics context */
        if let currentContext = UIGraphicsGetCurrentContext(){
            /* Set the width for the line */
            currentContext.setLineWidth(0.8)
            /* Start the line at this point */
            currentContext.move(to: CGPoint( x: 50.0, y: 360))
            /* And end it at this point */
            currentContext.addLine(to: CGPoint(x: pageSize.width - 50.0, y: 360))
            /* Use the context's current color to draw the line */
            currentContext.strokePath()
        }
    }
}


