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
    var users: [[String: NSObject?]] = [[String: NSObject?]]()
    var user: [String: NSObject?] = [String: NSObject?]()
    var checkedRows: [Bool] = [Bool]()
    var nameButtonSelectedRow: Int = -1
    var numberOfTimesViewLaidOutSubviews: Int = 0
    
    func setNavigationBarTitle() {
        
        if self.selectedUserType == UserType.careGiver {
            self.navigationItem.title = "Add Care Giver"
        } else if self.selectedUserType == UserType.cathy {
            self.navigationItem.title = "Add Cathy"
        } else if self.selectedUserType == UserType.client {
            self.navigationItem.title = "Add Client"
        }
        
    }
    
    func attemptQueryUserInformationFromCloudWithClassName(className: String, completion: (querySuccessful: Bool) -> Void) {
        
        var userInformation: [String: NSObject?] = [String: NSObject?]()
        let query = PFQuery(className:className)
        //query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        userInformation["imageFile"] = nil
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
                        userInformation["userId"] = object.objectForKey("userId") as? String
                        userInformation["userType"] = object.objectForKey("userType") as? String
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
            
            self.attemptQueryUserInformationFromCloudWithClassName(className) { (querySuccessful) -> Void in
                
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
        
        cell.nameButton.setTitle(self.users[indexPath.row]["name"] as? String, forState: UIControlState.Normal)
        cell.emailLabel.text = self.users[indexPath.row]["email"] as? String
        
        return cell
        
    }
    
    func passUserInformation(user: [String : NSObject?]) {
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
    
    func attemptAddUserToOfficeUserToCloud (completion: (uploadSuccessful: Bool) -> Void) {
        
        for var index = 0; index < self.users.count; index++ {
            let usersAddedByOfficeUser = PFObject(className:"UsersAddedByOfficeUser")
            
            if self.checkedRows[index] == true {
                
                usersAddedByOfficeUser["officeUserId"] = PFUser.currentUser()?.objectId
                usersAddedByOfficeUser["userType"] = self.selectedUserType.rawValue
//                usersAddedByOfficeUser["userType"] = self.users[index] as? [String: String]
                usersAddedByOfficeUser["name"] = self.users[index]["name"] as? String
                usersAddedByOfficeUser["email"] = self.users[index]["email"] as? String
                usersAddedByOfficeUser["province"] = self.users[index]["province"] as? String
                usersAddedByOfficeUser["city"] = self.users[index]["city"] as? String
                usersAddedByOfficeUser["district"] = self.users[index]["district"] as? String
                usersAddedByOfficeUser["streetOne"] = self.users[index]["streetOne"] as? String
                usersAddedByOfficeUser["streetTwo"] = self.users[index]["streetTwo"] as? String
                usersAddedByOfficeUser["streetThree"] = self.users[index]["streetThree"] as? String
                usersAddedByOfficeUser["postalCode"] = self.users[index]["postalCode"] as? String
                usersAddedByOfficeUser["phoneNumber"] = self.users[index]["phoneNumber"] as? String
                usersAddedByOfficeUser["emergencyPhoneNumber"] = self.users[index]["emergencyPhoneNumber"] as? String
                usersAddedByOfficeUser["userId"] = self.users[index]["userId"] as? String
                usersAddedByOfficeUser["userType"] = self.users[index]["userType"] as? String
                usersAddedByOfficeUser["nonOfficeUserObjectId"] = self.users[index]["objectId"] as? String
                
                usersAddedByOfficeUser["asdf"] = ["asdf": "asdf", "qwer": "qwer"]
                
                usersAddedByOfficeUser.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        completion(uploadSuccessful: true)
                    } else {
                        print(error?.description)
                        completion(uploadSuccessful: false)
                    }
                }
            }
            
        }
        
        
        
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
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        
        let numberOfUsersToBeAdded: Int = self.numberOfUsersToBeAddedToCloud()
        var numberOfUsersAlreadyAdded: Int = 0
        
        self.attemptAddUserToOfficeUserToCloud { (uploadSuccessful) -> Void in
            if uploadSuccessful {
                numberOfUsersAlreadyAdded++
                print("Added non-office user to current office user.")
                if numberOfUsersAlreadyAdded == numberOfUsersToBeAdded {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }

        
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}