//
//  PDFController.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 20/06/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit
import PDFKit

class PDFController: UIViewController {
    
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
        
        
        create()
        if let path = self.getFilePath() {
            let document =  PDFDocument(url: path)!
            pdfView.document = document
        }
    }
    
    private func getFilePath() -> URL? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        return documentsDirectory.appendingPathComponent("foo.pdf")
    }
    
    private func createActualPDFFile(){
        if let path = getFilePath()?.path{
            // Creates a new PDF file at the specified path.
            UIGraphicsBeginPDFContextToFile(path, self.view.frame, getMetaData())
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
    
    private func create(){
        
        let pdfTitle = "Quote"
        
        createActualPDFFile()
        
        // Creates a new page in the current PDF context.
        UIGraphicsBeginPDFPage()
        
        // Default size of the page is 612x72.
        let pageSize = self.view.frame.size
        let font = UIFont.preferredFont(forTextStyle: .largeTitle)
        
        // Let's draw the title of the PDF on top of the page.
        let attributedPDFTitle = NSAttributedString(string: pdfTitle, attributes: [NSAttributedString.Key.font: font])
        let stringSize = attributedPDFTitle.size()
        let stringRect = CGRect(x: (pageSize.width / 2) - (stringSize.width / 2), y: 20, width: stringSize.width, height: stringSize.height)
        attributedPDFTitle.draw(in: stringRect)
        
        // Closes the current PDF context and ends writing to the file.
        UIGraphicsEndPDFContext()
    }
    
}
