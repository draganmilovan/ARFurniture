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
                              with: itemsDataManager.newItems,
                              imageName: itemsDataManager.newItems[indexPath.item].catalogNumber!,
                              itemName: itemsDataManager.newItems[indexPath.item].name!)
            
        } else if collectionView == categoriesCollectionView {
            return createCell(for: collectionView,
                              at: indexPath,
                              with: itemsDataManager.categories,
                              imageName: itemsDataManager.categories[indexPath.item],
                              itemName: itemsDataManager.categories[indexPath.item])
            
        } else {
            return createCell(for: collectionView,
                              at: indexPath,
                              with: itemsDataManager.series,
                              imageName: itemsDataManager.series[indexPath.item],
                              itemName: itemsDataManager.series[indexPath.item])
            
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



//MARK:- Collection View private methods
fileprivate extension CatalogViewController {
    
    //
    // Method return max number five when counting array items
    // Used in method(numberOfItemsInSection) for Collection View with max five items
    //
    func countItems<T>(at array: [T]) -> Int {
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
    func createCell<T>(for collectionView: UICollectionView, at indexPath: IndexPath, with array: [T], imageName: String, itemName: String ) -> UICollectionViewCell {
        
        let supportCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SupportCell", for: indexPath)
        let cell: CatalogCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatalogCell", for: indexPath) as! CatalogCell
        
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
