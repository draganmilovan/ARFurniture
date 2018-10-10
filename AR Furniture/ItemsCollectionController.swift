//
//  ItemsCollectionController.swift
//  AR Furniture
//
//  Created by Dragan Milovanovic on 10/8/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import UIKit

class ItemsCollectionController: UIViewController {

    // Data source
    var items: [ItemDataModel]? {
        didSet {
            if !self.isViewLoaded { return }

            itemsCollectionViewController.reloadData()
        }
    }
    
    @IBOutlet fileprivate weak var itemsCollectionViewController: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register Collection View Cell
        let itemNib = UINib(nibName: "CatalogCell", bundle: nil)
        itemsCollectionViewController.register(itemNib, forCellWithReuseIdentifier: "CatalogCell")
        
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
        
        ic.item = item
        ic.title = item.name
        
        show(ic, sender: self)
    }
    
}
