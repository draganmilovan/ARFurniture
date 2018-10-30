//
//  ItemsCollectionController.swift
//  AR Furniture
//
//  Created by Dragan Milovanovic on 10/8/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import UIKit

class ItemsCollectionController: UIViewController, RefreshDelegate {

    var itemsDataManager: ItemsDataManager?
    
    // Data source
    var items: [ItemDataModel]? {
        didSet {
            if !self.isViewLoaded { return }

            itemsCollectionView.reloadData()
        }
    }
    
    @IBOutlet fileprivate weak var itemsCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register Collection View Cell
        let itemNib = UINib(nibName: "CatalogCell", bundle: nil)
        itemsCollectionView.register(itemNib, forCellWithReuseIdentifier: "CatalogCell")
        
        self.navigationController?.navigationBar.tintColor = UIColor.black

        configureBarButtonItems()
    }

}



//MARK:- Collection View Data Source Protocol Methods
extension ItemsCollectionController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let items = items else {
            fatalError("Missing Items Array!")
        }
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let items = items else {
            fatalError("Missing Items Array!")
        }
        let cell: CatalogCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatalogCell", for: indexPath) as! CatalogCell
        
        let item = items[indexPath.item]

        cell.cellData = CellData(item.catalogNumber!, item.name!)
        
        return cell
    }
    
}



//MARK:- Collection View Delegate Flow Layout Protocol Methods
extension ItemsCollectionController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let availableWidth = collectionView.bounds.size.width
        let columns: CGFloat = 3
        
        let availableItemWidth = availableWidth - (columns - 1) * flowLayout.minimumInteritemSpacing - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        
        let itemWidth = availableItemWidth / columns
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let items = items else {
            fatalError("Missing Items Array!")
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ic = storyboard.instantiateViewController(withIdentifier: "ItemController") as! ItemController
        let item = items[indexPath.item]
        
        ic.itemsDataManager = itemsDataManager
        ic.item = item
        ic.title = item.name
        
        if self.title == "Favoriti" {
            ic.refreshDelegate = self
        }
        
        show(ic, sender: self)
    }
    
}



//MARK:- Navigation Controller Bar Button Item Methods
fileprivate extension ItemsCollectionController {
    
    //
    // Method for adding Bar Button Items to Navigation Controller
    //
    func configureBarButtonItems() {
        if self.title == "Favoriti" {
            let home = UIBarButtonItem(image: UIImage(named: "HomeButton"), style: .done, target: self, action: #selector(dismissController))
            let clean = UIBarButtonItem(title: "Delete All", style: .done, target: self, action: #selector(deleteAll))
            
            home.tintColor = UIColor.black
            clean.tintColor = UIColor.black
            
            navigationItem.leftBarButtonItems = [home]
            navigationItem.rightBarButtonItems = [clean]
        }
    }
    
    
    //
    // Method for dismiss Items Collection Controller
    //
    @objc func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //
    // Method for delete all Items from favorites
    //
    @objc func deleteAll() {
        itemsDataManager?.favorites.removeAll()
        items?.removeAll()
    }
    
}



//MARK:- Refresh Delegate Method
extension ItemsCollectionController {
    
    //
    // Method reloads Collection View if Controller shows Favorites
    //
    func refreshUI(minus item: ItemDataModel) {
        if self.title == "Favoriti" {
            for (index, element) in items!.enumerated() {
                if element == item {
                    items?.remove(at: index)
                }
            }
        }
    }
    
}
