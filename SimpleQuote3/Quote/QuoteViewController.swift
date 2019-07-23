//
//  DetailViewController.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 19/06/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit
import RealmSwift

class QuoteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FileHandler {
    
    @IBOutlet weak var reviewButton: UIBarButtonItem!
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var header: Header!
    @IBOutlet weak var inputItemView: ItemView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var footer: Footer!
    @IBOutlet weak var itemsTableView: LineItemsList!
    @IBOutlet weak var footerStackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var footerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var currencySymbolText: UILabel!
    @IBOutlet weak var taxPercentageText: UILabel!
    
    private var imageToTransfer: UIImage? = nil
    private let realm = try! Realm()
    private let vm = QuoteViewModel()
    private let imagePicker = UIImagePickerController()
    private lazy var menu: MenuViewController = { return parent?.splitViewController?.children[0].children[0] as! MenuViewController }()
    
    override func viewDidLoad() {
        setupItemsTable()
        setupInteractions()
        setupCallbacks()
        setupNotifications()
        updateViews()
    }
    private func setupInteractions(){
        let chooseImageTap = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        self.header.logo.addGestureRecognizer(chooseImageTap)
        self.header.logo.isUserInteractionEnabled = true
        self.imagePicker.delegate = self
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupCallbacks() {
        inputItemView.showButton = { show in
            self.addButton.isHidden = !show
        }
        
        vm.settingsChanged = { self.viewDidLoad() }
        
        itemsTableView.deleteCallback = { item, index in
            self.confirmDelete(item: item, indexPath: index)
        }
    }
    
    private func setupItemsTable(){
        itemsTableView.register(UINib(nibName: "ItemCellTableViewCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        itemsTableView.rowHeight = UITableView.automaticDimension
        itemsTableView.estimatedRowHeight = UITableView.automaticDimension
        itemsTableView.isScrollEnabled = false
        itemsTableView.delegate = itemsTableView
        itemsTableView.dataSource = itemsTableView
    }
    
    private func updateViews(){
        
        title = vm.getInvoiceID()
        
        // Header
        header.address.text = vm.quote.address
        header.clientName.text = vm.quote.clientName
        header.companyName.text = vm.quote.companyName
        header.date.text = vm.quote.date
        header.email.text = vm.quote.email
        header.logo.image = vm.getLogoImage()
        header.id.text = vm.getInvoiceID()
        
        vm.quote.items.forEach { item in
            self.itemsTableView.items.append(item)
        }
        itemsTableView.reloadData()
        
        self.editButton.isEnabled = !vm.quote.items.isEmpty
        self.reviewButton.isEnabled = !vm.quote.items.isEmpty
        
        toggleFooter()
    }
    
    private func toggleFooter(){
        if(itemsTableView.items.count>0){
            footer.isHidden = false
            footerStackView.isHidden = false
        }
    }
    
    @objc func chooseImage(){
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.header.logo.contentMode = .scaleAspectFit
            self.header.logo.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func loadQuote(existing: Quote){
        self.vm.quote =  existing
        self.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? PDFController else { return }
        saveQuote()
        controller.quote = self.vm.quote
    }
    
    @IBAction func screenshow(_ sender: Any) {
        performSegue(withIdentifier: "pdf", sender: self)
    }
    
    private func saveQuote(){
        try! realm.write {
            self.vm.quote.address = self.header.address.text.orEmpty()
            self.vm.quote.clientName = self.header.clientName.text.orEmpty()
            self.vm.quote.companyName = self.header.companyName.text.orEmpty()
            self.vm.quote.date = self.header.date.text.orEmpty()
            self.vm.quote.email = self.header.email.text.orEmpty()
            self.vm.quote.notes = self.notes.text.orEmpty()
            
            vm.quote.items.removeAll()
            self.itemsTableView.items.forEach { (item) in self.vm.quote.items.append(item) }
        }
        self.vm.saveQuote()
        self.menu.reloadData()
    }
    
    func confirmDelete(item: LineItemModel, indexPath: IndexPath) {
        let rect = itemsTableView.rect(forSection: indexPath.section)
        let frame = itemsTableView.convert(rect, to: itemsTableView.superview)
        let alert =  AlertDeletion.Builder(frame: frame)
            .setTitle(title: "Delete Item")
            .setMessage(message: "Are you sure you want to delete \(item.title)?")
            .setConfirmationHandler { (UIAlertAction) in
                self.itemsTableView.items.remove(at: indexPath.section)
                self.editButtonClicked(self)
                if (self.itemsTableView.items.count == 0) {
                    self.footer.isHidden = true
                    self.footerStackView.isHidden = true
                }
                self.itemsTableView.reloadData()
            }.build()
            .prepare()
        
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.permittedArrowDirections = .down
        alert.popoverPresentationController?.sourceRect = CGRect(x: frame.midX , y: frame.midY - scrollView.contentOffset.y + (frame.height / 2) , width: 1.0, height: 1.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        addLineItem(item: inputItemView.getItem())
        self.itemsTableView.reloadData()
    }
    
    private func addLineItem(item: LineItemModel){
        self.itemsTableView.items.append(item)
        self.reviewButton.isEnabled = true
        self.editButton.isEnabled = true
        toggleFooter()
    }
    
    @IBAction func editButtonClicked(_ sender: Any) {
        self.itemsTableView.isEditing.toggle()
        self.itemsTableView.reloadData()
        
        if(self.itemsTableView.isEditing){
            self.editButton.tintColor = UIColor.red
        } else {
            self.editButton.tintColor = UIColor.black
        }
    }
    
    override func viewDidLayoutSubviews() {
        let newHeight = CGFloat(110 *    self.itemsTableView.items.count)
        
        if(footerBottomConstraint.constant != 15){
            footerBottomConstraint.constant = 15
        }
        
        if (heightConstraint.constant != newHeight){
            heightConstraint.constant = newHeight
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
        footer.update(items: self.itemsTableView.items)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height / 3)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
