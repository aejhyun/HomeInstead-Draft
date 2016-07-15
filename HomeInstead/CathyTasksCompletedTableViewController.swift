//
//  CathyCompletedTasksTableViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 5/11/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class CathyTasksCompletedTableViewController: UITableViewController {
    
    var careGiverNameTapped: Bool = false
    var clientNameTapped: Bool = false
    
    var dates: [String] = [String]()
    var startedTimes: [String] = [String]()
    var finishedTimes: [String] = [String]()
    var clientNames: [String] = [String]()
    var careGiverNames: [String] = [String]()
    var careGiverObjectIds: [String] = [String]()
    var clientObjectIds: [String] = [String]()
    var taskInformationObjectIds: [String] = [String]()
    
    var clientNameIndexPath: NSIndexPath? = nil
    var careGiverNameIndexPath: NSIndexPath? = nil

    func attemptQueryingTaskInformation(queryFromLocalDateStore localQuery: Bool, completion: (querySuccessful: Bool) -> Void) {
        
        var date: String = ""
        var startedTime: String = ""
        var finishedTime: String = ""
        var clientName: String = ""
        var careGiverName: String = ""
        var careGiverObjectId: String = ""
        var clientObjectId: String = ""
        var taskInformationObjectId: String = ""
        
        let query = PFQuery(className: "TaskInformation")
        query.whereKey("cathyUserIds", containedIn: [(PFUser.currentUser()?.objectId)!])
        if localQuery{
            query.fromLocalDatastore()
        }
        query.whereKey("sentToCathys", equalTo: true)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
    
                self.dates.removeAll()
                self.startedTimes.removeAll()
                self.finishedTimes.removeAll()
                self.clientNames.removeAll()
                self.clientObjectIds.removeAll()
                self.careGiverNames.removeAll()
                self.careGiverObjectIds.removeAll()
                self.taskInformationObjectIds.removeAll()
                
                if let objects = objects {
                    for object in objects {
                        date = object.objectForKey("date") as! String
                        startedTime = object.objectForKey("startedTime") as! String
                        finishedTime = object.objectForKey("finishedTime") as! String
                        clientName = object.objectForKey("clientName") as! String
                        clientObjectId = object.objectForKey("clientObjectId") as! String
                        careGiverName = object.objectForKey("careGiverName") as! String
                        careGiverObjectId = object.objectForKey("careGiverObjectId") as! String
                        taskInformationObjectId = object.objectId!
                        
                        self.dates.append(date)
                        self.startedTimes.append(startedTime)
                        self.finishedTimes.append(finishedTime)
                        self.clientNames.append(clientName)
                        self.clientObjectIds.append(clientObjectId)
                        self.careGiverNames.append(careGiverName)
                        self.careGiverObjectIds.append(careGiverObjectId)
                        self.taskInformationObjectIds.append(taskInformationObjectId)
                        object.pinInBackground()

                    }
                    completion(querySuccessful: true)
                }
            } else {
                print(error?.description)
                completion(querySuccessful: false)
            }
        }
        
    }
    
    func setTabBarTopBorderLine() {
        
        let viewFrame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 1.0)
        let tabBarTopHairLine: UIView = UIView(frame: viewFrame)
        tabBarTopHairLine.backgroundColor = UIColor.lightGrayColor()
        
        self.tabBarController!.tabBar.addSubview(tabBarTopHairLine)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTabBarTopBorderLine()
        
        self.navigationItem.title = "Completed Tasks"
        
        self.attemptQueryingTaskInformation(queryFromLocalDateStore: false) { (querySuccessful) -> Void in
            if querySuccessful {
                self.tableView.reloadData()
            }
        }
        
  
    }
    
    @IBAction func careGiverNameButtonTapped(sender: AnyObject) {
        
        let careGiverNameButton = sender as! UIButton
        let superView = careGiverNameButton.superview!
        let cathyTaskInformationTableViewCell = superView.superview as! CathyTasksCompletedTableViewCell
        let indexPath = self.tableView.indexPathForCell(cathyTaskInformationTableViewCell)
        self.careGiverNameIndexPath = indexPath
        
        self.careGiverNameTapped = true
        self.performSegueWithIdentifier("cathyTaskCompletedToUserProfile", sender: self.careGiverObjectIds[sender.tag])
        
    }
    
    
    @IBAction func clientNameButtonTapped(sender: AnyObject) {
        
        let clientNameButton = sender as! UIButton
        let superView = clientNameButton.superview!
        let cathyTaskInformationTableViewCell = superView.superview as! CathyTasksCompletedTableViewCell
        let indexPath = self.tableView.indexPathForCell(cathyTaskInformationTableViewCell)
        self.clientNameIndexPath = indexPath
        
        self.clientNameTapped = true
        self.performSegueWithIdentifier("cathyTaskCompletedToUserProfile", sender: self.clientObjectIds[sender.tag])
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("cathyTasksCompletedToCathyTaskInformation", sender: indexPath)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dates.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CathyTasksCompletedTableViewCell
        
        cell.dateLabel.text = self.dates[indexPath.row]
        cell.startedTimeLabel.text = self.startedTimes[indexPath.row]
        cell.finishedTimeLabel.text = self.finishedTimes[indexPath.row]
        cell.careGiverNameButton.setTitle(self.careGiverNames[indexPath.row], forState: .Normal)
        cell.careGiverNameButton.tag = indexPath.row
        cell.clientNameButton.setTitle(self.clientNames[indexPath.row], forState: .Normal)
        cell.clientNameButton.tag = indexPath.row
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "cathyTasksCompletedToCathyTaskInformation" {
            if let cathyTaskInformationTableViewController = segue.destinationViewController as? CathyTaskInformationTableViewController {
                
                cathyTaskInformationTableViewController.taskInformationObjectId = self.taskInformationObjectIds[sender!.row]
                
                
            } else {
                print("destinationViewController returned nil")
            }
        } else if segue.identifier == "cathyTaskCompletedToUserProfile" {
            if let userProfileViewController = segue.destinationViewController as? UserProfileViewController {
                
                if self.careGiverNameTapped {
                    userProfileViewController.selectedUserType = UserType.careGiver
                    self.careGiverNameTapped = false
                    userProfileViewController.userObjectId = self.careGiverObjectIds[self.careGiverNameIndexPath!.row]
                } else if self.clientNameTapped {
                    userProfileViewController.selectedUserType = UserType.client
                    self.clientNameTapped = false
                    userProfileViewController.userObjectId = self.clientObjectIds[self.clientNameIndexPath!.row]
                }
                
            } else {
                print("destinationViewController returned nil")
            }
        }
    }

    @IBAction func signOutButtonTapped(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
            if let error = error {
                print(error)
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }
        }
    }

}
