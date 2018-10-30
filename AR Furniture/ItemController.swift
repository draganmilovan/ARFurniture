//
//  ItemController.swift
//  AR Furniture
//
//  Created by Dragan Milovanovic on 10/4/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import UIKit


protocol RefreshDelegate {
    func refreshUI(minus item: ItemDataModel)
}


class ItemController: UIViewController {
    
    var itemsDataManager: ItemsDataManager?
    
    // Data source
    var item: ItemDataModel? {
        didSet {
            if !self.isViewLoaded { return }

            populateUI()
        }
    }

    @IBOutlet fileprivate weak var itemImageView: UIImageView!
    @IBOutlet weak var itemInfoLabel: UILabel!
    
    var refreshDelegate: RefreshDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.black

        populateUI()
    }

    
    @IBAction private func addToFavorites(_ sender: UIButton) {
        guard let itemsDataManager = itemsDataManager else {
            fatalError("Missing Items Data Manager")
        }
        
        if !itemsDataManager.favorites.contains(item!) {
            itemsDataManager.favorites.append(item!)
            
        } else {
            for (index, element) in itemsDataManager.favorites.enumerated() {
                if element == item {
                    itemsDataManager.favorites.remove(at: index)
                }
            }
        }
        
        refreshDelegate?.refreshUI(minus: item!)
    }
    
    @IBAction private func tryItem(_ sender: UIButton) {
        postNotification()
        self.parent?.dismiss(animated: true, completion: nil)
    }
    
}



//Mark:- Item Controller private methods
fileprivate extension ItemController {
    
    //
    // Method for posting Notification after Try Item Button is Pressed
    //
    func postNotification() {
        guard let item = item else { return }
        let itemData: [String : ItemDataModel] = ["Item" : item]

        NotificationCenter.default.post(name: Notification.Name("tryItem"), object: nil, userInfo: itemData)
    }
    
    
    //
    // Method for populating UI
    //
    func populateUI() {
        guard let item = item else { return }
        
        if let imageName = item.catalogNumber {
            itemImageView.image = UIImage(named: imageName)
        }
        
        if let name = item.name {
            itemInfoLabel.text = name
        }
    }
    
}
