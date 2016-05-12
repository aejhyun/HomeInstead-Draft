//
//  OfficeAddUserTableViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 4/11/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class OfficeAddUserTableViewController: UITableViewController {

    @IBOutlet weak var createClientUserBarButton: UIBarButtonItem!
    var selectedUserType: UserType!
    
    var userNames: [String] = [String]()
    var userObjectIds: [String] = [String]()
    var userNotes: [String] = [String]()
    
    var officeUserIds: [[String]] = [[String]]() // This variable is to hold the ids of the office users who added the selected non office user indicated by table row.
    var checkedRows: [Bool] = [Bool]()
    var nameButtonSelectedRow: Int = -1
    var numberOfTimesViewLaidOutSubviews: Int = 0
    var numberOfTimesViewWillAppearIsCalled: Int = 0
    
    var connectedObjectIds: [Dictionary<String, [String]>] = [Dictionary<String, [String]>]()
    
    func setNavigationBarTitle() {
        
        if self.selectedUserType == UserType.careGiver {
            self.navigationItem.title = "Add Care Giver"
        } else if self.selectedUserType == UserType.cathy {
            self.navigationItem.title = "Add Cathy"
        } else if self.selectedUserType == UserType.client {
            self.navigationItem.title = "Add Client"
        }
        
    }
    
    func attemptQueryingNonOfficeUserInformationFromCloudWithClassName(queryFromLocalDateStore: Bool, className: String, completion: (querySuccessful: Bool) -> Void) {
    
        let query = PFQuery(className:className)
        if queryFromLocalDateStore {
            query.fromLocalDatastore()
        }
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        
                        if self.selectedUserType == UserType.careGiver {
                            self.connectedObjectIds.append(object.objectForKey("connectedObjectIds") as! Dictionary<String, [String]>)
                        }
                        
                        self.officeUserIds.append(object.objectForKey("idsOfOfficeUsersWhoAddedThisUser") as! [String])
                        
                        self.userNames.append(object.objectForKey("name") as! String)
                        self.userObjectIds.append(object.objectId!)
                        self.userNotes.append(object.objectForKey("notes") as! String)

                        object.pinInBackground()
                    }
                    completion(querySuccessful: true)
                }
            } else {
                completion(querySuccessful: false)
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarTitle()
        
        if self.selectedUserType != UserType.client {
            self.createClientUserBarButton.tintColor = UIColor.clearColor()
            self.createClientUserBarButton.enabled = false
        }
        
    }
    

    
    override func viewWillAppear(animated: Bool) {
        
        if self.numberOfTimesViewWillAppearIsCalled >= 0 {
            
            self.officeUserIds.removeAll()
            self.userNames.removeAll()
            
            self.attemptQueryingNonOfficeUserInformationFromCloudWithClassName(false, className: ClassNameForCloud().getClassName(self.selectedUserType)!) { (querySuccessful) -> Void in
                
                if querySuccessful {
                    // self.checkedRows is to keep track of which rows are checked by the user.
                    if self.selectedUserType == UserType.client {
                        self.createClientUserBarButton.enabled = true
                    }
                    self.checkedRows = [Bool](count: self.userNames.count, repeatedValue: false)
                    self.tableView.reloadData()
        
                }
                
            }
           
        }
        
        self.numberOfTimesViewWillAppearIsCalled++

    }
    
    @IBAction func nameButtonTapped(sender: AnyObject) {
        
        let nameButton = sender as! UIButton
        let superView = nameButton.superview!
        let officeAddUserTableViewCell = superView.superview as! OfficeAddUserTableViewCell
        let indexPath = tableView.indexPathForCell(officeAddUserTableViewCell)
        self.nameButtonSelectedRow = (indexPath?.row)!
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.userNames.count
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if isAlreadyAddedByCurrentOfficeUser(indexPath.row) {
            return nil
        } else {
            return indexPath
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .Checkmark {
                cell.accessoryType = .None
                self.checkedRows[indexPath.row] = false
            } else {
                cell.accessoryType = .Checkmark
                self.checkedRows[indexPath.row] = true
            }
        }
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! OfficeAddUserTableViewCell

        if !self.checkedRows[indexPath.row] {
            cell.accessoryType = .None
        } else if self.checkedRows[indexPath.row] {
            cell.accessoryType = .Checkmark
        }
        
        if isAlreadyAddedByCurrentOfficeUser(indexPath.row) {
            cell.alreadyAddedLabel.hidden = false
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        } else {
            cell.alreadyAddedLabel.hidden = true
        }
        
        cell.nameButton.setTitle(self.userNames[indexPath.row], forState: UIControlState.Normal)
 
        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "officeAddUsersToUserProfile" {
            
            if let userProfileViewController = segue.destinationViewController as? UserProfileViewController {
                userProfileViewController.userObjectId = self.userObjectIds[self.nameButtonSelectedRow]
                userProfileViewController.selectedUserType = self.selectedUserType
            } else {
                print("destinationViewController returned nil")
            }
            
        } else if segue.identifier == "officeAddUsersToOfficeCreateClientProfile" {
            
            if let navigationController = segue.destinationViewController as? UINavigationController {
                if let officeCreateClientUserViewController = navigationController.topViewController as? OfficeCreateClientUserViewController {
                    print(officeCreateClientUserViewController)
        
                } else {
                    print("officeAddUserTableViewController returned nil")
                }
            } else {
                print("navigationController returned nil")
            }
            
        }
        
    }
    
    func isAlreadyAddedByCurrentOfficeUser(row: Int) -> Bool {

        if self.officeUserIds[row].contains((PFUser.currentUser()?.objectId)!) {
            return true
        } else {
            return false
        }

    }
    
    func attemptUpdatingIdsOfOfficeUsersWhoAddedThisUserInCloud(row: Int, completion: (updateSuccessful: Bool) -> Void) {
        
        self.officeUserIds[row].append((PFUser.currentUser()?.objectId)!)
        
        let query = PFQuery(className: ClassNameForCloud().getClassName(self.selectedUserType)!)
        query.getObjectInBackgroundWithId(self.userObjectIds[row]) {
            (query: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
                completion(updateSuccessful: false)
            } else if let query = query {
                query["idsOfOfficeUsersWhoAddedThisUser"] = self.officeUserIds[row]
                query.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        completion(updateSuccessful: true)
                    } else {
                        print(error?.description)
                    }
                }
            }
        }
        
    }
    
    func appendCurrentOfficeUserId(var officeUserIds: [String]) -> [String] {
        let currentOfficeUserId: String = (PFUser.currentUser()?.objectId!)!
        if !officeUserIds.contains(currentOfficeUserId) {
            officeUserIds.append(currentOfficeUserId)
        }
        return officeUserIds
    }
    
    func attemptUpdatingOfficeUserIds(userType: UserType, objectId: String, completion: (updateSuccessful: Bool) -> Void) {
        
        var officeUserIds: [String] = [String]()
        let query = PFQuery(className: ClassNameForCloud().getClassName(userType)!)
        query.getObjectInBackgroundWithId(objectId) {
            (query: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
                completion(updateSuccessful: false)
            } else if let query = query {
                officeUserIds = query.objectForKey("idsOfOfficeUsersWhoAddedThisUser") as! [String]
                query["idsOfOfficeUsersWhoAddedThisUser"] = self.appendCurrentOfficeUserId(officeUserIds) // Only append if the office user id is not already present.
                query.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        completion(updateSuccessful: true)
                    } else {
                        print(error?.description)
                    }
                }
            }
        }
        
    }
    
    func removeDuplicateObjectIds(values: [String]) -> [String] {

        let uniques = Set<String>(values)
        let result = Array<String>(uniques)
        return result
        
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        
        let updateSuccessCheck =
        
        var firstUpdateFinished: Bool = false
        var secondUpdateFinished: Bool = false
        var thirdUpdateFinished: Bool = false
        
        
        var numOfCheckedRows: Int = 0
        var numOfOfficeUserIdsUpdated: Int = 0
        
        for var row: Int = 0; row < self.checkedRows.count; row++ {
            if self.checkedRows[row] == true {
                numOfCheckedRows++
                self.attemptUpdatingOfficeUserIds(self.selectedUserType, objectId: self.userObjectIds[row], completion: { (updateSuccessful) -> Void in
                    numOfOfficeUserIdsUpdated++
                    if numOfCheckedRows == numOfOfficeUserIdsUpdated {
                        if self.selectedUserType != UserType.careGiver {
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        firstUpdateFinished = true
                    }
                })
            }
        }
        
        if self.selectedUserType == UserType.careGiver {
            
            var clientObjectIds: [String] = [String]()
            var cathyObjectIds: [String] = [String]()
            
            for var row: Int = 0; row < self.checkedRows.count; row++ {
                if self.checkedRows[row] == true {
                    for (connectedClientObjectId, connectedCathyObjectIds) in self.connectedObjectIds[row] {
                        clientObjectIds.append(connectedClientObjectId)
                        cathyObjectIds.appendContentsOf(connectedCathyObjectIds)
                    }
                }
   
            }
            
            clientObjectIds = self.removeDuplicateObjectIds(clientObjectIds)
            cathyObjectIds = self.removeDuplicateObjectIds(cathyObjectIds)
            
            var numOfOfficeUserIdsUpdatedForClient = 0
            
            for var index: Int = 0; index < clientObjectIds.count; index++ {
                self.attemptUpdatingOfficeUserIds(UserType.client, objectId: clientObjectIds[index], completion: { (updateSuccessful) -> Void in
                    numOfOfficeUserIdsUpdatedForClient++
                    if numOfOfficeUserIdsUpdatedForClient == clientObjectIds.count {
                        secondUpdateFinished = true
                    }
                })
            }
            
            var numOfOfficeUserIdsUpdatedForCathy = 0
            
            for var index: Int = 0; index < cathyObjectIds.count; index++ {
                self.attemptUpdatingOfficeUserIds(UserType.cathy, objectId: cathyObjectIds[index], completion: { (updateSuccessful) -> Void in
                    numOfOfficeUserIdsUpdatedForCathy++
                    if numOfOfficeUserIdsUpdatedForCathy == cathyObjectIds.count {
                        thirdUpdateFinished = true
                    }
                })
            }
            
            
        }
        
        
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
}
