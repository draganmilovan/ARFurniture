//
//  InfoDataManager.swift
//  AR Furniture
//
//  Created by Igor Aleksic on 9/25/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import Foundation

final class InfoDataManager {
    
    var items = [StoreInfo]()
    
    init () {
        populateItems()
    }
    
    private func populateItems() {
        let url = Bundle.main.path(forResource: "StoreInfo", ofType: "json")!
        do{
            let data = try Data(contentsOf: URL(fileURLWithPath: url))
            self.items = try JSONDecoder().decode([StoreInfo].self, from: data)
        }
        catch{
            print("JSON error")
        }
    }
    
}

