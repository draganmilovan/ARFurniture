//
//  ViewController.swift
//  AR Furniture
//
//  Created by Dragan Milovanovic on 9/21/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import UIKit
import ARKit

class ARFurnitureController: UIViewController {
    
    var itemsDataManager: ItemsDataManager?
    fileprivate var selectedItem: ItemDataModel?
    
    @IBOutlet fileprivate weak var sceneView: ARSCNView!
    @IBOutlet fileprivate weak var infoLabel: UILabel!
    
    fileprivate let configuration = ARWorldTrackingConfiguration()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration.planeDetection = .horizontal
        
        sceneView.debugOptions = [SCNDebugOptions.showFeaturePoints]
        
        sceneView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(notification:)),
                                               name: Notification.Name("tryItem"),
                                               object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    @IBAction private func addItem(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nc = storyboard.instantiateViewController(withIdentifier: "ARFNavigationController") as! UINavigationController
        let cvc = nc.topViewController as! CatalogController
        
        cvc.itemsDataManager = itemsDataManager
        
        show(nc, sender: self)
    }
    
    @IBAction private func removeItem(_ sender: UIButton) {
        print("DEL Button Touched!")
    }
    
    @IBAction private func showFavorites(_ sender: UIButton) {
        print("FAV Button Touched!")
    }
    
    @IBAction private func showManifactureInfo(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nc = storyboard.instantiateViewController(withIdentifier: "InfoNavigationController") as! UINavigationController
     
        show(nc, sender: self)
    }
    
}



// MARK:-
extension ARFurnitureController {
    
    
    
}



// MARK:- ARSCNViewDelegate Methods
extension ARFurnitureController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        
        DispatchQueue.main.async {
            [unowned self] in
            
            // Show Info Label
            self.infoLabel.isHidden = false
            
            // Hide Info Label after three seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.infoLabel.isHidden = true
            })
        }
    }
    
}



// MARK:- Method for handling received Notification
fileprivate extension ARFurnitureController {
    
    //
    // Method set Selected Item for use in Scene
    //
    @objc func notificationReceived(notification: NSNotification){
        guard let itemData = notification.userInfo as NSDictionary? else { return }
        guard let item = itemData["Item"] as? ItemDataModel else { return }
        
        selectedItem = item
        
        // Inform user to place item in scene
    }
    
}
