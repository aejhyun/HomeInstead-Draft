//
//  CathyTaskLogTableViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 12/24/15.
//  Copyright © 2015 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class CathyTaskLogTableViewController: UITableViewController {
    
    var tasks = [String]()
    var dates = [String]()
    var times = [String]()
    var addresses = [String]()
    var messages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFQuery(className:"TaskInformation")
        query.whereKey("cathyId", equalTo: (PFUser.currentUser()?.objectId)!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        self.tasks.append(object.objectForKey("task") as! String)
                        self.dates.append(object.objectForKey("date") as! String)
                        self.times.append(object.objectForKey("time") as! String)
                        self.addresses.append(object.objectForKey("address") as! String)
                        self.messages.append(object.objectForKey("message") as! String)
                    }
                    self.tasks = self.tasks.reverse()
                    self.dates = self.dates.reverse()
                    self.times = self.times.reverse()
                    self.addresses = self.addresses.reverse()
                    self.messages = self.messages.reverse()
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CathyTaskLogTableViewCell
        
        cell.taskLabel.text = tasks[indexPath.row]
        cell.dateLabel.text = dates[indexPath.row]
        cell.timeLabel.text = times[indexPath.row]
        cell.locationLabel.text = addresses[indexPath.row]
        
        cell.messageButton.hidden = true
        
        if messages[indexPath.row] != "" {
            cell.messageButton.hidden = false
        }
        
        return cell
    }

    @IBAction func signOutButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        PFUser.logOut()
    }

}
