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
    
    @IBOutlet fileprivate weak var sceneView: ARSCNView!
    @IBOutlet fileprivate weak var infoLabel: UILabel!
    
    fileprivate let configuration = ARWorldTrackingConfiguration()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration.planeDetection = .horizontal
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        sceneView.delegate = self
        
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
    
    
    @IBAction func addItem(_ sender: UIButton) {
        print("ADD Button Touched!")
    }
    
    @IBAction func removeItem(_ sender: UIButton) {
        print("DEL Button Touched!")
    }
    
    @IBAction func showFavorites(_ sender: UIButton) {
        print("FAV Button Touched!")
    }
    
    @IBAction func showManifactureInfo(_ sender: UIButton) {
        print("INFO Button Touched!")
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
