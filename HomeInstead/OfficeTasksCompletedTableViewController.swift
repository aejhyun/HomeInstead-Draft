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
    
    var clientNameIndexPath: NSIndexPath? = nil
    var careGiverNameIndexPath: NSIndexPath? = nil
    var seeDetailsIndexPath: NSIndexPath? = nil
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
    
    func removeCellValuesAtIndexPath(indexPath: NSIndexPath) {
        
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
    
    func indexPathsInDescendingOrder(indexPathOne: NSIndexPath, indexPathTwo: NSIndexPath) -> Bool {
        return indexPathTwo.row < indexPathOne.row
    }
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        
        var numberOfUpdates: Int = 0
        var indexPathsToBeDeleted: [NSIndexPath] = [NSIndexPath]()
        
        for var row: Int = 0; row < self.tableView.numberOfRowsInSection(0); row++ {
            let indexPath: NSIndexPath = NSIndexPath(forRow: row, inSection: 0)
            if self.tableView.cellForRowAtIndexPath(indexPath)?.accessoryType == .Checkmark {
                self.attemptUpdatingTaskInformation(self.taskInformationObjectIds[indexPath.row], completion: { (updateSuccessful) -> Void in
                    if updateSuccessful {
                        numberOfUpdates++ // This is here so that I know when to call self.tableView.deleteRowsAtIndexPaths() because I want all the rows to be deleted at one time.
                        
                        // Interesting behavior here. The indexPaths that come through do not come in an ascending order. I think whatever information that gets uploaded first, that associated indexPath will come through first. So it's quite unpredictable. And in the case that multiple rows are "checked", the removal of the cell values have to go from a descending order because if it goes in an ascending order, then it will cause everything to shift down, which will cause values to be removed at indeces that I do not want removed. So that is the reason for the sort function down below.
                        indexPathsToBeDeleted.append(indexPath)
                        
                        if numberOfUpdates == self.numberOfCheckedRows {
                            
                            indexPathsToBeDeleted = indexPathsToBeDeleted.sort(self.indexPathsInDescendingOrder)
                            
                            for indexPath in indexPathsToBeDeleted {
                                self.removeCellValuesAtIndexPath(indexPath)
                            }
                            
                            self.numberOfCheckedRows = 0
                            self.tableView.beginUpdates()
                            self.tableView.deleteRowsAtIndexPaths(
                                indexPathsToBeDeleted, withRowAnimation: .Automatic)
                            self.tableView.endUpdates()
                            
                        }
                        
                    }
                })
                
            }
        }
        
        
    }
    
    @IBAction func careGiverNameTapped(sender: AnyObject) {
        
        let careGiverNameButton = sender as! UIButton
        let superView = careGiverNameButton.superview!
        let officeTaskInformationTableViewCell = superView.superview as! OfficeTasksCompletedTableViewCell
        let indexPath = self.tableView.indexPathForCell(officeTaskInformationTableViewCell)
        self.careGiverNameIndexPath = indexPath
        
        self.careGiverNameTapped = true
        self.performSegueWithIdentifier("officeTaskCompletedToUserProfile", sender: self.careGiverObjectIds[sender.tag])
        
    }

    @IBAction func clientNameTapped(sender: AnyObject) {
        
        let clientNameButton = sender as! UIButton
        let superView = clientNameButton.superview!
        let officeTaskInformationTableViewCell = superView.superview as! OfficeTasksCompletedTableViewCell
        let indexPath = self.tableView.indexPathForCell(officeTaskInformationTableViewCell)
        self.clientNameIndexPath = indexPath
        
        self.clientNameTapped = true
        self.performSegueWithIdentifier("officeTaskCompletedToUserProfile", sender: self.clientObjectIds[sender.tag])
        
    }
    
    @IBAction func seeDetailsButtonTapped(sender: AnyObject) {
        
        let seeDetailsButton = sender as! UIButton
        let superView = seeDetailsButton.superview!
        let officeTaskInformationTableViewCell = superView.superview as! OfficeTasksCompletedTableViewCell
        let indexPath = self.tableView.indexPathForCell(officeTaskInformationTableViewCell)
        self.seeDetailsIndexPath = indexPath
        
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
        return self.taskInformationObjectIds.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! OfficeTasksCompletedTableViewCell
        
        cell.dateLabel.text = self.dates[indexPath.row]
        cell.startTimeLabel.text = self.startedTimes[indexPath.row]
        cell.finishTimeLabel.text = self.finishedTimes[indexPath.row]
        cell.careGiverNameButton.setTitle(self.careGiverNames[indexPath.row], forState: .Normal)
        cell.clientNameButton.setTitle(self.clientNames[indexPath.row], forState: .Normal)
        cell.lastSavedTime.text = self.lastSavedTime[indexPath.row]

        if self.numberOfCheckedRows == 0 {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "officeTasksCompletedToOfficeTaskInformation" {
            if let officeTaskInformationTableViewController = segue.destinationViewController as? OfficeTaskInformationTableViewController {

                officeTaskInformationTableViewController.taskInformationObjectId = self.taskInformationObjectIds[self.seeDetailsIndexPath!.row]
                
            } else {
                print("destinationViewController returned nil")
            }
        } else if segue.identifier == "officeTaskCompletedToUserProfile" {
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




}
