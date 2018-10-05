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
    
    fileprivate var searchTerm: String? {
        didSet {
            searchingForItems()
        }
    }
    
    fileprivate var searchedItems: [ItemDataModel] = []
    
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
        return searchedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CatalogCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatalogCell", for: indexPath) as! CatalogCell
        
        let item = searchedItems[indexPath.item]
        
        cell.cellData = CellData(item.catalogNumber!, item.name!)

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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        itemSearchBar.resignFirstResponder()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ic = storyboard.instantiateViewController(withIdentifier: "ItemController") as! ItemController
        let item = searchedItems[indexPath.item]
        
        ic.item = item
        ic.title = item.name

        show(ic, sender: self)
    }
    
    
    //
    // Method for jump on top of Collection View
    //
    fileprivate func scrollToTop() {
        let indexPath = IndexPath(item: 0, section: 0)
        searchResultCollectionView.scrollToItem(at: indexPath,
                                                at: .top,
                                                animated: true)
    }
    
}



//MARK:- Methods for using Search Field
extension SearchController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        searchedItems.removeAll()
        
        if searchText.count == 0 {
            searchTerm = nil
            //searchedItems.removeAll()
            searchResultCollectionView.reloadData()
            return
        }
        searchTerm = searchText
    }
    
    
    //
    // Method for search
    //
    fileprivate func searchingForItems() {
        
        guard let items = itemsDataManager?.items else { return }
        guard let st = searchTerm else { return }
        
        let predicate = NSPredicate(format: "SELF contains[cd] %@", st)
        
        for item in items {
            for tag in item.descriptionTags! {
                if !searchedItems.contains(item), predicate.evaluate(with: tag) {
                    searchedItems.append(item)
                }
            }
        }
        
        searchResultCollectionView.reloadData()
        
        if searchedItems.count != 0 {
            scrollToTop()
        }
    }
    
}
