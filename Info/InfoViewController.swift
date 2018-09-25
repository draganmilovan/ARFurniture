//
//  InfoViewController.swift
//  AR Furniture
//
//  Created by Igor Aleksic on 9/25/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import UIKit
import MapKit

class InfoViewController: UIViewController {
    
    var infoDataManager = InfoDataManager()

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var hours: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func myLocation(_ sender: Any) {
    }
    
}
