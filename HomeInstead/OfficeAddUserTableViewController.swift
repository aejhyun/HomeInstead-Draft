//
//  OfficeAddUserTableViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 4/11/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class OfficeAddUserTableViewController: UITableViewController, PassUserInformationDelegate {

    @IBOutlet weak var createClientUserBarButton: UIBarButtonItem!
    var selectedUserType: UserType!
    var users: [[String: String]] = [[String: String]]()
    var user: [String: String] = [String: String]()
    var officeUserIds: [[String]] = [[String]]() // This variable is to hold the ids of the office users who added the selected non office user indicated by table row.
    var checkedRows: [Bool] = [Bool]()
    var nameButtonSelectedRow: Int = -1
    var numberOfTimesViewLaidOutSubviews: Int = 0
    var numberOfNonOfficeUsersToBeAddedToOfficeUser: Int = 0
    
    func setNavigationBarTitle() {
        
        if self.selectedUserType == UserType.careGiver {
            self.navigationItem.title = "Add Care Giver"
        } else if self.selectedUserType == UserType.cathy {
            self.navigationItem.title = "Add Cathy"
        } else if self.selectedUserType == UserType.client {
            self.navigationItem.title = "Add Client"
        }
        
    }
    
    func attemptQueryingNonOfficeUserInformationFromCloudWithClassName(className: String, completion: (querySuccessful: Bool) -> Void) {
        
        var userInformation: [String: String] = [String: String]()
        var idsOfOfficeUsersWhoAddedThisUser: [String] = [String]()
        let query = PFQuery(className:className)
        //query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        
                        idsOfOfficeUsersWhoAddedThisUser = object.objectForKey("idsOfOfficeUsersWhoAddedThisUser") as! [String]
                        self.officeUserIds.append(idsOfOfficeUsersWhoAddedThisUser)
                        
                        userInformation["name"] = object.objectForKey("name") as? String
                        userInformation["notes"] = object.objectForKey("notes") as? String
                        userInformation["email"] = object.objectForKey("email") as? String
                        userInformation["province"] = object.objectForKey("province") as? String
                        userInformation["city"] = object.objectForKey("city") as? String
                        userInformation["district"] = object.objectForKey("district") as? String
                        userInformation["streetOne"] = object.objectForKey("streetOne") as? String
                        userInformation["streetTwo"] = object.objectForKey("streetTwo") as? String
                        userInformation["streetThree"] = object.objectForKey("streetThree") as? String
                        userInformation["postalCode"] = object.objectForKey("postalCode") as? String
                        userInformation["phoneNumber"] = object.objectForKey("phoneNumber") as? String
                        userInformation["emergencyPhoneNumber"] = object.objectForKey("emergencyPhoneNumber") as? String
                        userInformation["userType"] = object.objectForKey("userType") as? String
                        userInformation["userId"] = object.objectForKey("userId") as? String
                        userInformation["objectId"] = object.objectId
                        self.users.append(userInformation)
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
        
        if let className = ClassNameForCloud().getClassName(self.selectedUserType) {
            
            self.attemptQueryingNonOfficeUserInformationFromCloudWithClassName(className) { (querySuccessful) -> Void in
                
                if querySuccessful {
                    // self.checkedRows is to keep track of which rows are checked by the user.
                    self.checkedRows = [Bool](count: self.users.count, repeatedValue: false)
                    self.tableView.reloadData()
                }
                
            }
            
        } else {
            print("className returned nil")
        }
        
    }
    
    func updateUserInformationLocally() {
        // self.user has the data from the previous view controller. The reason why it is not in a viewWillLoad() function is because self.user's data becomes available after the first half of life cycle of a view controller has finished. The reason for the -1 check is because I don't want this to be set the first time this view segues to the next view controller because there is no value to set.
        
        if nameButtonSelectedRow != -1 {
            self.users[nameButtonSelectedRow] = self.user
            self.tableView.reloadData()
            
        }
        
    }

    
    override func viewWillAppear(animated: Bool) {
        self.updateUserInformationLocally()
        
        if self.selectedUserType != UserType.client {
            self.createClientUserBarButton.tintColor = UIColor.clearColor()
            self.createClientUserBarButton.enabled = false
        }
        
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
        return self.users.count
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
        
        cell.nameButton.setTitle(self.users[indexPath.row]["name"], forState: UIControlState.Normal)
        cell.emailLabel.text = self.users[indexPath.row]["email"]
        
        return cell
        
    }
    
    func passUserInformation(user: [String: String]) {
        // Receiving user information from previous view controller.
        self.user = user
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let userProfileViewController = segue.destinationViewController as? UserProfileViewController {
            userProfileViewController.user = self.users[self.nameButtonSelectedRow]
            userProfileViewController.passUserInformationDelegate = self
            userProfileViewController.selectedUserType = self.selectedUserType
        } else {
            print("destinationViewController returned nil")
        }
        
    }
    
    func isAlreadyAddedByCurrentOfficeUser(row: Int) -> Bool {

        if self.officeUserIds[row].contains((PFUser.currentUser()?.objectId)!) {
            return true
        } else {
            return false
        }

    }
    
    func updateIdsOfOfficeUsersWhoAddedThisUserInCloud(row: Int) {
        
        self.officeUserIds[row].append((PFUser.currentUser()?.objectId)!)
        
        let query = PFQuery(className: ClassNameForCloud().getClassName(self.selectedUserType)!)
        query.getObjectInBackgroundWithId(self.users[row]["objectId"]!) {
            (query: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let query = query {
                query["idsOfOfficeUsersWhoAddedThisUser"] = self.officeUserIds[row]
                query.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (!success) {
                        print(error?.description)
                    }
                }
            }
        }
        
    }
    
    func attemptAddingUsersToOfficeUserToCloud (row: Int, completion: (addingUsersSuccessful: Bool) -> Void) {
        
        let usersAddedByOfficeUser = PFObject(className:"UsersAddedByOfficeUser")
        
        usersAddedByOfficeUser["officeUserId"] = PFUser.currentUser()?.objectId
        //usersAddedByOfficeUser["userInformation"] = self.users[row]
        
        usersAddedByOfficeUser["name"] = self.users[row]["name"]
        usersAddedByOfficeUser["notes"] = self.users[row]["notes"]
        usersAddedByOfficeUser["email"] = self.users[row]["email"]
        usersAddedByOfficeUser["province"] = self.users[row]["province"]
        usersAddedByOfficeUser["city"] = self.users[row]["city"]
        usersAddedByOfficeUser["district"] = self.users[row]["district"]
        usersAddedByOfficeUser["streetOne"] = self.users[row]["streetOne"]
        usersAddedByOfficeUser["streetTwo"] = self.users[row]["streetTwo"]
        usersAddedByOfficeUser["streetThree"] = self.users[row]["streetThree"]
        usersAddedByOfficeUser["postalCode"] = self.users[row]["postalCode"]
        usersAddedByOfficeUser["phoneNumber"] = self.users[row]["phoneNumber"]
        usersAddedByOfficeUser["emergencyPhoneNumber"] = self.users[row]["emergencyPhoneNumber"]
        usersAddedByOfficeUser["userType"] = self.users[row]["userType"]
        usersAddedByOfficeUser["nonOfficeUserId"] = self.users[row]["userId"]
        usersAddedByOfficeUser["nonOfficeUserObjectId"] = self.users[row]["objectId"]
        
        usersAddedByOfficeUser.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                completion(addingUsersSuccessful: true)
            } else {
                print(error?.description)
                completion(addingUsersSuccessful: false)
            }
        }
        
    }
    
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        
        var numberOfNonOfficeUsersAddedToOfficeUser: Int = 0
        for var row: Int = 0; row < self.users.count; row++ {
            if self.checkedRows[row] == true {
                if !self.isAlreadyAddedByCurrentOfficeUser(row) {
                    self.numberOfNonOfficeUsersToBeAddedToOfficeUser++
                    self.updateIdsOfOfficeUsersWhoAddedThisUserInCloud(row)
                    self.attemptAddingUsersToOfficeUserToCloud(row, completion: { (addingUsersSuccessful) -> Void in
                        numberOfNonOfficeUsersAddedToOfficeUser++
                        if addingUsersSuccessful {
                            if numberOfNonOfficeUsersAddedToOfficeUser == self.numberOfNonOfficeUsersToBeAddedToOfficeUser {
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                        }
                    })
                }
            }
        }
        
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
        func numberOfUsersToBeAddedToCloud() -> Int {
    
            var counter: Int = 0
            for var index: Int = 0; index < self.checkedRows.count; index++ {
                if self.checkedRows[index] == true {
                    counter++
                }
            }
            return counter
        }
    
    
    func attemptQueryingNonOfficeUsersAlreadyAddedToOfficeUser(completion: (querySuccessful: Bool, userIds: [String]) -> Void) {
        
        var userIds: [String] = [String]()
        let query = PFQuery(className:"UsersAddedByOfficeUser")
        query.whereKey("officeUserId", equalTo:(PFUser.currentUser()?.objectId)!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        userIds.append((object.objectForKey("nonOfficeUserId") as! String))
                    }
                    print(userIds)
                    completion(querySuccessful: true, userIds: userIds)
                }
            } else {
                completion(querySuccessful: false, userIds: userIds)
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }
    
    func returnRowOfNonOfficeUserNotAlreadyAddedToOfficeUser(completion: (row: Int) -> Void) {
        
        self.attemptQueryingNonOfficeUsersAlreadyAddedToOfficeUser { (querySuccessful, userIds) -> Void in
            if querySuccessful {
                
                for var row = 0; row < self.users.count; row++ {
                    if self.checkedRows[row] == true {
                        
                        if !userIds.contains(self.users[row]["userId"]!) {
                            completion(row: row)
                        }
                        
                    }
                }
                
            } else {
                print("Querying users already added to the office user was unsuccessful.")
            }
        }
        
    }

    
    
    
    
    
    
    
    
    
    
}
