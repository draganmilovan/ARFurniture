//
//  ItemsDataManager.swift
//  AR Furniture
//
//  Created by Dragan Milovanovic on 9/24/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import Foundation


final class ItemsDataManager {
    
    var items: [ItemDataModel] = []
    
    init() {
        populateItems()
    }
    
    private func populateItems() {
        print("Items Created!")
    }
    
}
