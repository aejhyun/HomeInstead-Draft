//
//  OfficeConnectUserViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 4/11/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class OfficeConnectUserViewController: UIViewController, UIBarPositioningDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var careGiverUsers: [[String: String]] = [[String: String]]()
    var cathyUsers: [[String: String]] = [[String: String]]()
    var clientUsers: [[String: String]] = [[String: String]]()
    
    var selectedUserType: UserType!

    var navigationBarLine: UIView = UIView()
    
    var numberOfTimesReloadDataIsCalled: Int = 0

// Navigation bar line functions start here.
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    func removeBottomLineFromNavigationBar() {
        
        for parent in self.navigationController!.navigationBar.subviews {
            for childView in parent.subviews {
                if childView is UIImageView && childView.bounds.size.width == self.navigationController!.navigationBar.frame.size.width {
                    self.navigationBarLine = childView
                }
            }
        }
        
    }

// Navigation bar line functions end here.
    
    func setSegmentedControlWidth() {
        let viewWidth: CGFloat = self.view.frame.width
        self.barButtonItem.width = viewWidth - 20.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setSegmentedControlWidth()
        self.removeBottomLineFromNavigationBar()
        
        // Need to set the initial chosen segment for the segment control. If this is not present, it will cause a crash.
        self.selectedUserType = UserType.client
        
    }
    
    func queryUsersAddedByOfficeUserFromCloud(className: String, completion: (querySuccessful: Bool, users: [[String: String]]) -> Void) {
        
        var users: [[String: String]] = [[String: String]]()
        var userInformation: [String: String] = [String: String]()
        let query = PFQuery(className: className)
        query.whereKey("idsOfOfficeUsersWhoAddedThisUser", containedIn: [(PFUser.currentUser()?.objectId)!])
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        
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
                        users.append(userInformation)
                        
                    }
                    completion(querySuccessful: true, users: users)
                    
                }
            } else {
                completion(querySuccessful: true, users: users)
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }
    
    func queryUsersAddedByOfficeUserFromCloudForSelectedUserType(selectedUserType: UserType, completion: (querySuccessful: Bool) -> Void) {
        
        let classNameForCloud = ClassNameForCloud()
        
        self.queryUsersAddedByOfficeUserFromCloud(classNameForCloud.getClassName(selectedUserType)!) { (querySuccessful, users) -> Void in
            if querySuccessful {
                if selectedUserType
                
                
                self.clientUsers = users
                querySuccessCheck.successfullyQueriedClientUsers = true
                if querySuccessCheck.successfullyQueriedAllUsers() {
                    self.numberOfTimesReloadDataIsCalled++
                    self.tableView.reloadData()
                }
            }
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.numberOfTimesReloadDataIsCalled = 0
        
        self.tableView.estimatedRowHeight = 70
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        var querySuccessCheck = QuerySuccessCheck()
        let classNameForCloud = ClassNameForCloud()
        

        self.queryUsersAddedByOfficeUserFromCloud(classNameForCloud.getClassName(UserType.client)!) { (querySuccessful, users) -> Void in
            if querySuccessful {
                self.clientUsers = users
                querySuccessCheck.successfullyQueriedClientUsers = true
                if querySuccessCheck.successfullyQueriedAllUsers() {
                    self.numberOfTimesReloadDataIsCalled++
                    self.tableView.reloadData()
                }
            }
        }
        
        self.queryUsersAddedByOfficeUserFromCloud(classNameForCloud.getClassName(UserType.cathy)!) { (querySuccessful, users) -> Void in
            if querySuccessful {
                self.cathyUsers = users
                querySuccessCheck.successfullyQueriedCathyUsers = true
                if querySuccessCheck.successfullyQueriedAllUsers(){
                    self.numberOfTimesReloadDataIsCalled++
                    self.tableView.reloadData()
                }
            }
        }
        
        self.queryUsersAddedByOfficeUserFromCloud(classNameForCloud.getClassName(UserType.careGiver)!) { (querySuccessful, users) -> Void in
            if querySuccessful {
                self.careGiverUsers = users
                querySuccessCheck.successfullyQueriedCareGiverUsers = true
                if querySuccessCheck.successfullyQueriedAllUsers() {
                    self.numberOfTimesReloadDataIsCalled++
                    self.tableView.reloadData()
                }
            }
        }
     
        self.navigationBarLine.hidden = true

    }
    
    
    
    override func viewDidDisappear(animated: Bool) {
        
        self.navigationBarLine.hidden = false
        
    }
    
    
    
    @IBAction func segmentedControlIndexChanged(sender: UISegmentedControl) {
        
        if self.segmentedControl.selectedSegmentIndex == 0 {
            self.selectedUserType = UserType.client
        } else if self.segmentedControl.selectedSegmentIndex == 1 {
            self.selectedUserType = UserType.cathy
        } else if self.segmentedControl.selectedSegmentIndex == 2 {
            self.selectedUserType = UserType.careGiver
        }
        self.numberOfTimesReloadDataIsCalled++
        self.tableView.reloadData()
        
    }
    
    func getUsersForSelectedUserType(selectedUserType: UserType) -> [[String: String]] {
        // Use this function to only read and get the different users. If you want to modify the content of the users, do not use this function because it will not return a reference. So any modification that you make to the return value will not modify the class variables, only the copy of the class variables.
        if selectedUserType == UserType.client {
            return self.clientUsers
        } else if selectedUserType == UserType.cathy {
            return self.cathyUsers
       
        } else if selectedUserType == UserType.careGiver {
            return self.careGiverUsers
        }
        return self.clientUsers
        
    }
    
    func deleteUserFromOfficeUserInCloud(user: [[String: String]], indexPath: NSIndexPath) {
        
    }
    
    func deleteRowForSelectedUserType(selectedUserType: UserType, indexPath: NSIndexPath) {

        if selectedUserType == UserType.client {
            self.clientUsers.removeAtIndex(indexPath.row)
        } else if selectedUserType == UserType.cathy {
            self.cathyUsers.removeAtIndex(indexPath.row)
        } else if selectedUserType == UserType.careGiver {
            self.careGiverUsers.removeAtIndex(indexPath.row)
        }

    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            self.deleteRowForSelectedUserType(self.selectedUserType, indexPath: indexPath)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return getUsersForSelectedUserType(self.selectedUserType).count

    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? OfficeConnectUserTableViewCell {
            cell.nameButton.setTitle("", forState: UIControlState.Normal)
        }
        
    }
    
    func configureCellForUserType(cell: OfficeConnectUserTableViewCell, userType: UserType, indexPath: NSIndexPath) {
        var users: [[String: String]] = self.getUsersForSelectedUserType(self.selectedUserType)
        
        cell.nameButton.setTitle(users[indexPath.row]["name"], forState: UIControlState.Normal)
        
        if users[indexPath.row]["notes"] == "" {
            //cell.notesTopSpaceLayoutConstraint.constant = 0
        } else {
            cell.notesTopSpaceLayoutConstraint.constant = 5
        }
        
        cell.notesLabel.text = users[indexPath.row]["notes"]
        
        if userType == UserType.client {
            cell.userIdLabel.text = users[indexPath.row]["objectId"]
        } else {
            cell.userIdLabel.text = users[indexPath.row]["email"]
        }
    }
    
    func configureCellContentAnimation(cell: OfficeConnectUserTableViewCell) {
        
        cell.nameButton.alpha = 0.0
        cell.notesLabel.alpha = 0.0
        cell.userIdLabel.alpha = 0.0
        
        if self.numberOfTimesReloadDataIsCalled == 1 {
            cell.nameButton.alpha = 1.0
            cell.notesLabel.alpha = 1.0
            cell.userIdLabel.alpha = 1.0
            
        }
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            cell.nameButton.alpha = 1.0
        })
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            cell.notesLabel.alpha = 1.0
        })
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            cell.userIdLabel.alpha = 1.0
        })
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! OfficeConnectUserTableViewCell
        
        self.configureCellForUserType(cell, userType: self.selectedUserType, indexPath: indexPath)
        self.configureCellContentAnimation(cell)
        
        return cell
        
    }
    
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("officeConnectUserToOfficeAddUser", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "officeConnectUserToOfficeAddUser" {
            
            if let navigationController = segue.destinationViewController as? UINavigationController {
                if let officeAddUserTableViewController = navigationController.topViewController as? OfficeAddUserTableViewController {
                    
                    officeAddUserTableViewController.selectedUserType = self.selectedUserType
                    
                } else {
                    print("officeAddUserTableViewController returned nil")
                }
            } else {
                print("navigationController returned nil")
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
