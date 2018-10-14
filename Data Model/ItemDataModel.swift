//
//  Data Model.swift
//  AR Furniture
//
//  Created by Dragan Milovanovic on 9/24/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import Foundation


struct ItemDataModel: Codable {
    
    let catalogNumber: String?
    let name: String?
    let seriesTag: String?
    let categoryTags: [String]?
    let descriptionTags: [String]?
    
}



extension ItemDataModel: Hashable {
    
    var hashValue: Int {
        return catalogNumber.hashValue ^ name.hashValue ^ seriesTag.hashValue ^ categoryTags!.hashValue ^ descriptionTags!.hashValue
    }
    
    static func ==(i1: ItemDataModel, i2: ItemDataModel) -> Bool {
        return i1.hashValue == i2.hashValue
    }
    
}
