//
//  InfoViewController.swift
//  AR Furniture
//
//  Created by Igor Aleksic on 9/25/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class InfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate {
    
    var infoDataManager = InfoDataManager()
    var locationManager = CLLocationManager()
    @IBOutlet weak var locationStatusLbl: UILabel!
    
    @IBAction func homeBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        
    
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count-1]
       
        if location.horizontalAccuracy > 0 {
           
            locationManager.stopUpdatingLocation()
            
        }
        print(location.coordinate)
    }
   
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
        locationStatusLbl.text = "Nije moguće utvrditi lokaciju"
    }

    
    @IBAction func myLocation(_ sender: Any) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
        locationManager.startUpdatingLocation()
        }
        
//        let closest = coordinates.min(by:
//        { $0.distance(from: userLocation) < $1.distance(from: userLocation) })
       
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
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(location: storeLocation)

    }
    
   
}
