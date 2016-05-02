//
//  ViewController.swift
//  BranchLocator
//
//  Created by Tim Choo on 4/25/16.
//  Copyright © 2016 Tim Choo. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private var distanceFromCurrent: CLLocationDistance = 0
    var branchArray = [MKAnnotation]()
    var jsonData: NSData?
    var branchesJson: JSON?
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadJsonFromFile()
        
        locationManager.delegate = self
        locationManager.distanceFilter = 500
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        
        /*
        var annotation1 = MKPointAnnotation()
       annotation1.coordinate = CLLocationCoordinate2D(latitude: 28.61394, longitude: 77.20902)
        annotation1.title = "JKE Main Office"
        annotation1.subtitle = "Full Service Branch"
        branchArray.append(annotation1)
        
        var annotation2 = MKPointAnnotation()
        annotation2.coordinate = CLLocationCoordinate2D(latitude: 28.60488, longitude: 77.22305)
        annotation2.title = "Little Street Branch"
        annotation2.subtitle = "Tellers, ATMs, Financial Advisors"
        branchArray.append(annotation2)
        
        var annotation3 = MKPointAnnotation()
        annotation3.coordinate = CLLocationCoordinate2D(latitude: 28.54864, longitude: 77.25138)
        annotation3.title = "Cool Mall Branch"
        annotation3.subtitle = "ATM only"
        branchArray.append(annotation3)
        */
        
        //let span = MKCoordinateSpanMake(0.2, 0.2)
        //let region = MKCoordinateRegionMake(location, span)
        
       
    }
    
    override func viewDidLayoutSubviews() {
        mapView.showAnnotations(branchArray, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("Authorization Status changed to:")
        switch status {
        case .Authorized, .AuthorizedWhenInUse:
            print("Authorized")
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        default:
            print("Not Authorized")
            locationManager.stopUpdatingHeading()
            mapView.showsUserLocation = false
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("An error occured with location: \(error.code)")
        /*
        let alertController = UIAlertController(title: "Error", message: "An error occured getting the location", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Cancel, handler: { action in })
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
        */
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let currentLocation = (locations as [CLLocation])[locations.count-1]
        /*
        let startPlace = place(title: "Home", subtitle: "Home Sweet Home", coordinate: newLocation.coordinate)
        mapView.addAnnotation(startPlace)
        let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 100, 100)
        mapView.setRegion(region, animated: true) 
        */
        
        var branchLocation = CLLocation()
        var lat: Double = 0.0
        var long: Double = 0.0
        var annotation: MKPointAnnotation
        
        for branch in (branchesJson!["branches"].arrayValue) {
            lat = Double(branch["Latitude"].numberValue)
            long = Double(branch["Longitude"].numberValue)
            print("Latitude: \(lat), Longitude: \(long)")
            branchLocation = CLLocation(latitude: lat, longitude: long)
            print("Distance: \(currentLocation.distanceFromLocation(branchLocation))")
            if currentLocation.distanceFromLocation(branchLocation) < 50000 {
                annotation = MKPointAnnotation()
                annotation.title = branch["Title"].stringValue
                annotation.subtitle = branch["Subtitle"].stringValue
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                branchArray.append(annotation)
            }
        }
        mapView.showAnnotations(branchArray, animated: true)
        
    }
    
    func loadJsonFromFile() {
        // ---- Grab the demo test JSON file from the file system
        let jsonFilePath:NSString = NSBundle.mainBundle().pathForResource("JKEBranches", ofType: "json")!
        jsonData = NSData(contentsOfFile: String(jsonFilePath))
        branchesJson = JSON(data: jsonData!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

