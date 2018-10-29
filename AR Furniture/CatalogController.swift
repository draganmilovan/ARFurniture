//
//  CatalogViewController.swift
//  AR Furniture
//
//  Created by Dragan Milovanovic on 9/25/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import UIKit

class CatalogController: UIViewController {
    
    // Data source
    var itemsDataManager: ItemsDataManager? {
        didSet {
            if !self.isViewLoaded { return }
            
            seriesCollectionView.reloadData()
            categoriesCollectionView.reloadData()
            newItemsCollectionView.reloadData()
        }
    }

    @IBOutlet private weak var newItemsLabel: UILabel!
    @IBOutlet private weak var categoriesLabel: UILabel!
    @IBOutlet private weak var seriesLabel: UILabel!
    @IBOutlet fileprivate weak var newItemsCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var categoriesCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var seriesCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register Collection View Cells
        let catalogNib = UINib(nibName: "CatalogCell", bundle: nil)
        newItemsCollectionView.register(catalogNib, forCellWithReuseIdentifier: "CatalogCell")
        categoriesCollectionView.register(catalogNib, forCellWithReuseIdentifier: "CatalogCell")
        seriesCollectionView.register(catalogNib, forCellWithReuseIdentifier: "CatalogCell")
        
        let supportNib = UINib(nibName: "SupportCell", bundle: nil)
        newItemsCollectionView.register(supportNib, forCellWithReuseIdentifier: "SupportCell")
        categoriesCollectionView.register(supportNib, forCellWithReuseIdentifier: "SupportCell")
        seriesCollectionView.register(supportNib, forCellWithReuseIdentifier: "SupportCell")
        
        configureBarButtonItems()
    }
    
}



//MARK:- Collection View Data Source Protocol Methods
extension CatalogController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let itemsDataManager = itemsDataManager else {
            fatalError("Missing Data Manager!")
        }
        
        if collectionView == newItemsCollectionView {
            return countItems(at: itemsDataManager.newItems)
            
        } else if collectionView == categoriesCollectionView {
            return countItems(at: itemsDataManager.categories)
            
        } else {
            return countItems(at: itemsDataManager.series)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let itemsDataManager = itemsDataManager else {
            fatalError("Missing Data Manager!")
        }
        
        if collectionView == newItemsCollectionView {
            return createCell(for: collectionView,
                              at: indexPath,
                              with: itemsDataManager.newItems)
            
        } else if collectionView == categoriesCollectionView {
            return createCell(for: collectionView,
                              at: indexPath,
                              with: itemsDataManager.categories)
            
        } else {
            return createCell(for: collectionView,
                              at: indexPath,
                              with: itemsDataManager.series)
            
        }
    }
    
}



//Mark:- Collection View Flow Layout Protocol Methods
extension CatalogController: UICollectionViewDelegateFlowLayout {
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //
    //        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
    //        let availableWidth = collectionView.bounds.size.width
    //        let columns: CGFloat = 3
    //
    //        let availableItemWidth = availableWidth - (columns - 1) * flowLayout.minimumInteritemSpacing - flowLayout.sectionInset.left - flowLayout.sectionInset.right
    //
    //        let itemWidth = availableItemWidth / columns
    //
    //        return CGSize(width: itemWidth, height: itemWidth)
    //    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let itemsDataManager = itemsDataManager else {
            fatalError("Missing Data Manager!")
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ic = storyboard.instantiateViewController(withIdentifier: "ItemController") as! ItemController
        let icc = storyboard.instantiateViewController(withIdentifier: "ItemsCollectionController") as! ItemsCollectionController
        let ctvc = storyboard.instantiateViewController(withIdentifier: "CatalogTableViewController") as! CatalogTableViewController
        
        ic.itemsDataManager = itemsDataManager
        icc.itemsDataManager = itemsDataManager
        ctvc.itemsDataManager = itemsDataManager

