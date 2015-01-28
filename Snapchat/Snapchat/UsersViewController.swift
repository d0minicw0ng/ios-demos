//
//  UsersViewController.swift
//  Snapchat
//
//  Created by Dominic Wong on 28/1/15.
//  Copyright (c) 2015 Dominic Wong. All rights reserved.
//

import UIKit

class UsersViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var users = [String]()
    var recipient = -1
    var timer = NSTimer()
    let SNAPTAG = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var query = PFUser.query()
        query.whereKey("username", notEqualTo: PFUser.currentUser().username)
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
            for object in objects {
                self.users.append(object.username)
            }
            self.tableView.reloadData()
        })
        
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("checkForSnaps"), userInfo: nil, repeats: true)
    }
    
    func checkForSnaps() {
        var query = PFQuery(className: "Snap")
        if PFUser.currentUser() != nil {
            query.whereKey("recipient", equalTo: PFUser.currentUser().username)
            query.findObjectsInBackgroundWithBlock { (snaps: [AnyObject]!, error: NSError!) -> Void in
                for snap in snaps {
                    var snapView:PFImageView = PFImageView()
                    snapView.file = snap["image"] as PFFile
                    snapView.loadInBackground({ (photo, error) -> Void in
                        
                        if error == nil {
                            var senderUsername = snap["sender"] as String
                            var alert = UIAlertController(title: "New Snap from \(senderUsername)!", message: "Tap below to view!", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                                
                                var backgroundView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                                backgroundView.backgroundColor = UIColor.blackColor()
                                backgroundView.alpha = 0.8
                                backgroundView.tag = self.SNAPTAG
                                self.view.addSubview(backgroundView)
                                
                                var displayedImage = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
                                displayedImage.image = photo
                                displayedImage.contentMode = .ScaleAspectFit
                                displayedImage.tag = self.SNAPTAG
                                self.view.addSubview(displayedImage)
                                
                                self.timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("removeSnap"), userInfo: nil, repeats: false)
                                
                                snap.delete()                                
                            }))
                            
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    })
                }
            }
        }
    }
    
    func removeSnap() {
        for subview in self.view.subviews {
            if subview.tag == SNAPTAG {
                subview.removeFromSuperview()
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("user") as UITableViewCell
        cell.textLabel?.text = self.users[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.recipient = indexPath.row
        pickImage()
    }
    
    func pickImage() {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        var snap = PFObject(className: "Snap")
        snap["image"] = PFFile(name: "image.jpg", data: UIImageJPEGRepresentation(image, 0.5))
        snap["sender"] = PFUser.currentUser().username
        snap["recipient"] = self.users[self.recipient]
        snap.save()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "signedOut" {
            PFUser.logOut()
        }
    }
}

