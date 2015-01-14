//
//  ViewController.swift
//  Weather
//
//  Created by Dominic Wong on 14/1/15.
//  Copyright (c) 2015 Dominic Wong. All rights reserved.
//

import UIKit

//NOTE: This is for educational purposes, hence I am not using an API in JSON format. Do not judge
//me for scraping things off a website.

class ViewController: UIViewController {
    @IBOutlet weak var weatherData: UILabel!
    @IBOutlet weak var city: UITextField!
    
    @IBAction func search(sender: AnyObject) {
        self.view.endEditing(true)
        
        var urlString = "http://www.weather-forecast.com/locations/" + city.text.stringByReplacingOccurrencesOfString(" ", withString: "") + "/forecasts/latest"
        
        var url = NSURL(string: urlString)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data,response, error) in
            var urlContent = NSString(data: data, encoding: NSUTF8StringEncoding)

            if urlContent!.containsString("<span class=\"phrase\">") {
                var contentArray = urlContent!.componentsSeparatedByString("<span class=\"phrase\">")
                var newContentArray = contentArray[1].componentsSeparatedByString("</span>")
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.weatherData.text = newContentArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "°") as NSString
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.weatherData.text = "The city you tried to find does not exist!"
                }
            }
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

