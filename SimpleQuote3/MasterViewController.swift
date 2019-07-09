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
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "QuoteCellItemTableViewCell", bundle: nil), forCellReuseIdentifier: "cell1")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as? QuoteCellItemTableViewCell else {  return UITableViewCell() }
        let item = items[indexPath.row]
        cell.clientName.text = item.clientName
        cell.date.text = item.date
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailViewController = parent?.splitViewController?.children[1].children[0] as? DetailViewController else { return }
        let item = items[indexPath.row]
        detailViewController.loadQuote(existing: item)
    }
}


