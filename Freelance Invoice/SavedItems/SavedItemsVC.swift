//
//  SavedItemsVC.swift
//  Freelance Invoice
//
//  Created by Yosi Mizrachi on 15/10/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit
import RealmSwift

class SavedItemsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var search: UISearchBar!
    
    private let vm = SavedItemsViewModel()
    private var items = [LineItemModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = vm.getItems()
        setupItemsTable()
        // Do any additional setup after loading the view.
    }
    
    private func setupItemsTable(){
        itemsTableView.register(UINib(nibName: "ItemCellTableViewCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        itemsTableView.rowHeight = UITableView.automaticDimension
        itemsTableView.estimatedRowHeight = UITableView.automaticDimension
        itemsTableView.isScrollEnabled = false
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCellTableViewCell
        let item = items[indexPath.row]
        cell.loadCell(item: item)
        cell.hideBounds()
        cell.interactionState(enabled: tableView.isEditing)
        return cell
    }

}
