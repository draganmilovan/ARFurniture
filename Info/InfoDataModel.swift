//
//  InfoDataModel.swift
//  AR Furniture
//
//  Created by Igor Aleksic on 9/25/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import Foundation

struct StoreInfo : Decodable {
    
    let name : String
    let address : String
    let tel : String
    let email : String
    let hours : String
    let coordinates : Coordinates
    
}

struct Coordinates : Decodable {
    let long : Double
    let lat : Double
}

