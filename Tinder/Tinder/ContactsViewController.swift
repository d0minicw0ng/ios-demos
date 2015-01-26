//
//  ContactsViewController.swift
//  Tinder
//
//  Created by Dominic Wong on 26/1/15.
//  Copyright (c) 2015 Dominic Wong. All rights reserved.
//

import UIKit

class ContactsViewController: UITableViewController {
    
    var userImages = [NSData]()
    var emails = [String]()
    var usernames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var query = PFUser.query()
        query.whereKey("accepted", equalTo: PFUser.currentUser().username)
        query.whereKey("username", containedIn: PFUser.currentUser()["accepted"] as [AnyObject])
        query.findObjectsInBackgroundWithBlock({ (matches: [AnyObject]!, error: NSError!) -> Void in
            
            if error == nil {
                for match in matches {
                    self.userImages.append(match["image"] as NSData)
                    self.emails.append(match["email"] as String)
                    self.usernames.append(match["username"] as String)
                }
                self.tableView.reloadData()
            }
        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.emails.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("contact") as UITableViewCell
        cell.textLabel?.text = usernames[indexPath.row]
        cell.imageView?.image = UIImage(data: userImages[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var url = NSURL(string: "mailto:\(self.emails[indexPath.row])?subject=Hello!")
        UIApplication.sharedApplication().openURL(url!)
    }

}
