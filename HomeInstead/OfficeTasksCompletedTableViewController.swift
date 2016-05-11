//
//  OfficeTaskCompletionTableViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 5/9/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class OfficeTasksCompletedTableViewController: UITableViewController {
    
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
    var lastSavedTime: [String] = [String]()
    
    var numberOfCheckedRows: Int = 0
    var numberOfRows: Int = 0
    
    var selectedRowIndexPath: NSIndexPath? = nil
    
    func setTabBarTopBorderLine() {

        let viewFrame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 1.0)
        let tabBarTopHairLine: UIView = UIView(frame: viewFrame)
        tabBarTopHairLine.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(tabBarTopHairLine)
        
        self.tabBarController!.tabBar.addSubview(tabBarTopHairLine)
        
    }
    
    func attemptQueryingTaskInformation(queryFromLocalDateStore localQuery: Bool, completion: (querySuccessful: Bool) -> Void) {

        var date: String = ""
        var startedTime: String = ""
        var finishedTime: String = ""
        var clientName: String = ""
        var careGiverName: String = ""
        var careGiverObjectId: String = ""
        var clientObjectId: String = ""
        var lastSavedTime: String = ""
        var taskInformationObjectId: String = ""
        
        let query = PFQuery(className: "TaskInformation")
        query.whereKey("officeUserIds", containedIn: [(PFUser.currentUser()?.objectId)!])
        if localQuery{
            query.fromLocalDatastore()
        }
        query.whereKey("sentToCathys", equalTo: false)
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
                self.lastSavedTime.removeAll()
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
                        lastSavedTime = object.objectForKey("lastSavedTime") as! String
                        taskInformationObjectId = object.objectId!
                        
                        self.dates.append(date)
                        self.startedTimes.append(startedTime)
                        self.finishedTimes.append(finishedTime)
                        self.clientNames.append(clientName)
                        self.clientObjectIds.append(clientObjectId)
                        self.careGiverNames.append(careGiverName)
                        self.careGiverObjectIds.append(careGiverObjectId)
                        self.lastSavedTime.append(lastSavedTime)
                        self.taskInformationObjectIds.append(taskInformationObjectId)
                        object.pinInBackground()
                        
                    }
                    completion(querySuccessful: true)
                }
            } else {
                completion(querySuccessful: false)
            }
        }

    }

    func attemptUpdatingTaskInformation(taskInformationObjectId: String, completion: (updateSuccessful: Bool) -> Void) {
        
        let query = PFQuery(className: "TaskInformation")
        query.getObjectInBackgroundWithId(taskInformationObjectId) {
            (objects: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
                completion(updateSuccessful: false)
            } else if let object = objects {
                object["sentToCathys"] = true
                object.pinInBackground()
                object.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        completion(updateSuccessful: true)
                    } else {
                        print(error?.description)
                        completion(updateSuccessful: false)
                    }
                }
            }
        }

    }
    
    func removeCellValuesAtIndex(indexPath: NSIndexPath) {
        
        self.dates.removeAtIndex(indexPath.row)
        self.startedTimes.removeAtIndex(indexPath.row)
        self.finishedTimes.removeAtIndex(indexPath.row)
        self.clientNames.removeAtIndex(indexPath.row)
        self.careGiverNames.removeAtIndex(indexPath.row)
        self.careGiverObjectIds.removeAtIndex(indexPath.row)
        self.clientObjectIds.removeAtIndex(indexPath.row)
        self.taskInformationObjectIds.removeAtIndex(indexPath.row)
        self.lastSavedTime.removeAtIndex(indexPath.row)
        
    }
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        
        var numberOfUpdates: Int = 0
        var cellIndicesToBeDeleted: [NSIndexPath] = [NSIndexPath]()
        
        for var row: Int = self.tableView.numberOfRowsInSection(0); row >= 0; row-- {
            let indexPath: NSIndexPath = NSIndexPath(forRow: row, inSection: 0)
            if self.tableView.cellForRowAtIndexPath(indexPath)?.accessoryType == .Checkmark {
            
                self.attemptUpdatingTaskInformation(self.taskInformationObjectIds[indexPath.row], completion: { (updateSuccessful) -> Void in
                    if updateSuccessful {
                        numberOfUpdates++

                        self.removeCellValuesAtIndex(indexPath)
                        
                        cellIndicesToBeDeleted.append(indexPath)
                        self.numberOfRows--
                        
                        if numberOfUpdates == self.numberOfCheckedRows {
                            self.numberOfCheckedRows = 0
                            self.tableView.beginUpdates()
                            self.tableView.deleteRowsAtIndexPaths(
                                cellIndicesToBeDeleted, withRowAnimation: .Automatic)
                            self.tableView.endUpdates()
                            
                        }
                        
                    }
                })
                
            }
        }
        
        
    }
    
    @IBAction func careGiverNameTapped(sender: AnyObject) {

        self.careGiverNameTapped = true
        self.performSegueWithIdentifier("officeTaskCompletedToUserProfile", sender: self.careGiverObjectIds[sender.tag])
        
    }

    @IBAction func clientNameTapped(sender: AnyObject) {
        
        self.clientNameTapped = true
        self.performSegueWithIdentifier("officeTaskCompletedToUserProfile", sender: self.clientObjectIds[sender.tag])
        
    }
    
    @IBAction func seeDetailsButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("officeTasksCompletedToOfficeTaskInformation", sender: sender)
 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Tasks Completed"
        self.setTabBarTopBorderLine()
