//
//  feedViewController.swift
//  Instagram
//
//  Created by Dominic Wong on 24/1/15.
//  Copyright (c) 2015 Dominic Wong. All rights reserved.
//

import UIKit

class feedViewController: UITableViewController {
    var photoDescriptions = [String]()
    var usernames = [String]()
    var photos = [UIImage]()
    var photoFiles = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var getFollowedUsersQuery = PFQuery(className: "Followers")
        getFollowedUsersQuery.whereKey("follower", equalTo: PFUser.currentUser().username)
        getFollowedUsersQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if error == nil {
                var followedUser:String
                for object in objects {
                    var followedUser = object["following"] as String
                    
                    var postQuery = PFQuery(className: "Post")
                    postQuery.whereKey("username", equalTo: followedUser)
                    postQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
                        
                        if error == nil {
                            for object in objects {
                                self.photoDescriptions.append(object["title"] as String)
                                self.usernames.append(object["username"] as String)
                                self.photoFiles.append(object["photo_file"] as PFFile)
                            }
                            self.tableView.reloadData()
                        }
                    })
                }
            }
        })
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photoDescriptions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:FeedItem = self.tableView.dequeueReusableCellWithIdentifier("feedItem") as FeedItem
        cell.photoDescription.text = self.photoDescriptions[indexPath.row]
        cell.username.text = self.usernames[indexPath.row]
        self.photoFiles[indexPath.row].getDataInBackgroundWithBlock({ (photoData: NSData!, error: NSError!) -> Void in
            
            if error == nil {
                let photo = UIImage(data: photoData)
                cell.photo.image = photo
            }
        })
        
        cell.sizeToFit()
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 230
    }
}
