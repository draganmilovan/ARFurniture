//
//  SearchController.swift
//  AR Furniture
//
//  Created by Dragan Milovanovic on 10/1/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import UIKit

class SearchController: UIViewController {
    
    // Data source
    var itemsDataManager: ItemsDataManager? {
        didSet {
            if !self.isViewLoaded { return }
            
            searchResultCollectionView.reloadData()
        }
    }
    
    @IBOutlet fileprivate weak var itemSearchBar: UISearchBar!
    @IBOutlet fileprivate weak var searchResultCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register Collection View Cell
        let catalogNib = UINib(nibName: "CatalogCell", bundle: nil)
        searchResultCollectionView.register(catalogNib, forCellWithReuseIdentifier: "CatalogCell")
    }

}



//MARK:- Collection View Data Source Protocol Methods
extension SearchController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CatalogCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatalogCell", for: indexPath) as! CatalogCell

        return cell
    }

}



//MARK:- Collection View Delegate Flow Layout Protocol Methods
extension SearchController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let availableWidth = collectionView.bounds.size.width
        let columns: CGFloat = 3
        
        let availableItemWidth = availableWidth - (columns - 1) * flowLayout.minimumInteritemSpacing - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        
        let itemWidth = availableItemWidth / columns
        
        return CGSize(width: itemWidth, height: itemWidth)
    }

}