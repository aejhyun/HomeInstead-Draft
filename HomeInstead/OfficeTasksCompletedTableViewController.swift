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
    
    var dates: [String] = [String]()
    var startedTimes: [String] = [String]()
    var finishedTimes: [String] = [String]()
    var clientNames: [String] = [String]()
    var careGiverNames: [String] = [String]()
    var careGiverObjectIds: [String] = [String]()
    var clientObjectIds: [String] = [String]()
    var taskInformationObjectIds: [String] = [String]()
    var lastSavedTime: [String] = [String]()
    
    var checkedRows: [Bool] = [Bool]()
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
                self.checkedRows.removeAll()
                
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
                    self.checkedRows = [Bool](count: self.clientObjectIds.count, repeatedValue: false)
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
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        var numberOfUpdates: Int = 0
        
        print(self.checkedRows)
        
        for var row: Int = 0; row < self.checkedRows.count; row++ {
            if self.checkedRows[row] {
                print(self.taskInformationObjectIds[row])
                self.attemptUpdatingTaskInformation(self.taskInformationObjectIds[row], completion: { (updateSuccessful) -> Void in
                    if updateSuccessful {
                        numberOfUpdates++
                        if numberOfUpdates == self.numberOfCheckedRows {
                            var cellIndicesToBeDeleted: [NSIndexPath] = [NSIndexPath]()
                            for var row: Int = 0; row < self.tableView.numberOfRowsInSection(0); row++ {
                                let indexPath: NSIndexPath = NSIndexPath(forRow: row, inSection: 0)
                                if self.tableView.cellForRowAtIndexPath(indexPath)?.accessoryType == .Checkmark {
                                    self.numberOfRows--
                                    cellIndicesToBeDeleted.append(indexPath)
                                }
                            }
                            self.checkedRows = [Bool](count: self.numberOfRows, repeatedValue: false)
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
                self.checkedRows = [Bool](count: self.clientObjectIds.count, repeatedValue: false)
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
                self.checkedRows[indexPath.row] = false
                self.numberOfCheckedRows--
            } else {
                cell.accessoryType = .Checkmark
                self.checkedRows[indexPath.row] = true
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
        cell.clientNameButton.setTitle(self.clientNames[indexPath.row], forState: .Normal)
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
        }
    }




}
