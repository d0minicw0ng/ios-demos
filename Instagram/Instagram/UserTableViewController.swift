//
//  UserTableViewController.swift
//  Instagram
//
//  Created by Dominic Wong on 22/1/15.
//  Copyright (c) 2015 Dominic Wong. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    var users = [String]()
    var following = [Bool]()
    
    var refresher: UIRefreshControl!
    
    func loadUsers() {
        var query = PFUser.query()
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
            
            self.users.removeAll(keepCapacity: true)
            for object in objects {
                var user:PFUser = object as PFUser
                var isFollowing:Bool = false
                
                if PFUser.currentUser() != nil && user.username != PFUser.currentUser().username {
                    self.users.append(user.username)
                    var query = PFQuery(className: "Followers")
                    query.whereKey("follower", equalTo: PFUser.currentUser().username)
                    query.whereKey("following", equalTo: user.username)
                    query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
                        if error == nil {
                            for object in objects {
                                isFollowing = true
                                break
                            }
                            self.following.append(isFollowing)
                            // NOTE: This is a shady way to reload data because it reloads the data for each user. It does solve the problem, though. For the sake of this sample app, I am just going to leave it here.
                            self.tableView.reloadData()
                        } else {
                            println(error)
                        }
                        self.refresher.endRefreshing()
                    })
                }
            }
        })
    }
    
    func refresh() {
        loadUsers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsers()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to find new users!")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        if following.count > indexPath.row && following[indexPath.row] == true {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }

        cell.textLabel?.text = users[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell:UITableViewCell = self.tableView.cellForRowAtIndexPath(indexPath)!
        if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
            cell.accessoryType = UITableViewCellAccessoryType.None
            // NOTE: class name should really be Follower...
            var query = PFQuery(className: "Followers")
            query.whereKey("follower", equalTo: PFUser.currentUser().username)
            query.whereKey("following", equalTo: cell.textLabel?.text)
            // NOTE: In reality it should only return one object,
            // but I am not going to work on the database constraints
            // in this app.
            query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
                
                if error == nil {
                    for object in objects {
                        object.delete()
                    }
                } else {
                    println(error)
                }
            })
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            var following = PFObject(className: "Followers")
            // NOTE: In reality, I would never use the username as
            // the foreign key (This is so not safe!). But for the
            // case of this sample app, I am going to use it because
            // I don't plan to make username modifiable.
            following["following"] = cell.textLabel?.text
            following["follower"] = PFUser.currentUser().username
            following.save()
        }
    }
}
