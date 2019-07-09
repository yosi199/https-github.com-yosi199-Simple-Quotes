//
//  DetailViewController.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 19/06/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var header: Header!
    @IBOutlet weak var inputItemView: ItemView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var footer: Footer!
    @IBOutlet weak var itemsTableView: ResizeableTableViewTableViewController!
    @IBOutlet weak var footerStackView: UIStackView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var footerBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    private var items = [LineItemModel]()
    private var imageToTransfer: UIImage? = nil
    private let realm = try! Realm()
    private var quote = Quote()
    
    override func viewDidLoad() {
        
        itemsTableView.register(UINib(nibName: "ItemCellTableViewCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        itemsTableView.rowHeight = UITableView.automaticDimension
        itemsTableView.estimatedRowHeight = UITableView.automaticDimension
        itemsTableView.isScrollEnabled = false
        
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        
        inputItemView.showButton = { show in
            self.addButton.isHidden = !show
        }
    }
    
    func loadQuote(existing: Quote){
        
        // first reset
        reset()
        self.quote = existing
        // header
        header.clientName.text = quote.clientName
        header.address.text = quote.address
        header.companyName.text = quote.companyName
        header.date.text = quote.date
        header.email.text = quote.email
        header.id.text = quote.invoiceId
        
        // line items
        quote.items.forEach { item in
            addLineItem(item: item)
        }
        
        itemsTableView.reloadData()
    }
    
    private func reset(){
        header.clientName.text = ""
        header.address.text = ""
        header.companyName.text = ""
        header.date.text = ""
        header.email.text = ""
        header.id.text = ""
        self.items.removeAll()
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        addLineItem(item: inputItemView.getItem())
        inputItemView.reset()
    }
    
    private func addLineItem(item: LineItemModel){
        items.append(item)
        itemsTableView.reloadData()
        footer.isHidden = false
        
        footerStackView.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        let newHeight = CGFloat(110 * items.count)
        
        if(footerBottomConstraint.constant != 15){
            footerBottomConstraint.constant = 15
        }
        
        if (heightConstraint.constant != newHeight){
            heightConstraint.constant = newHeight
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
        footer.update(items: items)
    }
    
    @IBAction func editButtonClicked(_ sender: Any) {
        self.itemsTableView.isEditing.toggle()
        self.itemsTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.white
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCellTableViewCell
        
        let item = items[indexPath.section]
        cell.title.text = item.title
        cell.descriptionField.text = item.itemDescription
        cell.quantity.text = String(item.qty)
        cell.itemValue.text = String(item.value)
        cell.taxValue.text = String(item.tax)
        cell.totalValue.text = String(item.total)
        cell.interactionState(enabled: tableView.isEditing)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.items[sourceIndexPath.row]
        items.remove(at: sourceIndexPath.row)
        items.insert(movedObject, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items[indexPath.section]
            confirmDelete(item: item, indexPath: indexPath)
        }
    }
    
    
    func confirmDelete(item: LineItemModel, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete \(item.title)?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(alert: UIAlertAction!) in
            self.items.remove(at: indexPath.section)
            if (self.items.count == 0) {
                self.footer.isHidden = true
                self.footerStackView.isHidden = true
            }
            self.itemsTableView.reloadData()
        })
        
        
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in })
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        let rect = itemsTableView.rect(forSection: indexPath.section)
        let frame = itemsTableView.convert(rect, to: itemsTableView.superview)
        
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.permittedArrowDirections = .down
        alert.popoverPresentationController?.sourceRect = CGRect(x: frame.midX , y: frame.midY - scrollView.contentOffset.y + (frame.height / 2) , width: 1.0, height: 1.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? PDFController else { return }
        controller.quote = saveQuote()
    }
    
    private func saveQuote() -> Quote{
        try! realm.write {
            quote.items.removeAll()
            for item in self.items {
                quote.items.append(item)
            }
            
            quote.address = header.address.text ?? ""
            quote.clientName = header.clientName.text ?? ""
            quote.companyName = header.companyName.text ?? ""
            quote.date = header.date.text ?? ""
            quote.email = header.email.text ?? ""
            
            realm.add(quote, update: .all)
        }
        return quote
    }
    
    @IBAction func screenshow(_ sender: Any) {
        performSegue(withIdentifier: "pdf", sender: self)
    }
}


