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
        let permissions = ["public_profile"]
        PFFacebookUtils.logInWithPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                NSLog("Uh oh. The user cancelled the Facebook login.")
            } else if user.isNew {
                NSLog("User signed up and logged in through Facebook!")
            } else {
                NSLog("User logged in through Facebook!")
            }
        })
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

