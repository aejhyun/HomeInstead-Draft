//
//  CareGiverClientListTableViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 5/4/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class CareGiverClientListTableViewController: UITableViewController {

    var classNameForCloud: ClassNameForCloud = ClassNameForCloud()
    var nameButtonSelectedRow: Int = -1
    var selectedRowIndexPath: NSIndexPath? = nil
    var cathyObjectIdsAndUserIds: [String: String] = [String: String]()
    var objectIdsAndNames: [String: String] = [String: String]()
    var clientObjectIds: [String] = [String]()
    var connectedObjectIds: [String: [String]] = [String: [String]]()
    var officeUserIds: [String] = [String]()
    
    var names: [String] = [String]()
    
    func attemptQueryingClientObjectIdsFromCloud(completion: (querySuccessful: Bool, clientObjectIds: [String: [String]]?) -> Void) {
        
        var clientObjectIds: [String: [String]]? = [String: [String]]()
        
        let query = PFQuery(className: self.classNameForCloud.getClassName(UserType.careGiver)!)
        query.whereKey("userId", equalTo: (PFUser.currentUser()?.objectId)!)
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        clientObjectIds = object.objectForKey("connectedObjectIds") as? [String: [String]]
                        self.officeUserIds = object.objectForKey("idsOfOfficeUsersWhoAddedThisUser") as! [String]
                        self.connectedObjectIds = object.objectForKey("connectedObjectIds") as! [String: [String]]
                        self.objectIdsAndNames = object.objectForKey("clientObjectIdsAndNames") as! [String: String]
                        self.cathyObjectIdsAndUserIds = object.objectForKey("cathyObjectIdsAndUserIds") as! [String: String]
                        object.pinInBackground()
                    }
                }
                completion(querySuccessful: true, clientObjectIds: clientObjectIds)
            } else {
                completion(querySuccessful: true, clientObjectIds: nil)
            }
        }
    }
    
    func attemptQueryingClientProfileFromCloud(clientObjectId: String, completion: (querySuccessful: Bool) -> Void) {
        
        let query = PFQuery(className: classNameForCloud.getClassName(UserType.client)!)
       
        query.getObjectInBackgroundWithId(clientObjectId) {
            (objects: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
                completion(querySuccessful: false)
            } else if let object = objects {
                object.pinInBackground()

                completion(querySuccessful: true)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.attemptQueryingClientObjectIdsFromCloud { (querySuccessful, clientObjectIds) -> Void in
            if querySuccessful {
                for (clientObjectId, _) in clientObjectIds! {
                    self.attemptQueryingClientProfileFromCloud(clientObjectId, completion: { (querySuccessful) -> Void in
                        if querySuccessful {
                            
                        }
                    })
                    self.clientObjectIds.append(clientObjectId) // The reason why the element to be appended is [String: [String]] and the variable being append to is [String] is because I just want the client object Id and not all the connection. self.connectedObjectIds holds all the connections for the client and the cathy for this care giver.
                }
                self.tableView.reloadData()

            }
        }
        
    }
    
    
    @IBAction func nameButtonTapped(sender: AnyObject) {
        
        let nameButton = sender as! UIButton
        let superView = nameButton.superview!
        let officeConnectUserTableViewCell = superView.superview as! CareGiverClientListTableViewCell
        let indexPath = tableView.indexPathForCell(officeConnectUserTableViewCell)
        self.nameButtonSelectedRow = (indexPath?.row)!
        self.performSegueWithIdentifier("careGiverClientListToUserProfile", sender: nil)
        
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedRowIndexPath = indexPath
        self.performSegueWithIdentifier("careGiverClientListToCareGiverTaskList", sender: nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.clientObjectIds.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CareGiverClientListTableViewCell
        
        cell.accessoryType = .DisclosureIndicator
        
        cell.nameButton.setTitle(self.objectIdsAndNames[self.clientObjectIds[indexPath.row]], forState: UIControlState.Normal)
        


        return cell
    }
    
    func getCathyUserIds() -> [String] {
        
        var cathyUserIds: [String] = [String]()
        
        for cathyObjectId in self.connectedObjectIds[self.clientObjectIds[self.selectedRowIndexPath!.row]]! {
            cathyUserIds.append(self.cathyObjectIdsAndUserIds[cathyObjectId]!)
        }
        
        return cathyUserIds
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "careGiverClientListToUserProfile" {
            if let userProfileViewController = segue.destinationViewController as? UserProfileViewController {

                userProfileViewController.userObjectId = self.clientObjectIds[self.nameButtonSelectedRow]
                userProfileViewController.selectedUserType = UserType.client
                userProfileViewController.isBeingViewedByOfficeUser = false

            } else {
                print("destinationViewController returned nil")
            }
        } else if segue.identifier == "careGiverClientListToCareGiverTaskList" {
            if let careGiverTaskListViewController = segue.destinationViewController as? CareGiverTaskListViewController {
                
                careGiverTaskListViewController.cathyUserIds = getCathyUserIds()
                careGiverTaskListViewController.officeUserIds = self.officeUserIds
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