//        self.attemptQueryingTaskInformation(queryFromLocalDateStore: false) { (querySuccessful) -> Void in
//            if querySuccessful {
//                self.checkedRows = [Bool](count: self.clientObjectId.count, repeatedValue: false)
//                self.tableView.reloadData()
//            }
//        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.attemptQueryingTaskInformation(queryFromLocalDateStore: false) { (querySuccessful) -> Void in
            if querySuccessful {
                self.numberOfRows = self.startedTimes.count
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedRowIndexPath = indexPath
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .Checkmark {
                cell.accessoryType = .None
                self.numberOfCheckedRows--
            } else {
                cell.accessoryType = .Checkmark
                self.numberOfCheckedRows++
            }
        }

    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.numberOfRows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! OfficeTasksCompletedTableViewCell
        
        cell.dateLabel.text = self.dates[indexPath.row]
        cell.startTimeLabel.text = self.startedTimes[indexPath.row]
        cell.finishTimeLabel.text = self.finishedTimes[indexPath.row]
        cell.careGiverNameButton.setTitle(self.careGiverNames[indexPath.row], forState: .Normal)
        cell.careGiverNameButton.tag = indexPath.row
        cell.clientNameButton.setTitle(self.clientNames[indexPath.row], forState: .Normal)
        cell.clientNameButton.tag = indexPath.row
        cell.lastSavedTime.text = self.lastSavedTime[indexPath.row]
        cell.seeDetailsButton.tag = indexPath.row

        if self.numberOfCheckedRows == 0 {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "officeTasksCompletedToOfficeTaskInformation" {
            if let officeTaskInformationTableViewController = segue.destinationViewController as? OfficeTaskInformationTableViewController {
                
                officeTaskInformationTableViewController.taskInformationObjectId = self.taskInformationObjectIds[sender!.tag]
                
            } else {
                print("destinationViewController returned nil")
            }
        } else if segue.identifier == "officeTaskCompletedToUserProfile" {
            if let userProfileViewController = segue.destinationViewController as? UserProfileViewController {
                
                if self.careGiverNameTapped {
                    userProfileViewController.selectedUserType = UserType.careGiver
                    self.careGiverNameTapped = false
                } else if self.clientNameTapped {
                    userProfileViewController.selectedUserType = UserType.client
                    self.clientNameTapped = false
                }
                
                userProfileViewController.userObjectId = sender as! String
                
                
            } else {
                print("destinationViewController returned nil")
            }
        }
    }




}
