//
//  SettingsViewController.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 14/07/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit
import MobileCoreServices
import StoreKit

class SettingsViewController: UIViewController, UIDropInteractionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FileHandler {
    
    static let EVENT_SETTINGS_CHANGED = "settingsChanged"
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var currencySymbol: UILabel!
    @IBOutlet weak var defaultTax: UITextField!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var idPrefixInput: UITextField!
    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var currencyTable: CurrencyList!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var currencyTableWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var availableQuotes: UILabel!
    
    private let progress = ProgressView()
    private let viewModel = SettingsViewModel()
    private var user: User?
    
    private var selectedLocale: Locale?
    
    // IN APP Purchases
    private var availableInvoices = 0
    private var products: [SKProduct]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = viewModel.user
        
        if let user = self.user {
            
            self.selectedLocale = Locale(identifier: viewModel.localeIdentifier)
            
            self.currencyTable.register(UINib(nibName: "CurrencyCell".self, bundle: nil), forCellReuseIdentifier: "currencyCell")
            self.currencyTable.delegate = currencyTable
            self.currencyTable.dataSource = currencyTable
            
            if(user.address.isNotEmpty()){
                self.address.text = user.address
            }
            
            if(user.phone.isNotEmpty()){
                self.phoneNumber.text = user.phone
            }
            
            if(user.email.isNotEmpty()){
                self.email.text = user.email
            }
            
            self.defaultTax.delegate = DoubleInputValidator.shared
            // Do any additional setup after loading the view.
            
            self.availableQuotes.text = "\(BuyInvoicesHelper.shared.getAvailableInvoicesCount()) Available invoices."
            
            setupInteractions()
            setupCallbacks()
            
            if let image = viewModel.image {
                self.logo.image = image
            }
            
        }
    }
    
    private func setupInteractions(){
        let dropInteraction = UIDropInteraction(delegate: self)
        self.logo.addInteraction(dropInteraction)
        
        let chooseImageTap = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        self.logo.addGestureRecognizer(chooseImageTap)
        self.logo.isUserInteractionEnabled = true
        
        let chooseCurrencyTap = UITapGestureRecognizer(target: self, action: #selector(showCurrencyAlert))
        self.currencySymbol.addGestureRecognizer(chooseCurrencyTap)
        self.currencySymbol.isUserInteractionEnabled = true
    }
    
    private func setupCallbacks(){
        currencyTable.currencySelected = { locale, currency in
            self.animateCurrencyTableWidth(constant: 0)
            self.currencySymbol.text = currency
            self.selectedLocale = locale
            self.scrollView.isScrollEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.currencySymbol.text = viewModel.currency
        self.defaultTax.text = viewModel.tax
        self.idPrefixInput.text = viewModel.quoteIDPrefix
        self.companyName.text = viewModel.companyName
        
    }
    
    @objc func chooseImage(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.logo.contentMode = .scaleAspectFit
            self.logo.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.hasItemsConforming(toTypeIdentifiers: [kUTTypeImage as String]) && session.items.count == 1
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let dropLocation = session.location(in: view)
        
        let operation: UIDropOperation
        
        if logo.frame.contains(dropLocation) {
            /*
             If you add in-app drag-and-drop support for the .move operation,
             you must write code to coordinate between the drag interaction
             delegate and the drop interaction delegate.
             */
            operation = .copy
        } else {
            // Do not allow dropping outside of the image view.
            operation = .cancel
        }
        
        return UIDropProposal(operation: operation)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        // Consume drag items (in this example, of type UIImage).
        session.loadObjects(ofClass: UIImage.self) { imageItems in
            let images = imageItems as! [UIImage]
            /*
             If you do not employ the loadObjects(ofClass:completion:) convenience
             method of the UIDropSession class, which automatically employs
             the main thread, explicitly dispatch UI work to the main thread.
             For example, you can use `DispatchQueue.main.async` method.
             */
            self.logo.image = images.first
            self.saveImageFile(data: images.first?.pngData(), withName: COMPANY_LOGO)
        }
    }
    
    override var preferredContentSize: CGSize {
        get {
            let landscape = UIApplication.shared.statusBarOrientation.isLandscape
            let menuVC = self.presentingViewController?.children[0] as? MenuViewController
            if let fullSize = menuVC?.detailViewController.view.bounds.size {
                if(landscape){
                    return CGSize(width: fullSize.width * 0.5,
                                  height: fullSize.height * 0.75)
                } else {
                    return CGSize(width: fullSize.width * 2,
                                  height: fullSize.height * 0.75)
                }
            }
            return super.preferredContentSize
        }
        set {
            super.preferredContentSize = newValue
        }
    }
    
    @IBAction func save(_ sender: Any) {
        self.progress.show(parent: self)
        
        let user = User(value: self.user!)
        viewModel.currency = currencySymbol.text ?? "$"
        viewModel.tax = defaultTax.text ?? "0"
        viewModel.quoteIDPrefix = idPrefixInput.text ?? "CMX"
        viewModel.companyName = companyName.text.orEmpty()
        viewModel.localeIdentifier = selectedLocale?.identifier ?? Locale.current.identifier
        
        user.address = address.text ?? ""
        user.email = email.text ?? ""
        user.phone = phoneNumber.text ?? ""
        viewModel.saveUser(user: user)
        let image = self.logo.image
        DispatchQueues.serialQueue.async(execute: {
            let imageData = image?.pngData()
            self.saveImageFile(data: imageData, withName: COMPANY_LOGO)
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.progress.hide(parent: self)
                self.finishActivity()
            }
        })
    }
    
    func finishActivity(){
        NotificationCenter.default.post(name: Notification.Name(SettingsViewController.EVENT_SETTINGS_CHANGED), object: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func showCurrencyAlert(){
        animateCurrencyTableWidth(constant: 250)
        self.scrollView.isScrollEnabled = false
    }
    
    private func animateCurrencyTableWidth(constant: CGFloat){
        currencyTableWidthConstraint.constant = constant
        UIView.animate(withDuration: 0.15, animations: {self.view.layoutIfNeeded()}, completion: nil)
    }
    
    @IBAction func onLogoToggled(_ sender: UISwitch) {
        self.logo.isUserInteractionEnabled = sender.isOn
        
        UIView.animate(withDuration: 0.25) {
            if (sender.isOn) {
                self.logo.alpha = 1
            } else{
                self.logo.alpha = 0.3
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children[0] as? BuyInvoicesVC
        {
            vc.products = products
            vc.dismissalDelegate = self
        }
    }
    
    @IBAction func topUP(_ sender: Any) {
        StoreManager.shared.delegate = self
        fetchProducts()
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

extension SettingsViewController : StoreManagerDelegate {
    func noAvailableProductsFound() {
        
    }
    
    func onAvailableProducts(products: [SKProduct]) {
        self.products = products
        performSegue(withIdentifier: "buyVC", sender: self)
    }
}

extension SettingsViewController : DismissalDelegate {

    func finishedShowing(viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}


