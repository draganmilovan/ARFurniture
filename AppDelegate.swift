//
//  AppDelegate.swift
//  AR Furniture
//
//  Created by Dragan Milovanovic on 9/21/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var itemsDataManager: ItemsDataManager?
    
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        configureImageDataManager()
        
        if let vc = window?.rootViewController as? ARFurnitureController {
            vc.itemsDataManager = itemsDataManager
        }
        
        return true
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
}


// AppDelegate private method
fileprivate extension AppDelegate {
    
    func configureImageDataManager() {
        itemsDataManager = ItemsDataManager()
    }
    
}
