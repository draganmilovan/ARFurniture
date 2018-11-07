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
    
    fileprivate var hideStatusBar: Bool = false
    fileprivate var selectedItem: ItemDataModel?
    fileprivate var activeNodes: [SCNNode] = []
    fileprivate var selectedNode: SCNNode?
    fileprivate var isPlaneDetected = false {
        didSet {
            planeDetectionMessage()
        }
    }
    
    @IBOutlet fileprivate weak var sceneView: ARSCNView!
    @IBOutlet fileprivate weak var infoLabel: UILabel!
    @IBOutlet fileprivate weak var deleteButton: UIButton!
    @IBOutlet fileprivate weak var infoButton: UIButton!
    @IBOutlet fileprivate weak var addButton: UIButton!
    @IBOutlet fileprivate weak var favButton: UIButton!
    
    fileprivate let configuration = ARWorldTrackingConfiguration()
    
    override var prefersStatusBarHidden: Bool {
        return hideStatusBar
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.fade
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteButton.alpha = 0
        
        configureScene()
        registerGestureRecognzers()
        
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
        let cvc = storyboard.instantiateViewController(withIdentifier: "CatalogController") as! CatalogController
        let nc = UINavigationController(rootViewController: cvc)
        
        cvc.itemsDataManager = itemsDataManager
        cvc.title = "Katalog"
        
        show(nc, sender: self)
    }
    
    @IBAction private func removeItem(_ sender: UIButton) {
        
        for (index, element) in activeNodes.enumerated() {
            if element == selectedNode {
                activeNodes.remove(at: index)
                selectedNode?.removeFromParentNode()
                selectedNode = nil
            }
        }
        deleteButton.alpha = 0
    }
    
    @IBAction private func showFavorites(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let icc = storyboard.instantiateViewController(withIdentifier: "ItemsCollectionController") as! ItemsCollectionController
        let nc = UINavigationController(rootViewController: icc)
        
        icc.itemsDataManager = itemsDataManager
        icc.items = itemsDataManager?.favorites
        icc.title = "Favoriti"
        
        show(nc, sender: self)
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
        
        // Hide or show buttons if scene contains node,
        // If Node is tapped Method
        if activeNodes.count > 0 {
            if addButton.alpha == 0 {
                showUI()
            } else if didTapNode(at: tapLocation) {
                showUI()
            } else {
                hideUI()
            }
        }
        
        // If Plane is tapped
        let planeHitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        
        if !planeHitTest.isEmpty {
            showItem(hitTestResult: planeHitTest.first!)
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
        guard let itemMark = selectedItem?.catalogNumber else { return }
        guard let scene = SCNScene(named: "ModelsCatalog.scnassets/\(itemMark).scn") else { return }
        guard let node = scene.rootNode.childNode(withName: itemMark, recursively: false) else { return }
        
        let transform = hitTestResult.worldTransform
        let thirdColumn = transform.columns.3
        
        node.position = SCNVector3(x: thirdColumn.x,
                                   y: thirdColumn.y,
                                   z: thirdColumn.z)
        
        if itemMark == "401" {
            centerPivot(for: node)
        } else if itemMark == "501" {
            centerPivot(for: node)
        } else if itemMark == "502" {
            centerPivot(for: node)
        }
        
        sceneView.scene.rootNode.addChildNode(node)
        
        selectedNode = node
        activeNodes.append(node)
        selectedItem = nil
        hideUI()
    }
    
    
    //
    // Method return True if Node tapped and set Selected Node property
    //
    func didTapNode(at location: CGPoint) -> Bool {
        let nodeHitTest = sceneView.hitTest(location)
        
        if !nodeHitTest.isEmpty {
            guard let node = nodeHitTest.first?.node else {
                return false
            }
            
            if activeNodes.contains(node) {
                selectedNode = node
            }
            return true
        } else {
            return false
        }
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
    
    
    //
    // Method configures ARSCNView
    //
    func configureScene() {
        
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = [SCNDebugOptions.showFeaturePoints]
        
    }
    
}



// MARK:- ARSCNViewDelegate Methods
extension ARFurnitureController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        
        if !isPlaneDetected {
            isPlaneDetected = true
        }
    }
    
}



// MARK:- AR Furniture private methods
fileprivate extension ARFurnitureController {
    
    //
    // Method display message for user info
    //
    func informUser(with text: String) {
        DispatchQueue.main.async {
            [unowned self] in
            
            self.infoLabel.text = text
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.infoLabel.text = nil
            })
        }
    }
    
    
    //
    // Method hide buttons and Status Bar
    //
    func hideUI() {
        
        hideStatusBar = true

        UIView.animate(withDuration: 0.25, animations: {
            [unowned self] in
            
            self.infoButton.alpha = 0
            self.addButton.alpha = 0
            self.favButton.alpha = 0
            self.deleteButton.alpha = 0
            
            self.setNeedsStatusBarAppearanceUpdate()
        })
        
    }
    
    
    //
    // Method show buttons and Status Bar
    //
    func showUI() {
        
        hideStatusBar = false

        UIView.animate(withDuration: 0.25, animations: {
            [unowned self] in
            
            self.infoButton.alpha = 1
            self.addButton.alpha = 1
            self.favButton.alpha = 1
            
            if self.selectedNode != nil {
                self.deleteButton.alpha = 1
            } else {
                self.deleteButton.alpha = 0
            }
            
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    
    //
    // Method inform user about plane detection
    //
    func planeDetectionMessage() {
        if selectedItem != nil {
            informUser(with: "Označite mesto gde želite da se prikaže \(selectedItem!.name!)")
        } else {
            informUser(with: "Spremno Za Proširenu Stvarnost!")
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
            informUser(with: "Označite mesto gde želite da se prikaže \(item.name!)")
        } else {
            informUser(with: "Sačekajte da se detektuje površina.")
        }
    }
    
}



extension Int {
    
    var degreesToRadiants: Double { return Double(self) * .pi/180 }
}
