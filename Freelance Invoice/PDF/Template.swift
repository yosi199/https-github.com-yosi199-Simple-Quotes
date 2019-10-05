//
//  Template.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 08/08/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import TPPDF

protocol Template: FileHandler {
    func setHeader(document: PDFDocument)
    func setContent(document: PDFDocument)
    func setFooter(document: PDFDocument)
}
