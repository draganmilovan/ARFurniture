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
    var tableViewRawDatas: ItemsDataManager? {
        didSet {
            if !self.isViewLoaded { return }

            catalogTableView.reloadData()
        }
    }
    
    @IBOutlet weak var catalogTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}



//Mark:- Table View Data Source Protocol Methods
extension CatalogTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = catalogTableView.dequeueReusableCell(withIdentifier: "CatalogTableViewCell", for: indexPath)
        
        
        
        return cell
    }
    
}



//Mark:- Table View Delegate Methods
extension CatalogTableViewController: UITableViewDelegate {
    
    
    
}
