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
    lazy var detailViewController: QuoteViewController = {
        return parent?.splitViewController?.children[1].children[0] as! QuoteViewController
    }()
    
    override func viewDidLoad() {
        title = "Menu"
                
        setupMenuList()
        setupCallbacks()
        
        detailViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        detailViewController.navigationItem.leftItemsSupplementBackButton = true
    }
    
    private func setupMenuList(){
        menuList.register(UINib(nibName: "QuoteCellItemTableViewCell", bundle: nil), forCellReuseIdentifier: "cell1")
        menuList.delegate = menuList
        menuList.dataSource = menuList
        menuList.items = vm.getItems()
    }
    
    private func setupCallbacks(){
        menuList.loadQuoteCallback = { quote, index in
//            self.performSegue(withIdentifier: "quote", sender: self)
            self.detailViewController.loadQuote(existing: quote)
        }
        
        menuList.deleteQuoteCallback = { quote, index in
            self.vm.delete(quote: quote)
            self.selectFirst()
            self.detailViewController.showContent(show: !self.vm.isEmpty())
            
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                if(self.vm.isEmpty()){
                    self.menuList.isEditing.toggle()
                    self.changeEditingColor()
                }
            })
        }
        
        self.vm.settingsChanged = {
            self.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        maybeFirstTime()
        
        if(vm.isEmpty()){
            self.detailViewController.showContent(show: false)
            return
        }
        
        // Reselects a row.
        if let quote = detailViewController.getCurrentQuote() {
            reselectOrLoadExisting(quote: quote)
        } else {
            selectFirst()
        }
    }
    
    private func reselectOrLoadExisting(quote: Quote){
        // make sure we actually have this quote in our list
        if let quoteIndex = menuList.items.firstIndex(where: { (value) -> Bool in
            value.id == quote.id
        }){
            let index = IndexPath(row: quoteIndex, section: 0)
            self.menuList.selectRow(at: index, animated: true, scrollPosition: UITableView.ScrollPosition.none)
        } else {
            detailViewController.loadQuote(existing: menuList.items.first!)
        }
    }
    
    private func selectFirst(){
        if(!self.vm.getItems().isEmpty) {
            let index = IndexPath(row: 0, section: 0)
            self.menuList.selectRow(at: index, animated: true, scrollPosition: UITableView.ScrollPosition.none)
            self.detailViewController.loadQuote(existing: self.vm.getItems().first!)
        }
    }
    
    private func maybeFirstTime(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let isFirstLaunch = appDelegate.firstTime
        if(isFirstLaunch){
            appDelegate.firstTime = false
            self.settings(self)
        }
    }
    
    @IBAction func settings(_ sender: Any) {
        detailViewController.unregisterKeyboardHelper()
        
        let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "settings") as! SettingsViewController
        settingsVC.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(settingsVC, animated: true, completion: nil)
    }
    
    @IBAction func addClicked(_ sender: Any) {
        let quote = self.vm.addNew()
        detailViewController.loadQuote(existing: quote)
        menuList.items = vm.getItems()
        reloadData()
        self.selectFirst()
        self.detailViewController.showContent(show: !self.vm.isEmpty())
    }
    
    @IBAction func deleteClicked(_ sender: Any) {
        menuList.isEditing.toggle()
        changeEditingColor()
    }
    
    private func changeEditingColor() {
        if(self.menuList.isEditing) {
            self.deleteButton.tintColor = UIColor.red
        } else {
            self.deleteButton.tintColor = UIColor.black
        }
    }
    
    func reloadData(){
        menuList.reloadData()
    }
}


