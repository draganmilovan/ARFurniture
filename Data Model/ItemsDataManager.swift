//
//  ItemsDataManager.swift
//  AR Furniture
//
//  Created by Dragan Milovanovic on 9/24/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import Foundation


final class ItemsDataManager {
    
    var items = [ItemDataModel]()
    
    
    
    private func populateItems() {
        let url = Bundle.main.path(forResource: "ItemsData", ofType: "json")!
        do{
            let data = try Data(contentsOf: URL(fileURLWithPath: url))
            self.items = try JSONDecoder().decode([ItemDataModel].self, from: data)
        }
        catch{
            print("JSON error")
        }
    }
    
}
