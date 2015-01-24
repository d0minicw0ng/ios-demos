//
//  postPhotoViewController.swift
//  Instagram
//
//  Created by Dominic Wong on 24/1/15.
//  Copyright (c) 2015 Dominic Wong. All rights reserved.
//

import UIKit

class postPhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var photoSelected:Bool = false
    var activityIndicator:UIActivityIndicatorView!
    @IBOutlet weak var selectedPhoto: UIImageView!

    @IBAction func choosePhoto(sender: AnyObject) {
        var photo = UIImagePickerController()
        photo.delegate = self
        photo.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        photo.allowsEditing = true
        self.presentViewController(photo, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        selectedPhoto.image = image
        photoSelected = true
    }
    @IBOutlet weak var photoDescription: UITextField!
    @IBAction func postPhoto(sender: AnyObject) {
        var error = ""
        
        if photoSelected == false {
            error = "Please select a photo."
        } else if photoDescription.text == "" {
            error = "Please enter some #hashtags, don't be boring."
        }
        
        if error != "" {
            showAlert(error)
        } else {
            showActivityIndicator()
            var post = PFObject(className: "Post")
            post["title"] = photoDescription.text
            post["username"] = PFUser.currentUser().username
            post.saveInBackgroundWithBlock({(success: Bool!, error: NSError!) -> Void in
                if success == false {
                    self.stopActivityIndicator()
                    self.showAlert("Please try again later.")
                } else {
                    let photoData = UIImagePNGRepresentation(self.selectedPhoto.image)
                    let photoFile = PFFile(name: "photo", data: photoData)
                    post["photo_file"] = photoFile
                    post.saveInBackgroundWithBlock({(success: Bool!, error: NSError!) -> Void in
                        if success == false {
                            self.stopActivityIndicator()
                        } else {
                            // TODO: refactor later.
                            var alert = UIAlertController(title: "Photo posted", message: "Your photo has been posted successfully", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }))
                            self.presentViewController(alert, animated: true, completion: nil)
                            
                            self.photoSelected = false
                            self.selectedPhoto.image = UIImage(named: "camera_placeholder.png")
                            self.photoDescription.text = ""
                        }
                        
                        self.stopActivityIndicator()
                    })
                }
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showAlert(error: String) {
        var alert = UIAlertController(title: "Photo cannot be posted", message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
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
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    @IBAction func logOut(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logOut", sender: self)
        
    }
}
