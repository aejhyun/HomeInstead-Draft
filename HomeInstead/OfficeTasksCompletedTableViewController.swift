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
    
    var date: [String] = [String]()
    var startTime: [String] = [String]()
    var finishTime: [String] = [String]()
    var clientName: [String] = [String]()
    var careGiverName: [String] = [String]()
    var careGiverObjectId: [String] = [String]()
    var clientObjectId: [String] = [String]()
    var taskInformationObjectId: [String] = [String]()
    
    var selectedRowIndexPath: NSIndexPath? = nil
    
    func setTabBarTopBorderLine() {

        let viewFrame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 1.0)
        let tabBarTopHairLine: UIView = UIView(frame: viewFrame)
        tabBarTopHairLine.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(tabBarTopHairLine)
        
        self.tabBarController!.tabBar.addSubview(tabBarTopHairLine)
        
    }
    
    func attemptQueryingTaskInformation(completion: (querySuccessful: Bool) -> Void) {
        
        var date: String = ""
        var startTime: String = ""
        var finishTime: String = ""
        var clientName: String = ""
        var careGiverName: String = ""
        var careGiverObjectId: String = ""
        var clientObjectId: String = ""
        var taskInformationObjectId: String = ""
        
        let query = PFQuery(className: "TaskInformation")
        query.whereKey("officeUserIds", containedIn: [(PFUser.currentUser()?.objectId)!])
        //query.fromLocalDatastore()
        query.whereKey("sentToCathys", equalTo: false)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        date = object.objectForKey("date") as! String
                        startTime = object.objectForKey("startedTime") as! String
                        finishTime = object.objectForKey("finishedTime") as! String
                        clientName = object.objectForKey("clientName") as! String
                        clientObjectId = object.objectForKey("clientObjectId") as! String
                        careGiverName = object.objectForKey("careGiverName") as! String
                        careGiverObjectId = object.objectForKey("careGiverObjectId") as! String
                        taskInformationObjectId = object.objectId!
                        
                        self.date.append(date)
                        self.startTime.append(startTime)
                        self.finishTime.append(finishTime)
                        self.clientName.append(clientName)
                        self.clientObjectId.append(clientObjectId)
                        self.careGiverName.append(careGiverName)
                        self.careGiverObjectId.append(careGiverObjectId)
                        self.taskInformationObjectId.append(taskInformationObjectId)
                        object.pinInBackground()
                        
                    }
                    completion(querySuccessful: true)
                }
            } else {
                completion(querySuccessful: false)
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Tasks Completed"
        self.setTabBarTopBorderLine()
        self.attemptQueryingTaskInformation { (querySuccessful) -> Void in
            if querySuccessful {
                self.tableView.reloadData()
            }
        }
        
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedRowIndexPath = indexPath
        self.performSegueWithIdentifier("officeTasksCompletedToOfficeTaskInformation", sender: nil)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.startTime.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! OfficeTasksCompletedTableViewCell

        cell.dateLabel.text = self.date[indexPath.row]
        cell.startTimeLabel.text = self.startTime[indexPath.row]
        cell.finishTimeLabel.text = self.finishTime[indexPath.row]
        cell.careGiverNameButton.setTitle(self.careGiverName[indexPath.row], forState: .Normal)
        cell.clientNameButton.setTitle(self.clientName[indexPath.row], forState: .Normal)

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "officeTasksCompletedToOfficeTaskInformation" {
            if let officeTaskInformationTableViewController = segue.destinationViewController as? OfficeTaskInformationTableViewController {
                
                officeTaskInformationTableViewController.taskInformationObjectId = self.taskInformationObjectId[self.selectedRowIndexPath!.row]
                
            } else {
                print("destinationViewController returned nil")
            }
        }
    }




}
