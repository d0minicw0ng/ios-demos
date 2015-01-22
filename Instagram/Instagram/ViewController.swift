//
//  ViewController.swift
//  Instagram
//
//  Created by Dominic Wong on 20/1/15.
//  Copyright (c) 2015 Dominic Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var signUpIsActive = true
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!

    @IBOutlet weak var alreadyRegistered: UILabel!
    @IBOutlet weak var signUpToggleButton: UIButton!
    @IBAction func toggleSignUp(sender: AnyObject) {
        if signUpIsActive == true {
            signUpIsActive = false
            _toggleSignUpText("Use the form below to log in", button: "Log In", registered: "Not registered?", toggleButton: "Sign Up")
        } else {
            signUpIsActive = true
            _toggleSignUpText("Use the form below to sign up", button: "Sign Up", registered: "Already registered?", toggleButton: "Log In")
        }
    }
    
    func _toggleSignUpText(label: String, button: String, registered: String, toggleButton: String) {
        signUpLabel.text = label
        signUpButton.setTitle(button, forState: UIControlState.Normal)
        alreadyRegistered.text = registered
        signUpToggleButton.setTitle(toggleButton, forState: UIControlState.Normal)
    }

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func signUp(sender: AnyObject) {
        var error = ""
        if username.text == "" || password.text == "" {
            error = "Please enter a username and password."
        } else if signUpIsActive == true && countElements(password.text) < 8 {
            error = "Your password must be at least 8 characters long"
        }
        
        if error != "" {
            showAlert(error)
        } else {
            var user = PFUser()
            user.username = username.text
            user.password = password.text
            
            showActivityIndicator()
            
            if signUpIsActive == true {
                _signUp(user)
            } else {
                _logIn(user)
            }
        }

    }
    
    func _logIn(user: PFUser) {
        PFUser.logInWithUsernameInBackground(user.username, password: user.password) { (loggedInUser: PFUser!, error: NSError!) -> Void in
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error != nil {
                if let errorMessage = error.userInfo?["error"] as? NSString {
                    self.showAlert(errorMessage)
                } else {
                    self.showAlert("There was an unknown error, please try again later.")
                }
            } else {
                println("Logged In.")
            }
        }
    }
    
    func _signUp(user: PFUser) {
        user.signUpInBackgroundWithBlock({ (succeeded: Bool!, error: NSError!) -> Void in
            
            self.activityIndicator.stopAnimating()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error != nil {
                if let errorMessage = error.userInfo?["error"] as? NSString {
                    self.showAlert(errorMessage)
                } else {
                    self.showAlert("There was an unknown error, please try again later.")
                }
            } else {
                println("Signed Up.")
            }
        })
    }
    
    func showActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    func showAlert(error: String) {
        var alert = UIAlertController(title: "Form Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
        self.performSegueWithIdentifier("redirectToUserTable", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

