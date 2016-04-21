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
    var users: [[String: String]] = [[String: String]]()
    var user: [String: String] = [String: String]()
    var officeUserIds: [[String]] = [[String]]() // This variable is to hold the ids of the office users who added the selected non office user indicated by table row.
    var checkedRows: [Bool] = [Bool]()
    var nameButtonSelectedRow: Int = -1
    var numberOfTimesViewLaidOutSubviews: Int = 0
    var numberOfTimesViewWillAppearIsCalled: Int = 0
    
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
        
        var userInformation: [String: String] = [String: String]()
        var idsOfOfficeUsersWhoAddedThisUser: [String] = [String]()
        let query = PFQuery(className:className)
        
        if queryFromLocalDateStore {
            query.fromLocalDatastore()
        }
        
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
        
        if self.selectedUserType != UserType.client {
            self.createClientUserBarButton.tintColor = UIColor.clearColor()
            self.createClientUserBarButton.enabled = false
        }
        
//        self.attemptQueryingNonOfficeUserInformationFromCloudWithClassName(false, className: ClassNameForCloud().getClassName(self.selectedUserType)!) { (querySuccessful) -> Void in
//            
//            if querySuccessful {
//                // self.checkedRows is to keep track of which rows are checked by the user.
//                self.checkedRows = [Bool](count: self.users.count, repeatedValue: false)
//                self.tableView.reloadData()
//            }
//            
//        }
        
    }
    

    
    override func viewWillAppear(animated: Bool) {
        
        if self.numberOfTimesViewWillAppearIsCalled >= 0 {
            
            self.officeUserIds.removeAll()
            self.users.removeAll()
            
            self.attemptQueryingNonOfficeUserInformationFromCloudWithClassName(false, className: ClassNameForCloud().getClassName(self.selectedUserType)!) { (querySuccessful) -> Void in
                
                if querySuccessful {
                    // self.checkedRows is to keep track of which rows are checked by the user.
                    self.checkedRows = [Bool](count: self.users.count, repeatedValue: false)
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
        
        if self.selectedUserType == UserType.client {
            cell.emailLabel.text = self.users[indexPath.row]["objectId"]
        }
        
        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "officeAddUsersToUserProfile" {
            
            if let userProfileViewController = segue.destinationViewController as? UserProfileViewController {
                userProfileViewController.user = self.users[self.nameButtonSelectedRow]
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
    
    func updateIdsOfOfficeUsersWhoAddedThisUserInCloud(row: Int, completion: (updateSuccessful: Bool) -> Void) {
        
        self.officeUserIds[row].append((PFUser.currentUser()?.objectId)!)
        
        let query = PFQuery(className: ClassNameForCloud().getClassName(self.selectedUserType)!)
        query.getObjectInBackgroundWithId(self.users[row]["objectId"]!) {
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
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        
        var numberOfNonOfficeUsersToBeAddedToOfficeUser: Int = 0
        var numberOfNonOfficeUsersAddedToOfficeUser: Int = 0
        for var row: Int = 0; row < self.users.count; row++ {
            if self.checkedRows[row] == true {
                if !self.isAlreadyAddedByCurrentOfficeUser(row) {
                    numberOfNonOfficeUsersToBeAddedToOfficeUser++
                    self.updateIdsOfOfficeUsersWhoAddedThisUserInCloud(row, completion: { (updateSuccessful) -> Void in
                        numberOfNonOfficeUsersAddedToOfficeUser++
                        if updateSuccessful {
                            if numberOfNonOfficeUsersAddedToOfficeUser == numberOfNonOfficeUsersToBeAddedToOfficeUser {
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

    
}
