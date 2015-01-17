//
//  ViewController.swift
//  Where Am I
//
//  Created by Dominic Wong on 17/1/15.
//  Copyright (c) 2015 Dominic Wong. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var manager:CLLocationManager!

    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var altitude: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var course: UILabel!
    @IBOutlet weak var nearestAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        
        manager.startUpdatingLocation()
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        var userLocation:CLLocation = locations[0] as CLLocation
        
        latitude.text = "\(userLocation.coordinate.latitude)"
        longitude.text = "\(userLocation.coordinate.longitude)"
        course.text = "\(userLocation.course)"
        speed.text = "\(userLocation.speed)"
        altitude.text = "\(userLocation.altitude)"
        
        var geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation, completionHandler: {(placemarks, error) in
            if error != nil {
                println("Error \(error)")
            } else {
                let p = CLPlacemark(placemark: placemarks?[0] as CLPlacemark)
                
                var subThoroughfare:String
                if p.subThoroughfare != nil {
                    subThoroughfare = p.subThoroughfare
                } else {
                    subThoroughfare = ""
                }
                
                self.nearestAddress.text = "\(subThoroughfare) \(p.subLocality) \n \(p.thoroughfare) \n \(p.subAdministrativeArea) \n \(p.postalCode) \n \(p.country)"
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

