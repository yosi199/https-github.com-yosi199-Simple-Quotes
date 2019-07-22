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
    
    @IBOutlet weak var currencySymbol: UITextField!
    @IBOutlet weak var defaultTax: UITextField!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var idPrefixInput: UITextField!
    @IBOutlet weak var companyName: UITextField!
    
    private let viewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dropInteraction = UIDropInteraction(delegate: self)
        logo.addInteraction(dropInteraction)
        
        let chooseImageTap = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        logo.addGestureRecognizer(chooseImageTap)
        logo.isUserInteractionEnabled = true
        
        self.defaultTax.delegate = DoubleInputValidator.shared
        // Do any additional setup after loading the view.
        
                if let image = viewModel.image {
                    self.logo.image = image
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
        saveImageFile(data: logo.image?.pngData(), withName: COMPANY_LOGO)
        NotificationCenter.default.post(name: Notification.Name(SettingsViewController.EVENT_SETTINGS_CHANGED), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
