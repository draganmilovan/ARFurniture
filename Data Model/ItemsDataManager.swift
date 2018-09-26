//
//  ItemsDataManager.swift
//  AR Furniture
//
//  Created by Dragan Milovanovic on 9/24/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import Foundation


final class ItemsDataManager {
    
    var items: [ItemDataModel]? {
        didSet {
            populateCategories()
            populateSeries()
        }
    }
    
    var categories: [String] = []
    var series: [String] = []
    
    
    init() {
        populateItems()
    }
    
}


// MARK:- Items Data Manager private methods
fileprivate extension ItemsDataManager {
    
    //
    // Method for populating items Array
    //
    func populateItems() {
        guard let url = Bundle.main.path(forResource: "ItemsData", ofType: "json") else {
            fatalError("Missing ItemsData JSON!")
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: url))
            
            self.items = try JSONDecoder().decode([ItemDataModel].self, from: data)
        }
        catch {
            print("JSON error")
        }
    }
    
    
    //
    // Method for populating categories Array
    //
    func populateCategories() {
        //guard let items = items else { return }

    }
    
    
    //
    // Method for populating series Array
    //
    func populateSeries() {
        
    }
    
}
