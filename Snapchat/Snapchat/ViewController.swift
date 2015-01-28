//
//  ViewController.swift
//  Snapchat
//
//  Created by Dominic Wong on 28/1/15.
//  Copyright (c) 2015 Dominic Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBAction func signIn(sender: AnyObject) {
        if username.text != "" {
            PFUser.logInWithUsernameInBackground(username.text, password: "password", block: { (user: PFUser!, error: NSError!) -> Void in
                
                if error == nil {
                    self.performSegueWithIdentifier("signedIn", sender: self)
                } else {
                    println("no user found")
                    var newUser = PFUser()
                    newUser.username = self.username.text
                    newUser.password = "password"
                    newUser.signUpInBackgroundWithBlock { (succeeded: Bool!, error: NSError!) -> Void in
                        println("signed user up")
                        
                        if error == nil {
                            self.performSegueWithIdentifier("signedIn", sender: self)
                        } else {
                            // show error
                            println("\(error)")
                        }
                    }
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier("signedIn", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

