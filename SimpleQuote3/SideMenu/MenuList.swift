//
//  MenuList.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 23/07/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class MenuList : ResizeableTableViewTableViewController, UITableViewDelegate , UITableViewDataSource {
    
    var items = [Quote]()
    var loadQuoteCallback: ((_ item: Quote, _ indexPath: IndexPath)-> Void)?
    var deleteQuoteCallback: ((_ item: Quote, _ indexPath: IndexPath)-> Void)?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? QuoteCellItemTableViewCell else {  return UITableViewCell() }
        let item = items[indexPath.row]
        cell.clientName.text = item.clientName
        cell.date.text = item.date
        cell.itemsCount.text = "Items: \(String(item.items.count))"
        let sum: Double = item.items.sum(ofProperty: "total")
        cell.totalValue.text = String(sum.rounded(toPlaces: 2))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        self.loadQuoteCallback?(item, indexPath)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items[indexPath.row]
            items.remove(at: indexPath.row)
            deleteQuoteCallback?(item, indexPath)
            isEditing.toggle()
            reloadData()
        }
    }
}
