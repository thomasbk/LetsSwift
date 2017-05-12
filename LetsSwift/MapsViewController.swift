//
//  SecondViewController.swift
//  LetsSwift
//
//  Created by Thomas Baltodano on 4/19/17.
//  Copyright © 2017 Thomas Baltodano. All rights reserved.
//

import UIKit

import MapKit


class MapsViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    
    var places = Places()
    
    let locationManager = CLLocationManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.showsUserLocation = true
        
        print("Started downloading")
        places.downloadData {
            self.updateUI()
        }
        
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    
    
    
    
    func updateUI() {
        
        print("finished downloading")
        
        // Set map region
        //            let latDelta:CLLocationDegrees = 0.01
        //            let longDelta:CLLocationDegrees = 0.01
        //            let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        //            let pointLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(place["latitude"] as! String)!, Double(place["longitude"] as! String)!)
        //            let region:MKCoordinateRegion = MKCoordinateRegionMake(pointLocation, theSpan)
        //            mapView.setRegion(region, animated: true)
        
        for place in places.placesArray {
            
            let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(place["latitude"] as! String)!, Double(place["longitude"] as! String)!)
            let objectAnnotation = MKPointAnnotation()
            objectAnnotation.coordinate = pinLocation
            objectAnnotation.title = place["name"] as? String
            objectAnnotation.subtitle = "\(place["latitude"]!),\(place["longitude"]!)"
            self.mapView.addAnnotation(objectAnnotation)
        }
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKUserLocation) {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))
            
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.tag = annotation.hash
            
            pinView.animatesDrop = true
            pinView.canShowCallout = true
            pinView.rightCalloutAccessoryView = rightButton
            
            return pinView
        }
        else {
            return nil
        }
    }
    

    
    var selectedAnnotation: MKPointAnnotation!
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            selectedAnnotation = view.annotation as? MKPointAnnotation
            //performSegueWithIdentifier("NextScene", sender: self)
            
            
            
            let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            optionMenu.popoverPresentationController?.sourceView = self.view
            
            let takePhoto = UIAlertAction(title: "Waze", style: .default) { action -> Void in
                
                let wazeHooks = "waze://?ll=\(self.selectedAnnotation.subtitle!))&navigate=yes"
                
                let wazeUrl = NSURL(string: wazeHooks)!
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(wazeUrl as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(wazeUrl as URL)
                }
                
                
            }
            let sharePhoto = UIAlertAction(title: "Google Maps", style: .default) { (alert : UIAlertAction!) in
                
                let googleHooks = "comgooglemaps://?q=\(self.selectedAnnotation.subtitle!)"
                let googleUrl = NSURL(string: googleHooks)!
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(googleUrl as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(googleUrl as URL)
                }
                
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) in
            }
            optionMenu.addAction(takePhoto)
            optionMenu.addAction(sharePhoto)
            optionMenu.addAction(cancelAction)
            self.present(optionMenu, animated: true, completion: nil)
            
            
        }
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        
        
        // set initial location
        let initialLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
        centerMapOnLocation(location: initialLocation)
        
        locationManager.stopUpdatingLocation()
        
        // Set a pin near the location
        let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(locValue.latitude + 0.01, locValue.longitude + 0.01)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = "Place near me"
        objectAnnotation.subtitle = "\(locValue.latitude + 0.01),\(locValue.longitude + 0.01)"
        self.mapView.addAnnotation(objectAnnotation)
        
    }
    
    
    
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