        if collectionView == newItemsCollectionView {
            
            if let cell = collectionView.cellForItem(at: indexPath) as? CatalogCell {
                let item = itemsDataManager.newItems[indexPath.item]
                
                ic.item = item
                ic.title = cell.cellData!.name
                
                show(ic, sender: self)
                
            } else {
                
                icc.items = itemsDataManager.newItems
                icc.title = "Novo"
                
                show(icc, sender: self)
            }
            
        } else if collectionView == categoriesCollectionView {
            
            if let cell = collectionView.cellForItem(at: indexPath) as? CatalogCell {
                let category = cell.cellData!.name
                
                icc.items = itemsDataManager.searchForItemsBy(category: category)
                icc.title = category
                
                show(icc, sender: self)

            } else {
                ctvc.itemsDataManager = itemsDataManager
                ctvc.title = "Kategorije"
                
                show(ctvc, sender: self)
            }
            
        } else {
            
            if let cell = collectionView.cellForItem(at: indexPath) as? CatalogCell {
                let serie = cell.cellData!.name
                
                icc.items = itemsDataManager.searchItemsBy(serie: serie)
                icc.title = serie
                
                show(icc, sender: self)
                
            } else {
                ctvc.itemsDataManager = itemsDataManager
                ctvc.title = "Serije"
                
                show(ctvc, sender: self)
            }
        }
    }
    
}



//MARK:- Collection View private methods
fileprivate extension CatalogController {
    
    //
    // Method return max number five when counting array items
    // Used in method(numberOfItemsInSection) for Collection View with max five items
    //
    func countItems<Element>(at array: [Element]) -> Int {
        var zeroToFive = 5
        
        if array.count < 5 {
            zeroToFive = array.count
        }
        return zeroToFive
    }
    
    
    //
    // Method for creating Collection View Cells
    // Collection View must have Max five items!
    //
    func createCell<Element>(for collectionView: UICollectionView, at indexPath: IndexPath, with array: [Element]) -> UICollectionViewCell {
        guard let itemsDataManager = itemsDataManager else {
            fatalError("Missing Data Manager!")
        }
        
        let supportCell: SupportCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SupportCell", for: indexPath) as! SupportCell
        let cell: CatalogCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatalogCell", for: indexPath) as! CatalogCell
    
        var imageName: String
        var itemName: String
        
        if collectionView == newItemsCollectionView {
            imageName = (itemsDataManager.newItems[indexPath.item].catalogNumber)!
            itemName = (itemsDataManager.newItems[indexPath.item].name)!
            
        } else {
            imageName = array[indexPath.item] as! String
            itemName = array[indexPath.item] as! String
        }
        
        let cellData = CellData(imageName, itemName)
        cell.cellData = cellData
        
        if array.count != 5 {
            switch (indexPath.item) {
            case 0..<4 :
                return cell
                
            default:
                return supportCell
            }
        } else {
            return cell
        }
    }
    
}



//MARK:- Navigation Controller Bar Button Item Methods
fileprivate extension CatalogController {

    //
    // Method for adding Bar Button Items to Navigation Controller
    //
    func configureBarButtonItems() {
        
        let search = UIBarButtonItem(image: UIImage(named: "Search"), style: .done, target: self, action: #selector(showSearch))
        let home = UIBarButtonItem(image: UIImage(named: "HomeButton"), style: .done, target: self, action: #selector(dismissController))
        
        search.tintColor = UIColor.black
        home.tintColor = UIColor.black
        
        navigationItem.rightBarButtonItems = [search]
        navigationItem.leftBarButtonItems = [home]
    }
    
    
    //
    // Method for showing Search Controller
    //
    @objc func showSearch() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sc = storyboard.instantiateViewController(withIdentifier: "SearchController") as! SearchController
        
        sc.itemsDataManager = itemsDataManager
        
        show(sc, sender: self)
    }
    
    
    //
    // Method for dismiss Catalog Controller
    //
    @objc func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
