//
//  CurrencyList.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 04/08/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit

class CurrencyList: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    private let items = Locale.commonISOCurrencyCodes
    var currencySelected: ((_ locale: Locale, _ currency: String) -> Void)?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        shadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        shadow()
    }
    
    private func shadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as? CurrencyCell else { return UITableViewCell() }
        
        let country = codeToCountry[items[indexPath.row]] ?? ""
        if let locale = CurrencyHelper.shared.getLocale(forCurrencyCode: items[indexPath.row] ){
            cell.currencySymbol.text = locale.currencySymbol
        }
        
        cell.currencyTitle.text = country
        cell.currencyDescription.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let locale = CurrencyHelper.shared.getLocale(forCurrencyCode: items[indexPath.row] ){
            currencySelected?(locale, (locale.currencySymbol ?? ""))
        }
    }
    
    func flag(from country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }

}
