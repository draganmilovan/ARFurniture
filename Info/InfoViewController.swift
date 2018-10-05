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
        
        addAnnotations()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count-1]
        
        if location.horizontalAccuracy > 0 {
            
            locationManager.stopUpdatingLocation()
            closestDestination()
            
        }
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
        
        
    }
    func closestDestination (){
        
        let storeCoordinates = infoDataManager.items.map{$0.coordinates}
        
        let new = locationManager.location
        
        
        
        let loc = storeCoordinates.map{CLLocation(latitude: $0.lat, longitude: $0.long)}
        
        
        
        let closest = loc.min(by:
        { $0.distance(from: new! ) < $1.distance(from:new!) })
        print(closest)
        
        let storeLocation = closest
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(location: storeLocation!)
        
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
        
        
        //center map
        let storeLocation = CLLocation(latitude: infoDataManager.items[indexPath.row].coordinates.lat , longitude: infoDataManager.items[indexPath.row].coordinates.long)
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        centerMapOnLocation(location: storeLocation)
        
    }
    
    
    
    
    func addAnnotations(){
        let storeCoordinates = infoDataManager.items.map{$0.coordinates}
        let coords = storeCoordinates.map{CLLocation(latitude: $0.lat, longitude: $0.long)}
        for coord in coords{
            let CLLCoordType = CLLocationCoordinate2D(latitude: coord.coordinate.latitude,
                                                      longitude: coord.coordinate.longitude);
            let anno = MKPointAnnotation()
            anno.coordinate = CLLCoordType
            mapView.addAnnotation(anno)
        }
        let regionRadius: CLLocationDistance = 500000
        let locMap = CLLocationCoordinate2D(latitude: 44.809909, longitude: 20.433341)
        let coordinateRegion = MKCoordinateRegion(center: locMap , latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: false)
        
    }
    
    
    
    
    
}

