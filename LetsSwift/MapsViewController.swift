//
//  SecondViewController.swift
//  LetsSwift
//
//  Created by Thomas Baltodano on 4/19/17.
//  Copyright © 2017 Thomas Baltodano. All rights reserved.
//

import UIKit

import MapKit


class MapsViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var places = Places()
    
    let locationManager = CLLocationManager()
    
    var userLocation:CLLocationCoordinate2D!
    

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
        
        
        // Set gesture recognizer to add a pin on touch
        
        // Double tap
//        let singleTap = UITapGestureRecognizer(target: self, action:#selector(MapsViewController.handleSingleTap(gestureReconizer:)))
//        singleTap.numberOfTapsRequired = 1
//        singleTap.delegate = self
//        mapView.addGestureRecognizer(singleTap)
//        
//        let doubleTap = UITapGestureRecognizer(target: self, action:#selector(MapsViewController.handleTap(gestureReconizer:)))
//        doubleTap.numberOfTapsRequired = 2
//        doubleTap.delegate = self
//        mapView.addGestureRecognizer(doubleTap)
//        
//        singleTap.require(toFail: doubleTap)
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action:#selector(MapsViewController.handleTap(gestureReconizer:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    
    // Add a pin where the touch happened
    func handleSingleTap(gestureReconizer: UILongPressGestureRecognizer) {
    
    }
    
    // Add a pin where the touch happened
    func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
        
        if (gestureReconizer.state == UIGestureRecognizerState.began) {
            let location = gestureReconizer.location(in: mapView)
            let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
            // Add annotation:
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            annotation.title = "User location"
            annotation.subtitle = "\(coordinate.latitude),\(coordinate.longitude)"
            mapView.addAnnotation(annotation)
        }
    }
    
    
    
    
    func updateUI() {
        
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
            
            
            let showRoute = UIAlertAction(title: "Show route", style: .default) { action -> Void in
                
                self.showRoute(destinationLocation: self.selectedAnnotation.coordinate)
            }
            let showWaze = UIAlertAction(title: "Waze", style: .default) { action -> Void in
                
                let wazeHooks = "waze://?ll=\(self.selectedAnnotation.subtitle!))&navigate=yes"
                
                let wazeUrl = NSURL(string: wazeHooks)!
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(wazeUrl as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(wazeUrl as URL)
                }
                
                
            }
            let showGoogle = UIAlertAction(title: "Google Maps", style: .default) { (alert : UIAlertAction!) in
                
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
            optionMenu.addAction(showRoute)
            optionMenu.addAction(showWaze)
            optionMenu.addAction(showGoogle)
            optionMenu.addAction(cancelAction)
            self.present(optionMenu, animated: true, completion: nil)
            
            
        }
    }
    
    
    // Show a route between 2 points
    
    func showRoute (destinationLocation: CLLocationCoordinate2D) {
        //let sourceLocation = CLLocationCoordinate2D(latitude: 40.759011, longitude: -73.984472)
        //let destinationLocation = CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985564)
        
        // 3.
        let sourcePlacemark = MKPlacemark(coordinate: userLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // 4.
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

// 
//        // 5.
//        let sourceAnnotation = MKPointAnnotation()
//        sourceAnnotation.title = "Times Square"
//        
//        if let location = sourcePlacemark.location {
//            sourceAnnotation.coordinate = location.coordinate
//        }
//        
//        
//        let destinationAnnotation = MKPointAnnotation()
//        destinationAnnotation.title = "Empire State Building"
//        
//        if let location = destinationPlacemark.location {
//            destinationAnnotation.coordinate = location.coordinate
//        }
//        
//        // 6.
//        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
//        
        // 7.
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 8.
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    
                    let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    
    
    
    // Set user location
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        userLocation = manager.location!.coordinate
        
        print("locations = \(userLocation.latitude) \(userLocation.longitude)")
        
        
        // set initial location
        let initialLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        
        centerMapOnLocation(location: initialLocation)
        
        locationManager.stopUpdatingLocation()
        
        // Set a pin near the location
        let pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(userLocation.latitude + 0.01, userLocation.longitude + 0.01)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = "Place near me"
        objectAnnotation.subtitle = "\(userLocation.latitude + 0.01),\(userLocation.longitude + 0.01)"
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

