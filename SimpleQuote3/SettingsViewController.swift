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
    
    
    @IBOutlet weak var defaultTax: NSLayoutConstraint!
    @IBOutlet weak var currencySymbol: NSLayoutConstraint!
    @IBOutlet weak var logo: UIImageView!
    
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dropInteraction = UIDropInteraction(delegate: self)
        logo.isUserInteractionEnabled = true
        logo.addInteraction(dropInteraction)
        setLogo()
        
        let chooseImageTap = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        logo.addGestureRecognizer(chooseImageTap)
        
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @objc func chooseImage(){
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            logo.contentMode = .scaleAspectFit
            logo.image = pickedImage
            saveImageFile(data: pickedImage.pngData(), withName: COMPANY_LOGO)
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.hasItemsConforming(toTypeIdentifiers: [kUTTypeImage as String]) && session.items.count == 1
        //        return session.canLoadObjects(ofClass: UIImage.self)
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
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setLogo() {
        if let image = UIImage(contentsOfFile: getFileForName(name: COMPANY_LOGO).path){
            logo.image = image
        }
    }
}
