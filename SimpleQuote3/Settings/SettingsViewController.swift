//
//  SettingsViewController.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 14/07/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit
import MobileCoreServices

class SettingsViewController: UIViewController, UIDropInteractionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FileHandler {
    
    static let EVENT_SETTINGS_CHANGED = "settingsChanged"
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var currencySymbol: UILabel!
    @IBOutlet weak var defaultTax: UITextField!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var idPrefixInput: UITextField!
    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var currencyTable: CurrencyList!
    
    @IBOutlet weak var currencyTableWidthConstraint: NSLayoutConstraint!
    private let viewModel = SettingsViewModel()
    private var selectedLocale: Locale?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedLocale = Locale(identifier: viewModel.localeIdentifier)
        
        self.currencyTable.register(UINib(nibName: "CurrencyCell".self, bundle: nil), forCellReuseIdentifier: "currencyCell")
        self.currencyTable.delegate = currencyTable
        self.currencyTable.dataSource = currencyTable
        
        self.defaultTax.delegate = DoubleInputValidator.shared
        // Do any additional setup after loading the view.
        
        setupInteractions()
        setupCallbacks()
        
        if let image = viewModel.image {
            self.logo.image = image
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
            if let fullSize = self.presentingViewController?.view.bounds.size {
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
        viewModel.currency = currencySymbol.text ?? "$"
        viewModel.tax = defaultTax.text ?? "0"
        viewModel.quoteIDPrefix = idPrefixInput.text ?? "CMX"
        viewModel.companyName = companyName.text.orEmpty()
        viewModel.localeIdentifier = selectedLocale?.identifier ?? Locale.current.identifier
        saveImageFile(data: logo.image?.pngData(), withName: COMPANY_LOGO)
        NotificationCenter.default.post(name: Notification.Name(SettingsViewController.EVENT_SETTINGS_CHANGED), object: nil)
        dismiss(animated: true, completion: nil)
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
    
}
