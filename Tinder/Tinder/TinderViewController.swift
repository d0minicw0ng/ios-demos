//
//  TinderViewController.swift
//  Tinder
//
//  Created by Dominic Wong on 25/1/15.
//  Copyright (c) 2015 Dominic Wong. All rights reserved.
//

import UIKit

class TinderViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geopoint: PFGeoPoint!, error: NSError!) -> Void in
            if error == nil {
                var currentUser = PFUser.currentUser()
                currentUser["location"] = geopoint
                currentUser.save()
            }
        }
        
        var i = 10
        
        func addPerson(urlString: String) {
            var newUser = PFUser()
            let url = NSURL(string: urlString)
            let urlRequest = NSURLRequest(URL: url!)
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
                response, data, error in

                newUser["image"] = data
                newUser["gender"] = "female"
                
                var lat = Double(37 + i)
                var lon = Double(-122 + i)
                var location = PFGeoPoint(latitude: lat, longitude: lon)
                i = i + 10
                
                newUser["location"] = location
                newUser.username = "Girl Bot \(i)"
                newUser.password = "password"
                newUser.signUp()
            })
        }
        
        addPerson("http://s3.amazonaws.com/readers/2010/12/07/3186885154021fda16b1_1.jpg")
        addPerson("http://www.polyvore.com/cgi/img-thing?.out=jpg&size=l&tid=44643840")
        addPerson("http://i263.photobucket.com/albums/ii139/whatgloom/janejetson.jpg")
        addPerson("http://www.scrapwallpaper.com/wp-content/uploads/2014/08/female-cartoon-characters-pictures-6.jpg")
        addPerson("http://diaryofalagosmumblog.files.wordpress.com/2011/11/smurfette-scaled500.gif")
    }
}
