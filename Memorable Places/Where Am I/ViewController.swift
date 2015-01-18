//
//  ViewController.swift
//  Where Am I
//
//  Created by Dominic Wong on 17/1/15.
//  Copyright (c) 2015 Dominic Wong. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var myMap: MKMapView!
    
    var manager:CLLocationManager!
    
    @IBAction func findMe(sender: AnyObject) {
        startUpdatingLocation()
    }
    
    func startUpdatingLocation() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func _createAnnotation(coordinate: CLLocationCoordinate2D, title: String){
        var annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        myMap.addAnnotation(annotation)
    }
    
    func _setRegion(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        var latDelta:CLLocationDegrees = 0.01
        var lonDelta:CLLocationDegrees = 0.01
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        myMap.setRegion(region, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        if activePlace == -1 {
            startUpdatingLocation()
        } else {
            let lat = NSString(string: places[activePlace]["lat"]!).doubleValue
            let lon = NSString(string: places[activePlace]["lon"]!).doubleValue
            var latitude:CLLocationDegrees = lat
            var longitude:CLLocationDegrees = lon
            _setRegion(latitude, longitude: longitude)
            var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            _createAnnotation(location, title: places[activePlace]["name"]!)
        }
        
        var uilpgr = UILongPressGestureRecognizer(target: self, action: "addAnnotationToMap:")
        uilpgr.minimumPressDuration = 1.0
        myMap.addGestureRecognizer(uilpgr)
    }
    
    func addAnnotationToMap(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            let touchPoint = gestureRecognizer.locationInView(self.myMap)
            let newCoordinate = myMap.convertPoint(touchPoint, toCoordinateFromView: self.myMap)

            var geocoder = CLGeocoder()
            var loc = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            geocoder.reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
                if error != nil {
                    println("Error \(error)")
                } else {
                    let p = CLPlacemark(placemark: placemarks?[0] as CLPlacemark)
                    var subThoroughfare = p.subThoroughfare != nil ? p.subThoroughfare : ""
                    var thoroughfare = p.thoroughfare != nil ? p.thoroughfare : ""
                    
                    var title = "\(subThoroughfare) \(thoroughfare)"
                    if title == " " {
                        title = "Added on \(NSDate.init())"
                    }

                    self._createAnnotation(newCoordinate, title: title)
                    places.append([
                        "name": title,
                        "lat": "\(newCoordinate.latitude)",
                        "lon": "\(newCoordinate.longitude)"
                    ])
                }
            })
        }
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        var userLocation:CLLocation = locations[0] as CLLocation
        var latitude:CLLocationDegrees = userLocation.coordinate.latitude
        var longitude:CLLocationDegrees = userLocation.coordinate.longitude
        _setRegion(latitude, longitude: longitude)
        manager.stopUpdatingLocation()

    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
}

