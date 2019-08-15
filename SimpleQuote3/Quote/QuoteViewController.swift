//
//  DetailViewController.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 19/06/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit
import RealmSwift
import StoreKit

class QuoteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FileHandler, UITextViewDelegate, UITextFieldDelegate {
    
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
    @IBOutlet weak var emptyState: UILabel!
    
    @IBOutlet weak var taxAmount: UILabel!
    @IBOutlet weak var subTotalAmount: UILabel!
    @IBOutlet weak var discountAmount: UILabel!
    @IBOutlet weak var editDiscountButton: UIImageView!
    @IBOutlet weak var editTaxButton: UIImageView!
    
    private let progress = ProgressView()
    private let keyboardHelper = KeyboardScrollHelper()
    private var imageToTransfer: UIImage? = nil
    private let vm = QuoteViewModel()
    private let imagePicker = UIImagePickerController()
    private lazy var menu: MenuViewController = { return parent?.splitViewController?.children[0].children[0] as! MenuViewController }()
   
    // IN APP Purchases
    private var availableInvoices = 0
    private var products: [SKProduct]?
    
    override func viewDidLoad() {
        self.splitViewController?.preferredDisplayMode = UISplitViewController.DisplayMode.primaryOverlay
        
        setupItemsTable()
        setupInteractions()
        setupCallbacks()
        setupDelegations()
        updateViews()
        keyboardHelper.register(hostView: self.view, scrollView: self.scrollView)
    }
    
    deinit { unregisterKeyboardHelper()}
    
    func unregisterKeyboardHelper(){
        keyboardHelper.unregister()
    }
    
