//
//  MasterViewController.swift
//  SimpleQuote3
//
//  Created by Yosi Mizrachi on 19/06/2019.
//  Copyright © 2019 Yosi Mizrachi. All rights reserved.
//

import UIKit
import RealmSwift

class MenuViewController: UIViewController {
    
    @IBOutlet var menuList: MenuList!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    private let vm = MenuViewModel()
    private lazy var detailViewController: QuoteViewController = {
        return parent?.splitViewController?.children[1].children[0] as! QuoteViewController
    }()
    
    override func viewDidLoad() {
        title = "Menu"
        
        setupMenuList()
        setupCallbacks()
    }
    
    private func setupMenuList(){
        menuList.register(UINib(nibName: "QuoteCellItemTableViewCell", bundle: nil), forCellReuseIdentifier: "cell1")
        menuList.delegate = menuList
        menuList.dataSource = menuList
        menuList.items = vm.getItems()
    }
    
    private func setupCallbacks(){
        menuList.loadQuoteCallback = { quote, index in
            self.detailViewController.loadQuote(existing: quote)
        }
        
        menuList.deleteQuoteCallback = { quote, index in
            self.vm.delete(quote: quote)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        maybeFirstTime()
    }
    
    private func maybeFirstTime(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let isFirstLaunch = (UIApplication.shared.delegate as! AppDelegate).firstLaunch
            if(isFirstLaunch){
                self.settings(self)
            }
        }
    }
    
    @IBAction func settings(_ sender: Any) {
        let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "settings") as! SettingsViewController
        settingsVC.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(settingsVC, animated: true, completion: nil)
    }
    
    @IBAction func addClicked(_ sender: Any) {
        let quote = self.vm.addNew()
        detailViewController.loadQuote(existing: quote)
        menuList.items = vm.getItems()
        reloadData()
    }
    
    @IBAction func deleteClicked(_ sender: Any) {
        menuList.isEditing.toggle()
        
        if(menuList.isEditing){
            self.deleteButton.tintColor = UIColor.red
        } else{
            self.deleteButton.tintColor = UIColor.black
        }
    }
    
    func reloadData(){
        menuList.reloadData()
    }
}


