//
//  InfoViewController.swift
//  AR Furniture
//
//  Created by Igor Aleksic on 9/25/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import UIKit
import MapKit

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    
    var infoDataManager = InfoDataManager()

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
   
    
    @IBAction func myLocation(_ sender: Any) {
        tableView.reloadData()
    }
    
    //tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoDataManager.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreInfoCell", for: indexPath) as! StoreInfoTableViewCell
        cell.updateUI(storeInfo : infoDataManager.items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //put pin on the map
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: infoDataManager.items[indexPath.row].coordinates.lat , longitude: infoDataManager.items[indexPath.row].coordinates.long)
        mapView.addAnnotation(pin)
        
        //center map
        let storeLocation = CLLocation(latitude: infoDataManager.items[indexPath.row].coordinates.lat , longitude: infoDataManager.items[indexPath.row].coordinates.long)
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(location: storeLocation)

    }
    //pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return infoDataManager.items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return infoDataManager.items[row].address
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
     
        // picker selection
        let addressSelected = infoDataManager.items[pickerView.selectedRow(inComponent: 0)]
         
       
    }
    
}
