//
//  Template1.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 08/08/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import TPPDF

class Template1: Template {
    private let factory = TextFactory.shared
    private let locale = Locale(identifier: DataRepository.Defaults.shared.localeIdentifier)
    let quote: Quote
    
    init(quote: Quote) {
        self.quote = quote
    }
    
    func setHeader(document: PDFDocument) {
        // Header/Title
        document.add(.headerLeft, attributedText: factory.normal(text: "\(quote.companyName)", size: .extra))
        if let uiImage = UIImage(contentsOfFile: getFileForName(name: COMPANY_LOGO).path){
            let image = PDFImage(image: uiImage)
            image.size = CGSize(width: 80, height: 80)
            image.quality = 0.8
            image.sizeFit = .widthHeight
            document.add(.headerRight, image: image)
        }
        
        // Header section split
        let section = PDFSection(columnWidths: [0.5, 0.5])
        section.columns[0].add(.left, attributedText: factory.normal(text: "\(quote.address)"))
        section.columns[0].add(space: 2)
        
        section.columns[1].add(.right, attributedText: factory.normal(text: "\(quote.date)"))
        section.columns[1].add(space: 2)
        
        document.add(section: section)
        
        // Header section split 2
        let section2 = PDFSection(columnWidths: [0.5, 0.5])
        section.columns[0].add(.left, attributedText: factory.normal(text: "\(quote.email)"))
        section.columns[1].add(.right, attributedText: factory.normal(text: "\(DataRepository.Defaults.shared.quoteIDPrefix) \(quote.invoiceId)"))
        document.add(section: section2)
        
        // Some spacing from headers
        document.add(space: 50)
        
        // Customer info
        let group = PDFGroup(allowsBreaks: false, backgroundColor: #colorLiteral(red: 0.9568627451, green: 0.7921568627, blue: 0.2823529412, alpha: 1), backgroundImage: nil, backgroundShape: nil, outline: .none, padding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 100))
        group.add(attributedText: factory.bold(text: "CUSTOMER", size: .small))
        document.add(group: group)
        document.add(space: 10)
        
        // Some spacing from customer info
        document.add(space: 50)
        
    }
    
    func setContent(document: PDFDocument) {
        // Items data table - where we list all of the LineItemModels.
        document.add(.contentCenter, table: lineItemsTable())
        
        document.add(space: 100)
        
        // Notes and Summary sections
        let summarySection = PDFSection(columnWidths: [0.6, 0.2, 0.2])
        summarySection.columnMargin = 5
        summarySection.columns[0].add(.left, attributedText: factory.normal(text: "TERMS AND CONDITIONS:", size: .medium))
        summarySection.columns[0].add(space: 4)
        summarySection.columns[0].add(.left, attributedText:  factory.normal(text: "\(quote.notes)", size: .medium))
        
        summarySection.columns[1].add(.left, attributedText:  factory.normal(text: "SubTotal:", size: .medium))
        summarySection.columns[1].add(space: 4)
        
        summarySection.columns[1].add(.left, attributedText:  factory.normal(text: "Discount:", size: .medium))
        summarySection.columns[1].add(space: 4)
        
        summarySection.columns[1].add(.left, attributedText:  factory.normal(text: "Tax:", size: .medium))
        summarySection.columns[1].add(space: 4)
        
        summarySection.columns[1].add(.left, attributedText:  factory.normal(text: "Tax Rate:", size: .medium))
        summarySection.columns[1].add(space: 4)
        
        summarySection.columns[1].add(.left, attributedText:  factory.bold(text: "Total Due:", size: .medium))
        summarySection.columns[1].add(space: 4)
        
        summarySection.columns[2].add(.left, attributedText:  factory.normal(text: quote.items.toArray().getSubTotal().toCurrency(locale: locale), size: .medium))
        summarySection.columns[2].add(space: 4)
        
        summarySection.columns[2].add(.left, attributedText:  factory.normal(text: quote.discountAmount.toCurrency(locale: locale), size: .medium))
        summarySection.columns[2].add(space: 4)
        
        summarySection.columns[2].add(.left, attributedText:  factory.normal(text: quote.taxAmount.toCurrency(locale: locale), size: .medium))
        summarySection.columns[2].add(space: 4)
        
        summarySection.columns[2].add(.left, attributedText:  factory.normal(text: String(format: "%.2f%%", quote.taxPercentage), size: .medium))
        summarySection.columns[2].add(space: 4)
        
        summarySection.columns[2].add(.left, attributedText:  factory.normal(text: quote.getTotal().toCurrency(locale: locale), size: .medium))
        summarySection.columns[2].add(space: 4)
        
        document.add(section: summarySection)
    }
    
    func setFooter(document: PDFDocument) {
        document.add(.footerCenter, attributedText: factory.normal(text: "Created with \(APP_NAME) app.", size: .small))
    }
    
    private func buildData() -> ([[String]], [[PDFTableCellAlignment]]) {
        var value = [[String]]()
        var alignments = [[PDFTableCellAlignment]]()
        
        // Add the table header columns first
        value.append(["ITEM", "QTY", "VALUE", "AMOUNT"])
        alignments.append([.center, .center, .center, .center])
        
        // Add actual data.
        quote.items.forEach({ (item) in
            value.append([item.itemDescription, String(item.qty), item.value.toString(), item.total.toString()])
            alignments.append([.left, .center, .center, .center])
        })
        
        return(values: value, alignments: alignments)
    }
    
    private func lineItemsTable() -> PDFTable{
        
        // Create a table
        let table = PDFTable()
        
        // Tables can contain Strings, Numbers, Images or nil, in case you need an empty cell. If you add a unknown content type, an error will be thrown and the rendering will stop.
        do {
            let data = self.buildData()
            try table.generateCells(data: data.0, alignments: data.1)
        } catch PDFError.tableContentInvalid(let value) {
            // In case invalid input is provided, this error will be thrown.
            print("This type of object is not supported as table content: " + String(describing: (type(of: value))))
        } catch {
            // General error handling in case something goes wrong.
            print("Error while creating table: " + error.localizedDescription)
        }
        
        // The widths of each column is proportional to the total width, set by a value between 0.0 and 1.0, representing percentage.
        table.widths = [0.55, 0.15, 0.15, 0.15]
        
        // To speed up table styling, use a default and change it
        let style = PDFTableStyleDefaults.simple
        
        // Simply set the amount of footer and header rows
        style.columnHeaderCount = 1
        
        style.alternatingContentStyle?.colors.fill = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        style.columnHeaderStyle.colors.fill = #colorLiteral(red: 0.9568627451, green: 0.7921568627, blue: 0.2823529412, alpha: 1)
        style.columnHeaderStyle.colors.text = UIColor.black
        style.columnHeaderStyle.font = UIFont.init(name: "ArialRoundedMTBold", size: 10)!
        
        style.contentStyle.colors.fill = UIColor.white
        style.contentStyle.font = UIFont.init(name: "ArialMT", size: 10)!
        
        style.alternatingContentStyle?.font = UIFont.init(name: "ArialMT", size: 10)!
        style.rowHeaderStyle.font = UIFont.init(name: "ArialMT", size: 10)!
        style.rowHeaderStyle.borders = PDFTableCellBorders.init()
        
        style.footerStyle.font = UIFont.init(name: "ArialRoundedMTBold", size: 10)!
        
        style.outline = PDFLineStyle.init(type: .full, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), width: 0.5, radius: 0.5)
        table.style = style
        
        //        do {
        //            // Style each cell individually
        //            //            try table.setCellStyle(row: 1, column: 1, style: PDFTableCellStyle(colors: (fill: UIColor.yellow, text: UIColor.black)))
        //        } catch PDFError.tableIndexOutOfBounds(let index, let length){
        //            // In case the index is out of bounds
        //            print("Requested cell is out of bounds! \(index) / \(length)")
        //        } catch {
        //            // General error handling in case something goes wrong.
        //            print("Error while setting cell style: " + error.localizedDescription)
        //        }
        
        // Set table padding and margin
        table.padding = 5.0
        //        table.margin = 10.0
        
        // In case of a linebreak during rendering we want to have table headers on each page.
        table.showHeadersOnEveryPage = true
        return table
    }
    
    
}
