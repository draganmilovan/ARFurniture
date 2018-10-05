//
//  ItemController.swift
//  AR Furniture
//
//  Created by Dragan Milovanovic on 10/4/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import UIKit

class ItemController: UIViewController {
    
    // Data source
    var item: ItemDataModel? {
        didSet {
            if !self.isViewLoaded { return }

            populateUI()
        }
    }

    @IBOutlet fileprivate weak var itemImageView: UIImageView!
    @IBOutlet weak var itemInfoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateUI()
    }

    
    @IBAction private func addToFavorites(_ sender: UIButton) {
        print("Add/remove to/from Favories!")
    }
    
    @IBAction private func tryItem(_ sender: UIButton) {
        
    }
    
}



//Mark:- Item Controller private methods
fileprivate extension ItemController {
    
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
