//
//  ViewController.swift
//  Tinder
//
//  Created by Dominic Wong on 24/1/15.
//  Copyright (c) 2015 Dominic Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBAction func fbLogin(sender: AnyObject) {
        let permissions = ["email", "public_profile"]
        PFFacebookUtils.logInWithPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            
            if user == nil {
                self.showAlert("Facebook Login Failed", error: error.localizedDescription as String)
            } else if user.isNew {
                self.performSegueWithIdentifier("signUp", sender: self)
            } else {
                self.performSegueWithIdentifier("redirectToTinder", sender: self)
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier("redirectToTinder", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(title: String, error: String) {
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    


}

