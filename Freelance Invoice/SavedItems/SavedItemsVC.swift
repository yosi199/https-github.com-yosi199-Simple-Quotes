//
//  SavedItemsVC.swift
//  Freelance Invoice
//
//  Created by Yosi Mizrachi on 15/10/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit
import RealmSwift

class SavedItemsVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var itemsTableView: UITableView!
    
    private let vm = SavedItemsViewModel()
    private var items = [LineItemModel]()
    private var filteredItems = [LineItemModel]()
    private var resultSearchController = UISearchController()
    private var searchActive = false
    
    var callback: ((_ item: LineItemModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        items = vm.getItems()
        filteredItems = items
        setupItemsTable()
        
        // Do any additional setup after loading the view.
    }
    
    private func setupItemsTable(){
        itemsTableView.register(UINib(nibName: "ItemCellTableViewCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        itemsTableView.rowHeight = UITableView.automaticDimension
        itemsTableView.estimatedRowHeight = UITableView.automaticDimension
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCellTableViewCell
        let item = filteredItems[indexPath.row]
        cell.loadCell(item: item)
        cell.hideBounds()
        cell.isUserInteractionEnabled = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ItemCellTableViewCell
        if #available(iOS 13.0, *) {
            cell.container.backgroundColor = .secondarySystemBackground
        } else {
            cell.container.backgroundColor = .lightGray
        }
        
        let item = filteredItems[indexPath.row]
        self.callback?(LineItemModel(value: item))
        
        // If the user is searching - we need to dismiss the search first
        // or else this controller won't be dismissed
        if(resultSearchController.isActive){
            resultSearchController.dismiss(animated: false, completion: nil)
        }
        
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            
            let deleteTitle = NSLocalizedString("Delete", comment: "Delete action")
            let deleteAction = UITableViewRowAction(style: .destructive, title: deleteTitle) { (action, indexPath) in
                let item = self.items[indexPath.row]
                DataRepository.shared.deleteSavedItem(item: SavedItem.fromLineItem(item: item))
                self.items.remove(at: indexPath.row)
                self.filteredItems = self.items
                
                tableView.reloadData()
            }
            
            return [deleteAction]
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if(searchController.isActive){
            filteredItems.removeAll()
            
            let text = searchController.searchBar.text!
            if(text.isNotEmpty()){
                for item in items {
                    if(item.title.lowercased().contains(text.lowercased())
                        || item.itemDescription.lowercased().contains(text.lowercased())){
                        filteredItems.append(item)
                    }
                }
            } else {
                filteredItems = items
            }
            
            self.itemsTableView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(self.searchActive){
            filteredItems.removeAll()
            
            let text = searchBar.text!
            if(text.isNotEmpty()){
                for item in items {
                    if(item.title.lowercased().contains(text.lowercased())
                        || item.itemDescription.lowercased().contains(text.lowercased())){
                        filteredItems.append(item)
                    }
                }
            } else {
                filteredItems = items
            }
            
            self.itemsTableView.reloadData()
        }
    }
}
