//
//  CatalogTableViewController.swift
//  AR Furniture
//
//  Created by Dragan Milovanovic on 10/5/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import UIKit

class CatalogTableViewController: UIViewController {
    
    // Data source
    var itemsDataManager: ItemsDataManager? {
        didSet {
            if !self.isViewLoaded { return }

            catalogTableView.reloadData()
        }
    }
    
    @IBOutlet weak var catalogTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}



//Mark:- Table View Data Source Protocol Methods
extension CatalogTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let itemsDataManager = itemsDataManager else {
            fatalError("Missing Items Data Manager!")
        }
        
        if self.title == "Kategorije" {
            return itemsDataManager.categories.count
            
        } else {
            return itemsDataManager.series.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemsDataManager = itemsDataManager else {
            fatalError("Missing Items Data Manager!")
        }
        let cell = catalogTableView.dequeueReusableCell(withIdentifier: "CatalogTableViewCell", for: indexPath) as! CatalogTableViewCell
        
        if self.title == "Kategorije" {
            cell.rowLabelText = itemsDataManager.categories[indexPath.row]
        } else {
            cell.rowLabelText = itemsDataManager.series[indexPath.row]
        }
        
        return cell
    }
    
}



//Mark:- Table View Delegate Methods
extension CatalogTableViewController: UITableViewDelegate {
    
    
    
}
