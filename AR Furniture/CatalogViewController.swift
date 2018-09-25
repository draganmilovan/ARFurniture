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
    var itemsDataManager: ItemsDataManager?

    @IBOutlet private weak var newItemsLabel: UILabel!
    @IBOutlet private weak var categoriesLabel: UILabel!
    @IBOutlet private weak var seriesLabel: UILabel!
    @IBOutlet fileprivate weak var newItemsCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var categoriesCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var seriesCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register Collection View Cell
        let catalogNib = UINib(nibName: "CatalogCell", bundle: nil)
        newItemsCollectionView.register(catalogNib, forCellWithReuseIdentifier: "CatalogCell")
        categoriesCollectionView.register(catalogNib, forCellWithReuseIdentifier: "CatalogCell")
        seriesCollectionView.register(catalogNib, forCellWithReuseIdentifier: "CatalogCell")
        
    }

}



//MARK:- Collection View Protocol Methods
extension CatalogViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        guard let itemsDataManager = itemsDataManager else { fatalError("Missing Data Manager!") }
        
        if collectionView == newItemsCollectionView {
            let newItemCell: CatalogCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatalogCell", for: indexPath) as! CatalogCell
            
            // Set up Cell!
            
            return newItemCell
            
        } else if collectionView == categoriesCollectionView {
            let categoriesCell: CatalogCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatalogCell", for: indexPath) as! CatalogCell
            
            // Set up Cell!
            
            return categoriesCell
            
        } else {
            let seriesCell: CatalogCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatalogCell", for: indexPath) as! CatalogCell
            
            // Set up Cell!
            
            return seriesCell
            
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
