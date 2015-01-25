//
//  SignUpViewController.swift
//  Tinder
//
//  Created by Dominic Wong on 25/1/15.
//  Copyright (c) 2015 Dominic Wong. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var fbProfileImage: UIImageView!
    @IBOutlet weak var interestedIn: UISwitch!
    @IBAction func signUp(sender: AnyObject) {
        var interestedInGender:String
        if interestedIn.on {
            interestedInGender = "female"
        } else {
            interestedInGender = "male"
        }
        var currentUser = PFUser.currentUser()
        currentUser["interestedIn"] = interestedInGender
        currentUser.save()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var currentUser = PFUser.currentUser()
        
        let FBSession = PFFacebookUtils.session()
        let accessToken = FBSession.accessTokenData.accessToken
        let url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token=" + accessToken)
        let urlRequest = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
            (response, data, error) in
            
            let userPhoto = UIImage(data: data)
            self.fbProfileImage.image = userPhoto
            currentUser["image"] = data
            currentUser.save()
            FBRequestConnection.startForMeWithCompletionHandler({
                connection, result, error in
                
                currentUser["gender"] = result["gender"]
                currentUser["name"] = result["name"]
                currentUser.save()
            })
        })
    }
}
