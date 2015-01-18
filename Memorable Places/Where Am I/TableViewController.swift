//
//  TableViewController.swift
//  Where Am I
//
//  Created by Dominic Wong on 18/1/15.
//  Copyright (c) 2015 Dominic Wong. All rights reserved.
//

import UIKit

var activePlace = 0
var places:[Dictionary<String, String>] = [
    ["name": "Taj Mahal", "lat": "27.175349", "lon": "78.042176"]
]

class TableViewController: UITableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = places[indexPath.row]["name"]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        activePlace = indexPath.row
        self.performSegueWithIdentifier("findPlace", sender: indexPath)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addPlace" {
            activePlace = -1
        }
    }
}
