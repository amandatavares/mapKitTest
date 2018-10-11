//
//  ViewController.swift
//  mapKitLesson
//
//  Created by Amanda Tavares on 10/10/18.
//  Copyright © 2018 Amanda Tavares. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    var locatManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locatManager.delegate = self
        mapView.delegate = self
        //showMap()
        realTimeUserLocation()
        //mapMarkPoint()
       
    }

}

extension ViewController {
    // MARK : - Functions
    // Question 01 - Create region: we need coordinates and zoom (span)
    func showMap() -> CLLocationCoordinate2D {
        let latitude: CLLocationDegrees = -3.743993
        let longitude: CLLocationDegrees = -38.535674
        let centerCoordinate1 = CLLocationCoordinate2DMake(latitude, longitude)
        // span - the less you put, greater zoom
        let span1 = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region1 = MKCoordinateRegion(center: centerCoordinate1, span: span1)
        mapView.setRegion(region1, animated: true)
        return centerCoordinate1
    }
    func updateLocal(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let centerCoordinate2 = CLLocationCoordinate2DMake(latitude, longitude)
        // span - the less you put, greater zoom
        let span2 = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region2 = MKCoordinateRegion(center: centerCoordinate2, span: span2)
        mapView.setRegion(region2, animated: true)
    }
    // Question 03 - get realtime user location
    func realTimeUserLocation() {
        locatManager.desiredAccuracy = kCLLocationAccuracyBest
        locatManager.requestWhenInUseAuthorization()
        locatManager.startUpdatingLocation()
    }
    // Question 06 - add a pointer mark in map
    func mapMarkPoint(coordinate: CLLocationCoordinate2D) {
        let coordinate = coordinate
        let ifcePoint = MKPointAnnotation()
        ifcePoint.coordinate = coordinate
        ifcePoint.title = "IFCE"
        ifcePoint.subtitle = "Apple Developer Academy"
        mapView.addAnnotation(ifcePoint)
    }
    
    // Additional - get user-friendly place name
    // A closure is said to escape a function when the closure is passed as an argument to the function, but is called after the function returns.
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
        -> Void ) {
        if let lastLocation = self.locatManager.location {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
                if error == nil {
                    let placeArray = placemarks as! [CLPlacemark]!
                    var placemark: CLPlacemark!
                    placemark = placeArray![0]
                    
                    //let firstLocation = placemarks?[0]
                    completionHandler(placemark)
                }
                else {
                    completionHandler(nil)
                }
            })
            
        }
        else {
            // No location available
            completionHandler(nil)
        }
    }
    
    // MARK : - CLLocationDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print(locations)
        let currentLocation = locations.last!
        let x: CLLocationDegrees = currentLocation.coordinate.latitude
        let y: CLLocationDegrees = currentLocation.coordinate.longitude
//        mapMarkPoint(coordinate: currentLocation.coordinate)
        updateLocal(latitude: x, longitude: y)
        lookUpCurrentLocation(completionHandler: { (placemark) in
//            if let areas = placemark?.areasOfInterest {
//                for area in areas {
//                    self.addressLabel.text = "\(area) \n"
//                    print(areas)
//                }
//            } else {
//                print("Found nil")
//                return
//            }
            self.addressLabel.text = (placemark?.name)
            self.cityLabel.text = (placemark?.administrativeArea)
            self.countryLabel.text = (placemark?.country)
            //print(placemark?.areasOfInterest)
        })
    }
    
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        let annotationID = "annotID"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotID")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationID)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        let pinImage = UIImage(named: "ifce")
        annotationView?.image = pinImage
        return annotationView
    }
}
