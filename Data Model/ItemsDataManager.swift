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
            populateNewItems()
        }
    }
    
    var categories: [String] = []
    var series: [String] = []
    var newItems: [ItemDataModel] = []
    var favorites: [ItemDataModel] = []
    
    
    init() {
        populateItems()
        populateFavorites()
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

            items = try JSONDecoder().decode([ItemDataModel].self, from: data)
        }
        catch {
            print("JSON error")
        }
    }


    //
    // Method for populating categories Array
    //
    func populateCategories() {
        guard let items = items else { return }
        var ctgs: [String] = []

        ctgs = items.flatMap {
            $0.categoryTags!
        }

        ctgs.compactMap {
            if !categories.contains($0), $0 != "" {
                categories.append($0)
            }
        }

        categories.sort()

    }


    //
    // Method for populating series Array
    //
    func populateSeries() {
        guard let items = items else { return }

        items.compactMap {
            if !series.contains($0.seriesTag!), $0.seriesTag != "" {
                series.append($0.seriesTag!)
            }
        }
        
        series.sort()
    }


    //
    // Method for populating newItems Array
    //
    func populateNewItems() {
        guard let items = items else { return }

        newItems = items.filter {
            $0.descriptionTags!.contains("novo")
        }
    }
    
    
    //
    // Method for populating favorites Array
    //
    func populateFavorites() {
        
    }
    
}



//Mark:- Items Data Manager methods
extension ItemsDataManager {
    
    //
    // Method
    //
    func searchForItemsBy(category: String) -> [ItemDataModel] {
        guard let items = items else { return [] }
        
        return items.filter {
            $0.categoryTags!.contains(category)
        }
    }
    
    
    //
    // Method
    //
    func searchItemsBy(serie: String) -> [ItemDataModel] {
        guard let items = items else { return [] }
        
        return items.filter {
            $0.seriesTag!.contains(serie)
        }
    }
    
}
