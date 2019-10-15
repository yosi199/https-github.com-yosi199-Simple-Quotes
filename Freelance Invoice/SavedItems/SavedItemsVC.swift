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
    
    var callback: ((_ item: LineItemModel) -> Void)?
    
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
        cell.isUserInteractionEnabled = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ItemCellTableViewCell
        cell.container.backgroundColor = .gray
        let item = items[indexPath.row]
        self.callback?(LineItemModel(value: item))
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ItemCellTableViewCell
        if #available(iOS 13.0, *) {
            cell.container.backgroundColor = .systemBackground
        } else {
            cell.container.backgroundColor = .white
        }
    }
}
