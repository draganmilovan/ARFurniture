//
//  CatalogViewController.swift
//  AR Furniture
//
//  Created by Dragan Milovanovic on 9/25/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import UIKit

class CatalogViewController: UIViewController {
    
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
        
    }
    
    
    @IBAction func dismissCatalog(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}



//MARK:- Collection View Protocol Methods
extension CatalogViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let itemsDataManager = itemsDataManager else { fatalError("Missing Data Manager!") }
        
        var numberOfItems = 5
        
        if collectionView == newItemsCollectionView {
            
            if itemsDataManager.newItems.count < 5 {
                numberOfItems = itemsDataManager.newItems.count
            }
            
        } else if collectionView == categoriesCollectionView {
            
            if itemsDataManager.categories.count < 5 {
                numberOfItems = itemsDataManager.categories.count
            }
            
        } else {
            
            if itemsDataManager.series.count < 5 {
                numberOfItems = itemsDataManager.series.count
            }
        }
        
        return numberOfItems
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let itemsDataManager = itemsDataManager else { fatalError("Missing Data Manager!") }
        
        let supportCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SupportCell", for: indexPath)
        
        if collectionView == newItemsCollectionView {
            let newItemCell: CatalogCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatalogCell", for: indexPath) as! CatalogCell
            
            let newItemCellData = CellData(itemsDataManager.newItems[indexPath.item].catalogNumber!,
                                           itemsDataManager.newItems[indexPath.item].name!)
            
            newItemCell.cellData = newItemCellData
            
            if itemsDataManager.newItems.count != 5 {
                switch (indexPath.item) {
                case 0..<4 :
                    return newItemCell
                    
                default:
                    return supportCell
                }
            } else {
                return newItemCell
            }

        } else if collectionView == categoriesCollectionView {
            let categoriesCell: CatalogCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatalogCell", for: indexPath) as! CatalogCell
            
            let catCellData = CellData(itemsDataManager.categories[indexPath.item],
                                       itemsDataManager.categories[indexPath.item])
            
            categoriesCell.cellData = catCellData
            
            if itemsDataManager.categories.count != 5 {
                switch (indexPath.item) {
                case 0..<4 :
                    return categoriesCell
                    
                default:
                    return supportCell
                }
            } else {
                return categoriesCell
            }
            
        } else {
            let seriesCell: CatalogCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatalogCell", for: indexPath) as! CatalogCell
            
            let serCellData = CellData(itemsDataManager.series[indexPath.item],
                                       itemsDataManager.series[indexPath.item])
            
            seriesCell.cellData = serCellData
            
            if itemsDataManager.series.count != 5 {
                switch (indexPath.item) {
                case 0..<4 :
                    return seriesCell
                    
                default:
                    return supportCell
                }
            } else {
                return seriesCell
            }
        }
    }
    
    
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
}
