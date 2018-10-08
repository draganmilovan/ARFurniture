//
//  ItemsCollectionController.swift
//  AR Furniture
//
//  Created by Dragan Milovanovic on 10/8/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import UIKit

class ItemsCollectionController: UIViewController {

    
    
    @IBOutlet fileprivate weak var itemsCollectionViewController: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register Collection View Cells
        let itemNib = UINib(nibName: "CatalogCell", bundle: nil)
        itemsCollectionViewController.register(itemNib, forCellWithReuseIdentifier: "CatalogCell")
        
    }

}
