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
    private let fontTitle = UIFont.preferredFont(forTextStyle: .largeTitle)
    private let fontBold = UIFont.boldSystemFont(ofSize: 17)
    private let fontNormal = UIFont.systemFont(ofSize: 17)
    private var pageSize: CGSize = CGSize.zero
    
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
        self.pageSize = self.view.frame.size
        
        // set title
        setTitle()
        logo()
        company()
        email()
        client()
        date()
        invoice()
        descriptionString()
        total()
        line()
        quantity()
        value()
        tax()
        drawItems()
        
        // Closes the current PDF context and ends writing to the file.
        UIGraphicsEndPDFContext()
    }
    
    private func setTitle(){
        let property = TextBox(text: "Quote", font: fontTitle).getAttributedText()
        let size = property.size()
        let stringRect = CGRect(x: (pageSize.width / 2) - (size.width / 2), y: 20, width: size.width, height: size.height)
        property.draw(in: stringRect)
    }
    
    private func logo(){
        if let image = UIImage(named: "stumbleupon"){
            let rect = CGRect(x: 50, y: 100, width: 57, height: 57)
            image.scale(with: CGSize(width: 57, height: 57))?.draw(in: rect)
        }
    }
    
    private func company(){
        let property = TextBox(text: quote?.companyName ?? "Company X", font: fontBold).getAttributedText()
        let size = property.size()
        let stringRect = CGRect(x: 50, y: 180, width: size.width, height: size.height)
        property.draw(in: stringRect)
    }
    
    private func email(){
        let property = TextBox(text: quote?.email ?? "companyX@gmail.com", font: fontNormal).getAttributedText()
        let size = property.size()
        let stringRect = CGRect(x: 50, y: 210, width: size.width, height: size.height)
        property.draw(in: stringRect)
    }
    
    private func client(){
        let property = TextBox(text: quote?.clientName ??  "To: John Snow", font: fontNormal).getAttributedText()
        let size = property.size()
        let stringRect = CGRect(x: (pageSize.width / 2), y: 180, width: size.width, height: size.height)
        property.draw(in: stringRect)
    }
    
    private func date(){
        let property = TextBox(text: quote?.date ??  "Date: 29.6.2019", font: fontNormal).getAttributedText()
        let size = property.size()
        let stringRect = CGRect(x: (pageSize.width / 2), y: 210, width: size.width, height: size.height)
        property.draw(in: stringRect)
    }
    
    private func invoice(){
        let property = TextBox(text: quote?.invoiceId ??  "INVC-001", font: fontNormal).getAttributedText()
        let size = property.size()
        let stringRect = CGRect(x: 50, y: 250, width: size.width, height: size.height)
        property.draw(in: stringRect)
    }
    
    func descriptionString(){
        let property = TextBox(text: "Description", font: fontBold).getAttributedText()
        let size = property.size()
        let stringRect = CGRect(x: 50, y: 330, width: size.width, height: size.height)
        property.draw(in: stringRect)
    }
    
    func quantity(){
        let property = TextBox(text: "Qty", font: fontBold).getAttributedText()
        let size = property.size()
        let stringRect = CGRect(x: pageSize.width / 2, y: 330, width: size.width, height: size.height)
        property.draw(in: stringRect)
    }
    
    func value(){
        let property = TextBox(text: "Value", font: fontBold).getAttributedText()
        let size = property.size()
        let stringRect = CGRect(x: pageSize.width / 2 + 80, y: 330, width: size.width, height: size.height)
        property.draw(in: stringRect)
    }
    
    func tax(){
        let property = TextBox(text: "Tax", font: fontBold).getAttributedText()
        let size = property.size()
        let stringRect = CGRect(x: pageSize.width / 2 + 160, y: 330, width: size.width, height: size.height)
        property.draw(in: stringRect)
    }
    
    func total(){
        let property = TextBox(text: "Total", font: fontBold).getAttributedText()
        let size = property.size()
        let stringRect = CGRect(x: (pageSize.width-50) - size.width, y: 330, width: size.width, height: size.height)
        property.draw(in: stringRect)
    }
    
    func line() {
        
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
    
    func drawItems(){
        if let items = quote?.items{
            for (index, item) in items.enumerated() {
                
                let property = TextBox(text: item.title, font: fontNormal).getAttributedText()
                let size = property.size()
                let stringRect = CGRect(x: 50, y: 380 + (CGFloat(index) * (size.height * 1.5)), width: size.width, height: size.height)
                property.draw(in: stringRect)
                
                let qty = TextBox(text: String(item.qty), font: fontNormal).getAttributedText()
                let qtySize = qty.size()
                let qtyRect = CGRect(x: pageSize.width / 2, y: 380 + (CGFloat(index) * (qtySize.height * 1.5)), width: qtySize.width, height: qtySize.height)
                qty.draw(in: qtyRect)
                
                let value = TextBox(text: String(item.value), font: fontNormal).getAttributedText()
                let valueSize = value.size()
                let valueRect = CGRect(x: pageSize.width / 2 + 80, y: 380 + (CGFloat(index) * (valueSize.height * 1.5)), width: valueSize.width, height: valueSize.height)
                value.draw(in: valueRect)
                
                let tax = TextBox(text: String(item.tax), font: fontNormal).getAttributedText()
                let taxSize = tax.size()
                let taxRect = CGRect(x: pageSize.width / 2 + 160, y: 380 + (CGFloat(index) * (taxSize.height * 1.5)), width: taxSize.width, height: taxSize.height)
                tax.draw(in: taxRect)
                
                let total = TextBox(text: String(item.total), font: fontNormal).getAttributedText()
                let totalSize = total.size()
                let totalRect = CGRect(x: (pageSize.width-50) - size.width, y: 380 + (CGFloat(index) * (totalSize.height * 1.5)), width: totalSize.width, height: totalSize.height)
                total.draw(in: totalRect)
            }
        }
    }
    
    class TextBox {
        let text:String
        private let attributedText: NSAttributedString
        
        init(text:String, font: UIFont) {
            self.text = text
            self.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
        }
        
        func getAttributedText() -> NSAttributedString{
            return attributedText
        }
    }
}