    private func setupInteractions(){
        let chooseImageTap = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        self.header.logo.addGestureRecognizer(chooseImageTap)
        self.header.logo.isUserInteractionEnabled = true
        self.imagePicker.delegate = self
        self.notes.delegate = self
        
        let editDiscountTap = UITapGestureRecognizer(target: self, action: #selector(editDiscount))
        self.editDiscountButton.addGestureRecognizer(editDiscountTap)
    }
    
    private func setupCallbacks() {
        inputItemView.showButton = { show in
            self.addButton.isHidden = !show
        }
        
        vm.settingsChanged = {
            // override
            self.vm.quote.companyName = self.vm.getCompanyName()
            self.viewDidLoad() }
        
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
    
    private func setupDelegations(){
        self.header.address.delegate = self
        self.header.clientName.delegate = self
        self.header.companyName.delegate = self
        self.header.date.delegate = self
        self.header.email.delegate = self
        self.header.id.delegate = self
        
        self.inputItemView.descriptionField.delegate = self
        self.inputItemView.itemValue.delegate = self
        self.inputItemView.quantity.delegate = self
        self.inputItemView.taxValue.delegate = self
        self.inputItemView.title.delegate = self
        self.inputItemView.totalValue.delegate = self
        
        self.notes.delegate = self
    }
    
    private func updateViews(){
        
        let quote = vm.quote
        
        title = vm.getInvoiceID()
        
        // Header
        header.address.text = quote.address
        header.clientName.text = quote.clientName
        header.companyName.text = quote.companyName
        header.date.text = quote.date
        header.email.text = quote.email
        header.logo.image = vm.getLogoImage()
        header.id.text = vm.getInvoiceID()
        header.setLogoState(enabled: quote.withLogo)
        header.logoSwitch.isOn = quote.withLogo
        
        itemsTableView.items = vm.quote.items.toArray()
        itemsTableView.reloadData()
        
        notes.text = vm.quote.notes
        
        editButton.isEnabled = !vm.quote.items.isEmpty
        reviewButton.isEnabled = !vm.quote.items.isEmpty
        if(vm.quote.items.isEmpty) {
            self.reviewButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            self.reviewButton.tintColor = #colorLiteral(red: 0, green: 0.168627451, blue: 0.9803921569, alpha: 1)
        }
        addButton.isHidden = vm.quote.items.isEmpty
        footer.isHidden = vm.quote.items.isEmpty
        footerStackView.isHidden = vm.quote.items.isEmpty
        currencySymbolText.text = "Currency: \(vm.getCurrencySymbol())"
        taxPercentageText.text = "Tax Percentage: \(vm.getTaxPercentage())%"
        
        toggleFooter()
    }
    
    @objc func chooseImage(){
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func editDiscount(){
        keyboardHelper.unregister()
        let popover = self.storyboard?.instantiateViewController(withIdentifier: "editDiscountVC") as! DiscountVC
        // TODO - replace quote with TOTAL VALUE instead - it won't work if it's a newly created quote that hasn't been saved yet
        popover.subTotal = self.itemsTableView.items.getSubTotal()
        popover.currentDiscount = self.vm.quote.discountAmount
        popover.discountCallback = { value, percent in
            self.vm.quote.discountAmount = value
            self.vm.quote.discountPercentage = percent
            self.updateSummary()
        }
        
        popover.modalPresentationStyle = UIModalPresentationStyle.popover
        popover.popoverPresentationController?.permittedArrowDirections = .any
        popover.popoverPresentationController?.sourceRect = self.discountAmount.frame
        popover.popoverPresentationController?.sourceView = self.discountAmount
        popover.popoverPresentationController?.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
        
        self.present(popover, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.header.logo.contentMode = .scaleAspectFit
            self.header.logo.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func loadQuote(existing: Quote){
        self.vm.quote = Quote(value: existing)
        self.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.destination is PDFController){
            guard let controller = segue.destination as? PDFController else { return }
            controller.quote = self.vm.quote
        } else if segue.destination is BuyInvoicesVC {
            let buyVC = segue.destination as! BuyInvoicesVC
            buyVC.products = self.products
        }
    }
    
    @IBAction func screenshow(_ sender: Any) {
        if(availableInvoices <= 0){
            StoreManager.shared.delegate = self
            fetchProducts()
            return
        }
        
        self.progress.show(parent: self)
        
        let imagePath = "\(self.vm.quote.invoiceId)Image"
        
        if let image = self.header.logo.image {
            self.saveImage(image: image, imagePath: imagePath)
        }
        self.vm.quote.imagePath = imagePath
        self.saveQuote()
        self.performSegue(withIdentifier: "pdf", sender: self)
        self.progress.hide(parent: self)
    }
    
    private func saveQuote(){
        self.vm.quote.address = self.header.address.text.orEmpty()
        self.vm.quote.clientName = self.header.clientName.text.orEmpty()
        self.vm.quote.companyName = self.header.companyName.text.orEmpty()
        self.vm.quote.date = self.header.date.text.orEmpty()
        self.vm.quote.email = self.header.email.text.orEmpty()
        self.vm.quote.notes = self.notes.text.orEmpty()
        self.vm.quote.items = self.itemsTableView.items.toList()
        self.vm.quote.withLogo = self.header.logoSwitch.isOn
        
        self.vm.saveQuote()
        self.menu.reloadData()
    }
    
    private func saveImage(image: UIImage, imagePath: String){
        self.saveImageFile(data: image.pngData(), withName: imagePath)
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
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.1, animations: {sender.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)}, completion: { finish in
            UIButton.animate(withDuration: 0.1, animations: {
                sender.transform = CGAffineTransform.identity
            })
        })
        addLineItem(item: inputItemView.getItem())
        self.itemsTableView.reloadData()
    }
    
    private func addLineItem(item: LineItemModel){
        self.itemsTableView.items.append(item)
        self.reviewButton.isEnabled = true
        self.reviewButton.tintColor = #colorLiteral(red: 0, green: 0.1698517203, blue: 0.9812178016, alpha: 1)
        self.editButton.isEnabled = true
        inputItemView.reset()
        toggleFooter()
    }
    
    private func toggleFooter() {
        if(itemsTableView.items.count>0) {
            footer.isHidden = false
            footerStackView.isHidden = false
        }
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
        let newHeight = CGFloat(110 * self.itemsTableView.items.count)
        
        if(footerBottomConstraint.constant != 15){
            footerBottomConstraint.constant = 15
        }
        
        if (heightConstraint.constant != newHeight){
            heightConstraint.constant = newHeight
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
        
        updateSummary()
    }
    
    private func updateSummary(){
        let locale = Locale(identifier: DataRepository.Defaults.shared.localeIdentifier)
        
        let subTotal = self.itemsTableView.items.getSubTotal()
        self.discountAmount.text = String(vm.quote.discountAmount.rounded(toPlaces: 2).toCurrency(locale: locale))
        self.subTotalAmount.text = String(subTotal.rounded(toPlaces: 2).toCurrency(locale: locale))
        
        self.vm.quote.taxPercentage = UserDefaults.standard.double(forKey: SETTINGS_DEFAULT_TAX)
        self.vm.quote.taxAmount = ((subTotal - self.vm.quote.discountAmount) * self.vm.quote.taxPercentage) / 100
        self.taxAmount.text = String(self.vm.quote.taxAmount.rounded(toPlaces: 2).toCurrency(locale: locale))
        
        self.footer.total.text = String((subTotal - vm.quote.discountAmount + self.vm.quote.taxAmount).rounded(toPlaces: 2).toCurrency(locale: locale))
    }
    
    @IBAction func unwindFromPdf(_ unwindSegue: UIStoryboardSegue) {}
    
    func showContent(show: Bool) {
        scrollView.isHidden = !show
        scrollView.isUserInteractionEnabled = show
        emptyState.isHidden = show
        
        if (show) { title = vm.getInvoiceID() }
        else { title = ""}
    }
    
    func getCurrentQuote() -> Quote? {
        return self.vm.quote
    }
    
    // MARK: Delegation helper to send events to the keyboard helper class
    func textViewDidBeginEditing(_ textView: UITextView) {
        var view: UIView = textView
        if(view.superview != self.view){
            view = (self.notes.superview?.superview!)!
        }
        keyboardHelper.textFieldDidBeginEditing(field: view)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardHelper.textFieldDidBeginEditing(field: textField)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        keyboardHelper.textFieldDidEndEditing(field: textView)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        keyboardHelper.textFieldDidEndEditing(field: textField)
    }
    
    fileprivate func fetchProducts(){
        if StoreObserver.shared.isAuthorizedForPayments {
            let productsResource = ProductIdentifiers()
            guard let identifiers = productsResource.identifiers else {
                // Warn the user that the resource file could not be found.
                print("Identifiers not found")
                return
            }
            
            if !identifiers.isEmpty {
                StoreManager.shared.fetchProducts(matchingIdentifiers: identifiers)
            }
        }
    }
    
}

extension QuoteViewController : StoreManagerDelegate {
    func noAvailableProductsFound() {
        
    }
    
    func onAvailableProducts(products: [SKProduct]) {
        self.products = products
        performSegue(withIdentifier: "buyVC", sender: self)
    }
}
