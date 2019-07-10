//
//  MasterViewController.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 19/06/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit
import RealmSwift

class MasterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    private let realm = try! Realm()
    private lazy var items:  Results<Quote> = {
        return realm.objects(Quote.self)
    }()
    
    private lazy var detailViewController: DetailViewController = {
        return parent?.splitViewController?.children[1].children[0] as! DetailViewController
    }()
    
    override func viewDidLoad() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "QuoteCellItemTableViewCell", bundle: nil), forCellReuseIdentifier: "cell1")
        
        title = "Menu"
    }
    @IBAction func addClicked(_ sender: Any) {
        try! realm.write {
            let emptyQuote = Quote.getEmpty()
            DataRepository.shared.saveQuote(quote: emptyQuote)
            detailViewController.loadQuote(existing: emptyQuote)
            reloadData()
        }
    }
    
    @IBAction func deleteClicked(_ sender: Any) {
        tableView.isEditing.toggle()
    }
    func reloadData(){
        tableView.reloadData()
    }
    
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
        guard let detailViewController = parent?.splitViewController?.children[1].children[0] as? DetailViewController else { return }
        let item = items[indexPath.row]
        detailViewController.loadQuote(existing: item)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write {
                DataRepository.shared.remove(quote: items[indexPath.row])
                reloadData()
            }
        }
    }
}


