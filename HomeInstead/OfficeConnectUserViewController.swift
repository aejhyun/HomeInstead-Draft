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

    var navigationBarLine: UIView = UIView()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var selectedUserType: UserType!
    var userTypes: [UserType] = [UserType.client, UserType.cathy, UserType.careGiver]
    
    var users: [[String: String]] = [[String: String]]()
    var clientUsers: [[String: String]] = [[String: String]]()
    var cathyUsers: [[String: String]] = [[String: String]]()
    var careGiverUsers: [[String: String]] = [[String: String]]()
    
    var clientOfficeUserIds: [[String]] = [[String]]() // These variables are to hold the ids of the office users who added the non office user.
    var cathyOfficeUserIds: [[String]] = [[String]]()
    var careGiverOfficeUserIds: [[String]] = [[String]]()
    
    var userCheckedRows: [Bool] = [Bool]()
    var clientCheckedRows: [Bool] = [Bool]()
    var cathyCheckedRows: [Bool] = [Bool]()
    var careGiverCheckedRows: [Bool] = [Bool]()
    
    var clientConnectedCathyNames: [String] = ["Prince Lawlz", "Brandon Custer", "Jon Davis", "Chris Park", "Obama Presidententadf"]
    var clientConnectedCareGiverNames: [String] = ["Jae Kimepqrij", "Baby John", "Obama Presidententadf"]
    
    var clientConnectedCathysIds: [String] = [String]()
    var clientConnectedCareGiverIds: [String] = [String]()
    
    var nameButtonTappedRow: Int = -1
    var expandButtonTappedIndexPath: NSIndexPath? = nil
    
    var expandButtonTappedAfterViewAppears: Bool = false
    
    var numberOfTimesReloadDataIsCalled: Int = 0
    
    var originalRowHeights: [CGFloat] = [CGFloat]() // Depending on the number of connected care givers or cathys, the row of expanded cells will vary.
    var expandedRowHeights: [CGFloat] = [CGFloat]()
    
    let classNameForCloud = ClassNameForCloud()
    let officeConnectUserHelper = OfficeConnectUserHelper()

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
    
    func setToolBar() {
        
        self.toolBar.layer.borderWidth = 1.0
        self.toolBar.clipsToBounds = true
        self.toolBar.layer.borderColor = UIColor(red: 163.0/255.0, green: 163.0/255.0, blue: 163.0/255.0, alpha: 1.0).CGColor
        self.toolBar.layer.borderWidth = 1.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setSegmentedControlWidth()
        self.removeBottomLineFromNavigationBar()
        self.setToolBar()
        
        // Need to set the initial chosen segment for the segment control. If this is not present, it will cause a crash.
        self.selectedUserType = UserType.client
        
    }
    
    func queryConnectedUsersFromCloud(userType: UserType, completion: (querySuccessful: Bool, connectedUsers: [[String: String]]) -> Void) {
        
        for
        
        let query = PFQuery(className: self.classNameForCloud.getClassName(self.selectedUserType)!)
        query.getObjectInBackgroundWithId("xWMyZEGZ") {
            (gameScore: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let gameScore = gameScore {
                gameScore["cheatMode"] = true
                gameScore["score"] = 1338
                gameScore.saveInBackground()
            }
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        //self.expandButtonTappedAfterViewAppears = false
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.numberOfTimesReloadDataIsCalled = 0
        
        self.tableView.estimatedRowHeight = 70
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        var querySuccessCheck = QuerySuccessCheck()
        
        for userType in self.userTypes {
            self.officeConnectUserHelper.queryUsersAddedByOfficeUserFromCloud(userType) { (querySuccessful, users) -> Void in
                if querySuccessful {
                    if userType == UserType.client {
                        self.clientUsers = users
                        self.clientCheckedRows = [Bool](count: self.clientUsers.count, repeatedValue: false)
                        self.clientOfficeUserIds = self.officeConnectUserHelper.clientOfficeUserIds // This OfficeConnectUserHelper class queries clientOfficeUserIds and stores them in a class variable. Only get this, clientOfficeUserIds, value from the OfficeConnectUserHelper class AFTER officeConnectUserHelper.queryUsersAddedByOfficeUserFromCloud() is called.
                        querySuccessCheck.successfullyQueriedClientUsers = true
                    } else if userType == UserType.cathy {
                        self.cathyUsers = users
                        self.cathyCheckedRows = [Bool](count: self.cathyUsers.count, repeatedValue: false)
                        self.cathyOfficeUserIds = self.officeConnectUserHelper.cathyOfficeUserIds
                        querySuccessCheck.successfullyQueriedCathyUsers = true
                    } else if userType == UserType.careGiver {
                        self.careGiverUsers = users
                        self.careGiverCheckedRows = [Bool](count: self.careGiverUsers.count, repeatedValue: false)
                        self.careGiverOfficeUserIds = self.officeConnectUserHelper.careGiverOfficeUserIds
                        querySuccessCheck.successfullyQueriedCareGiverUsers = true
                    }
                    if querySuccessCheck.successfullyQueriedAllUsers() {
                        self.numberOfTimesReloadDataIsCalled++
                        self.tableView.reloadData()
                    }
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
    
    func setUsersForSelectedUserType(selectedUserType: UserType) {
       
        if selectedUserType == UserType.client {
            self.users = self.clientUsers
        } else if selectedUserType == UserType.cathy {
            self.users = self.cathyUsers
        } else if selectedUserType == UserType.careGiver {
            self.users = self.careGiverUsers
        }
        
    }
    
    func deleteRowForSelectedUserType(selectedUserType: UserType, indexPath: NSIndexPath) {
        
        self.officeConnectUserHelper.selectedUserType = self.selectedUserType // deleteUserFromOfficeUserInCloud needs the correct selectedUserType from this class to execute it's function properly.

        if selectedUserType == UserType.client {
            self.officeConnectUserHelper.deleteUserFromOfficeUserInCloud(self.clientUsers, officeUserIdsForUser: self.clientOfficeUserIds, indexPath: indexPath)
            self.clientUsers.removeAtIndex(indexPath.row)
        } else if selectedUserType == UserType.cathy {
            self.officeConnectUserHelper.deleteUserFromOfficeUserInCloud(self.cathyUsers, officeUserIdsForUser: self.cathyOfficeUserIds, indexPath: indexPath)
            self.cathyUsers.removeAtIndex(indexPath.row)
        } else if selectedUserType == UserType.careGiver {
            self.officeConnectUserHelper.deleteUserFromOfficeUserInCloud(self.careGiverUsers, officeUserIdsForUser: self.careGiverOfficeUserIds, indexPath: indexPath)
            self.careGiverUsers.removeAtIndex(indexPath.row)
        }

    }
    
    func setCheckedRowsForSelectedUserType(selectedUserType: UserType, rowChecked: Bool, indexPath: NSIndexPath) {
        
        if selectedUserType == UserType.client {
            self.clientCheckedRows[indexPath.row] = rowChecked
        } else if selectedUserType == UserType.cathy {
            self.cathyCheckedRows[indexPath.row] = rowChecked
        } else if selectedUserType == UserType.careGiver {
            self.careGiverCheckedRows[indexPath.row] = rowChecked
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .Checkmark {
                cell.accessoryType = .None
                self.setCheckedRowsForSelectedUserType(self.selectedUserType, rowChecked: false, indexPath: indexPath)
            } else {
                cell.accessoryType = .Checkmark
                self.setCheckedRowsForSelectedUserType(self.selectedUserType, rowChecked: true, indexPath: indexPath)
            }
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let originalHeight = UITableViewAutomaticDimension
        var expandedHeight: CGFloat = CGFloat(20.0 + (20.0 * Double(self.clientConnectedCathyNames.count)))
        
        if self.expandButtonTappedAfterViewAppears == true {
            expandedHeight = self.expandedRowHeights[indexPath.row]
        }
        
        let ip = indexPath
        if self.expandButtonTappedIndexPath != nil {
            if ip == self.expandButtonTappedIndexPath! {
                return expandedHeight
            } else {
                return originalHeight
            }
        } else {
            return originalHeight
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
        self.setUsersForSelectedUserType(self.selectedUserType)
        return self.users.count

    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? OfficeConnectUserTableViewCell {
            cell.nameButton.setTitle("", forState: UIControlState.Normal)
        }
        
    }
    
    func configureCellForUserType(cell: OfficeConnectUserTableViewCell, userType: UserType, indexPath: NSIndexPath) {
        self.setUsersForSelectedUserType(self.selectedUserType)
        
        cell.nameButton.setTitle(self.users[indexPath.row]["name"], forState: UIControlState.Normal)
        
        if self.users[indexPath.row]["notes"] == "" {
            //cell.notesTopSpaceLayoutConstraint.constant = 0
        } else {
            cell.notesTopSpaceLayoutConstraint.constant = 5
        }
        
        cell.notesLabel.text = self.users[indexPath.row]["notes"]
        
        if userType == UserType.client {
            cell.userIdLabel.text = self.users[indexPath.row]["objectId"]
        } else {
            cell.userIdLabel.text = self.users[indexPath.row]["email"]
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
    
    func configureCellForCheckedRows(cell: OfficeConnectUserTableViewCell, selectedUserType: UserType, indexPath: NSIndexPath) {
        
        var checkedRows: [Bool] = [Bool]()
        
        if selectedUserType == UserType.client {
            checkedRows = self.clientCheckedRows
        } else if selectedUserType == UserType.cathy {
            checkedRows = self.cathyCheckedRows
        } else if selectedUserType == UserType.careGiver {
            checkedRows = self.careGiverCheckedRows
        }
        
        if !checkedRows[indexPath.row] {
            cell.accessoryType = .None
        } else if checkedRows[indexPath.row] {
            cell.accessoryType = .Checkmark
        }
        
    }
    
   

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! OfficeConnectUserTableViewCell
        
        // The reason for self.expandButtonTapped == true is because self.rowHeights doesn't get initialized until expandButton is tapped. So without this check, it will cause the app to crash.
        if self.expandButtonTappedAfterViewAppears == true {

            cell.width = self.tableView.frame.width
            cell.height = self.originalRowHeights[indexPath.row]
            cell.removeUserTypeLabels()
            cell.createCareGiverLabel()
            cell.createCathyLabel()
            cell.removeConnectedUserNameButtons()
            cell.createConnectedCareGiverNameButtons(self.clientConnectedCareGiverNames)
            cell.createConnectedCathyNameButtons(self.clientConnectedCathyNames)
            
        }
        
        
        
        self.configureCellForUserType(cell, userType: self.selectedUserType, indexPath: indexPath)
        self.configureCellContentAnimation(cell)
        self.configureCellForCheckedRows(cell, selectedUserType: self.selectedUserType, indexPath: indexPath)
        
        return cell
        
    }
    
    @IBAction func nameButtonTapped(sender: AnyObject) {
        
        let nameButton = sender as! UIButton
        let superView = nameButton.superview!
        let officeConnectUserTableViewCell = superView.superview as! OfficeConnectUserTableViewCell
        let indexPath = tableView.indexPathForCell(officeConnectUserTableViewCell)
        self.nameButtonTappedRow = (indexPath?.row)!
        
    }
    
    @IBAction func expandButtonTapped(sender: AnyObject) {
        
        var originalRowHeights: [CGFloat] = [CGFloat]()
        var expandedRowHeights: [CGFloat] = [CGFloat]()
        
        self.expandButtonTappedAfterViewAppears = true
        
        // I use the code below to get the row height for each cell so that xcode knows where to add the connected names, that is, right below the notes in the cell. I can't use the row height in the cell for row index path because it is not returning the correct row height. In order to get the correct heights, I have to put the function in the expandButtonTapped function.
        for visibleCell in tableView.visibleCells {
            let rowHeight = CGRectGetHeight(visibleCell.bounds)
            originalRowHeights.append(rowHeight)
        }
        
        for originalRowHeight in originalRowHeights {
            var newHeight: CGFloat
            if self.clientConnectedCathyNames.count > self.clientConnectedCareGiverNames.count {
                newHeight = originalRowHeight + CGFloat(20.0 + (20.0 * Double(self.clientConnectedCathyNames.count)))
                expandedRowHeights.append(newHeight)
            } else if self.clientConnectedCathyNames.count <= self.clientConnectedCareGiverNames.count {
                newHeight = originalRowHeight + CGFloat(20.0 + (20.0 * Double(self.clientConnectedCareGiverNames.count)))
                expandedRowHeights.append(newHeight)
            }
        }
        
        self.originalRowHeights = originalRowHeights
        self.expandedRowHeights = expandedRowHeights
        
        originalRowHeights.removeAll()
        expandedRowHeights.removeAll()
        
        let expandButton = sender as! UIButton
        let superView = expandButton.superview!
        let officeConnectUserTableViewCell = superView.superview as! OfficeConnectUserTableViewCell
        let indexPath = tableView.indexPathForCell(officeConnectUserTableViewCell)

        switch self.expandButtonTappedIndexPath {
        case nil:
            self.expandButtonTappedIndexPath = indexPath
        default:
            if self.expandButtonTappedIndexPath! == indexPath {
                self.expandButtonTappedIndexPath = nil
            } else {
                self.expandButtonTappedIndexPath = indexPath
            }
        }

        self.tableView.beginUpdates()
        self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
        self.tableView.endUpdates()
        
        // It will continue to append the row heights so the elements in the array does not reflect the actual row heights of the rows in the table view. Only by removing all, could we get the correct values.
    }

    
    func presentAlertControllerWithMessage(message: String) {
        
        let alertController = UIAlertController(title: "", message: "\(message)", preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func correctNumberOfUsersAreChecked() -> Bool {
        
        var clientNumberOfRowsChecked: Int = 0
        var oneClientUserIsChecked: Bool = false
        for var row = 0; row < self.clientCheckedRows.count; row++ {
            if self.clientCheckedRows[row] == true {
                clientNumberOfRowsChecked++
            }
        }
        
        var cathyNumberOfRowsChecked: Int = 0
        var atLeastOneCathyUserIsChecked: Bool = false
        for var row = 0; row < self.cathyCheckedRows.count; row++ {
            if self.cathyCheckedRows[row] == true {
                cathyNumberOfRowsChecked++
            }
        }
        
        var careGiverNumberOfRowsChecked: Int = 0
        var atLeastOneCareGiverUserIsChecked: Bool = false
        for var row = 0; row < self.careGiverCheckedRows.count; row++ {
            if self.careGiverCheckedRows[row] == true {
                careGiverNumberOfRowsChecked++
            }
        }
        
        if clientNumberOfRowsChecked == 1 {
            oneClientUserIsChecked = true
            
            if cathyNumberOfRowsChecked > 0 {
                atLeastOneCathyUserIsChecked = true
                
                if careGiverNumberOfRowsChecked > 0 {
                    atLeastOneCareGiverUserIsChecked = true
                } else {
                    self.presentAlertControllerWithMessage("Please select at least one care giver")
                }
                
            } else {
                self.presentAlertControllerWithMessage("Please select at least one cathy")
            }
            
        } else {
            self.presentAlertControllerWithMessage("Please select one client")
        }
        
        if oneClientUserIsChecked && atLeastOneCathyUserIsChecked && atLeastOneCareGiverUserIsChecked {
            return true
        } else {
            return false
        }
        
    }
    
    func setUserCheckedRowsForSelectedUserType(selectedUserType: UserType) {
        
        if selectedUserType == UserType.client {
            self.userCheckedRows = self.clientCheckedRows
        } else if selectedUserType == UserType.cathy {
            self.userCheckedRows = self.cathyCheckedRows
        } else if selectedUserType == UserType.careGiver {
            self.userCheckedRows = self.careGiverCheckedRows
        }
        
    }
    
    func getCheckedUsersObjectIds(userType: UserType) -> [String] {
        
        self.setUserCheckedRowsForSelectedUserType(userType)
        self.setUsersForSelectedUserType(userType)
        var objectIds: [String] = [String]()
        var userNumberOfRowsChecked: Int = 0
        for var row = 0; row < self.userCheckedRows.count; row++ {
            if self.userCheckedRows[row] == true {
                objectIds.append(self.users[row]["objectId"]!)
                userNumberOfRowsChecked++
            }
        }

        return objectIds
    }
    
    
    @IBAction func connectButtonTapped(sender: AnyObject) {

        if self.correctNumberOfUsersAreChecked() {
            
            let checkedClientObjectId: [String] = self.getCheckedUsersObjectIds(UserType.client)
            let checkedCathysObjectIds: [String]  = self.getCheckedUsersObjectIds(UserType.cathy)
            let checkedCareGiversObjectIds: [String] = self.getCheckedUsersObjectIds(UserType.careGiver)
            
            print(checkedClientObjectId)
            print(checkedCathysObjectIds)
            print(checkedCareGiversObjectIds)
            self.officeConnectUserHelper.selectedUserType = self.selectedUserType // Once again, necessary for self.connectUsersForUserTypeInCloud to work correctly.
            for userType in userTypes {
                self.officeConnectUserHelper.connectUsersForUserTypeInCloud(userType, checkedClientObjectId: checkedClientObjectId, checkedCathysObjectIds: checkedCathysObjectIds, checkedCareGiversObjectIds: checkedCareGiversObjectIds)
            }
            
        }
        
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
            
        } else if segue.identifier == "officeConnectUsersToUserProfile" {
            if let userProfileViewController = segue.destinationViewController as? UserProfileViewController {
                self.setUsersForSelectedUserType(self.selectedUserType)
                userProfileViewController.user = self.users[self.nameButtonTappedRow]
                userProfileViewController.selectedUserType = self.selectedUserType
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


