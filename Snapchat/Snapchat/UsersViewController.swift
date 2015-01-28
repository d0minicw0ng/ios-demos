//
//  UsersViewController.swift
//  Snapchat
//
//  Created by Dominic Wong on 28/1/15.
//  Copyright (c) 2015 Dominic Wong. All rights reserved.
//

import UIKit

class UsersViewController: UITableViewController {
    var users = [String]()
    
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
}

