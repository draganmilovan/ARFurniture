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
    fileprivate var isPlaneDetected = false
    
    @IBOutlet fileprivate weak var sceneView: ARSCNView!
    @IBOutlet fileprivate weak var infoLabel: UILabel!
    
    fileprivate let configuration = ARWorldTrackingConfiguration()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = [SCNDebugOptions.showFeaturePoints]
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(notification:)),
                                               name: Notification.Name("tryItem"),
                                               object: nil)
        
        registerGestureRecognzers()
        
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
        let cvc = storyboard.instantiateViewController(withIdentifier: "CatalogController") as! CatalogController
        let nc = UINavigationController(rootViewController: cvc)
        
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



//MARK:- AR SCNView custom methods
fileprivate extension ARFurnitureController {
    
    //
    // Method for gesture recognition
    //
    func registerGestureRecognzers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        let rotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotate))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan))
        
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        sceneView.addGestureRecognizer(rotationGestureRecognizer)
        sceneView.addGestureRecognizer(panGestureRecognizer)
    }
    
    
    //
    // Method for handle tap gesture
    //
    @objc func tapped(sender: UITapGestureRecognizer) {
        guard let sceneView = sender.view as? ARSCNView else { return }
        let tapLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        if !hitTest.isEmpty {
            showItem(hitTestResult: hitTest.first!)
        } else { print("Missing hitTest!") }
    }
    
    
    //
    // Method for handle rotation gesture
    //
    @objc func rotate(sender: UIRotationGestureRecognizer) {
        guard let sceneView = sender.view as? ARSCNView else { return }
        let rotationLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(rotationLocation)
        
        if !hitTest.isEmpty {
            guard let result = hitTest.first else { return }
            let node = result.node
            
            if sender.state == .changed {
                let rotation = SCNAction.rotateBy(x: 0,
                                                  y: -sender.rotation,
                                                  z: 0,
                                                  duration: 0)
                node.runAction(rotation)
                sender.rotation = 0
            }
        }
    }
    
    
    //
    // Method for handle pan gesture
    //
    @objc func pan(sender: UIPanGestureRecognizer) {
        guard let sceneView = sender.view as? ARSCNView else { return }
        let panLocation = sender.location(in: sceneView)
        let nodeHitTest = sceneView.hitTest(panLocation)
        
        if !nodeHitTest.isEmpty {
            guard let result = nodeHitTest.first else { return }
            let node = result.node
            
            guard let planeHitTest = sceneView.hitTest(panLocation, types: .existingPlane).first else { return }
            let worldTransform = planeHitTest.worldTransform
            let x = worldTransform.columns.3.x
            let y = worldTransform.columns.3.y
            let z = worldTransform.columns.3.z
            
            if sender.state == .changed {
                node.position = SCNVector3(x, y, z)
            }
        }
    }
    
    
    //
    // Method for adding Models to the Scene
    //
    func showItem(hitTestResult: ARHitTestResult) {
        guard let itemMark = selectedItem?.catalogNumber else {
            print("Missing selectedItem!")
            return }
        guard let scene = SCNScene(named: "ModelsCatalog.scnassets/\(itemMark).scn") else {
            print("Missing scene!")
            return }
        guard let node = scene.rootNode.childNode(withName: itemMark, recursively: false) else {
            print("Missing node!")
            return }
        
        let transform = hitTestResult.worldTransform
        let thirdColumn = transform.columns.3
        
        node.position = SCNVector3(x: thirdColumn.x,
                                   y: thirdColumn.y,
                                   z: thirdColumn.z)
        
        if itemMark == "4" {
            centerPivot(for: node)
        }
        
        sceneView.scene.rootNode.addChildNode(node)
        
    }
    
    
    //
    // Method for adding center of coordinate sistem in center of Node
    //
    func centerPivot(for node: SCNNode) {
        let min = node.boundingBox.min
        let max = node.boundingBox.max
        
        node.pivot = SCNMatrix4MakeTranslation(
            min.x + (max.x - min.x)/2,
            min.y + (max.y - min.y)/2,
            min.z + (max.z - min.z)/2)
    }
    
}



// MARK:- ARSCNViewDelegate Methods
extension ARFurnitureController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        
        isPlaneDetected = true
        
        DispatchQueue.main.async {
            [unowned self] in
            
            if self.selectedItem != nil {
                self.infoLabel.text = "Označi mesto gde želiš da se prikaže \(self.selectedItem!.name!)"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    self.infoLabel.text = nil
                })
            } else {
                self.infoLabel.text = "Spremno Za Proširenu Stvarnost!"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    self.infoLabel.text = nil
                })
            }
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
        
        if isPlaneDetected {
            
            // Inform user to place item in scene
            DispatchQueue.main.async {
                [unowned self] in
                
                self.infoLabel.text = "Označi mesto gde želiš da se prikaže \(item.name!)"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    self.infoLabel.text = nil
                })
            }
        } else {
            
            // Inform user to move device to detect plane for AR
            DispatchQueue.main.async {
                [unowned self] in
                
                self.infoLabel.text = "Sačekajte da se detektuje površina."
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    self.infoLabel.text = nil
                })
            }
        }

    }
    
}



extension Int {
    
    var degreesToRadiants: Double { return Double(self) * .pi/180 }
}
