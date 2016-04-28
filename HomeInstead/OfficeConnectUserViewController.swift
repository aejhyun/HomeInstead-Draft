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
    
    var userNames: [String] = [String]()
    var clientNames: [String] = [String]()
    var cathyNames: [String] = [String]()
    var careGiverNames: [String] = [String]()
    
    var userObjectIds: [String] = [String]()
    var clientObjectIds: [String] = [String]()
    var cathyObjectIds: [String] = [String]()
    var careGiverObjectIds: [String] = [String]()
    
    var userNotes: [String] = [String]()
    var clientNotes: [String] = [String]()
    var cathyNotes: [String] = [String]()
    var careGiverNotes: [String] = [String]()
    
    var clientOfficeUserIds: [[String]] = [[String]]() // These variables are to hold the ids of the office users who added the non office user.
    var cathyOfficeUserIds: [[String]] = [[String]]()
    var careGiverOfficeUserIds: [[String]] = [[String]]()
    
    var userCheckedRows: [Bool] = [Bool]()
    var clientCheckedRows: [Bool] = [Bool]()
    var cathyCheckedRows: [Bool] = [Bool]()
    var careGiverCheckedRows: [Bool] = [Bool]()
    
    var clientConnectedCathysIds: [[String]] = [[String]]()
    var clientConnectedCareGiverIds: [[String]] = [[String]]()
    
    var clientConnectedCathyNames: [String] = ["Prince Lawlz", "Brandon Custer", "Jon Davis", "Chris Park", "Obama Presidententadf"]
    var clientConnectedCareGiverNames: [String] = ["Jae Kimepqrij", "Baby John", "Obama Presidententadf"]
    
    var nameButtonTappedRow: Int = -1
    var expandButtonTappedIndexPath: NSIndexPath? = nil
    
    var expandButtonTappedAfterViewAppears: Bool = false
    
    var numberOfTimesReloadDataIsCalled: Int = 0
    
    var originalRowHeights: [CGFloat] = [CGFloat]() // Depending on the number of connected care givers or cathys, the row of expanded cells will vary.
    var expandedRowHeights: [CGFloat] = [CGFloat]()
    
    var spaceBetweenUserLabelsAndUsersInExpandedCell: CGFloat = 20.0 // When a row is expanded there are two labels, Care Giver(s) and Client(s) indicating which rows of users are of which user Type. And this variable will determine the space between the two lables and the actual users connected to the clients.
    var spaceBetweenUsersInExpandedCell: CGFloat = 20.0
    
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
    
    override func viewWillAppear(animated: Bool) {
        
        self.numberOfTimesReloadDataIsCalled = 0
        
        self.tableView.estimatedRowHeight = 70
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        var querySuccessCheck = QuerySuccessCheck()

        for userType in self.userTypes {
            
            self.officeConnectUserHelper.attemptQueryingUsersAddedByOfficeUserFromCloud(userType, completion: { (querySuccessful, userNames, userObjectIds, userNotes, clientConnectedCathysIds, clientConnectedGiverIds, userOfficeIds) -> Void in
                if querySuccessful {
                    if userType == UserType.client {
                        self.clientNames = userNames!
                        self.clientObjectIds = userObjectIds!
                        self.clientNotes = userNotes!
                        self.clientOfficeUserIds = userOfficeIds!
                        self.clientCheckedRows = [Bool](count: self.clientNames.count, repeatedValue: false)
                        self.clientConnectedCathysIds = clientConnectedCathysIds!
                        self.clientConnectedCareGiverIds = clientConnectedGiverIds!
                        querySuccessCheck.successfullyQueriedClientUsers = true
                    } else if userType == UserType.cathy {
                        self.cathyNames = userNames!
                        self.cathyObjectIds = userObjectIds!
                        self.cathyNotes = userNotes!
                        self.cathyOfficeUserIds = userOfficeIds!
                        self.cathyCheckedRows = [Bool](count: self.cathyNames.count, repeatedValue: false)
                        querySuccessCheck.successfullyQueriedCathyUsers = true
                    } else if userType == UserType.careGiver {
                        self.careGiverNames = userNames!
                        self.careGiverObjectIds = userObjectIds!
                        self.careGiverNotes = userNotes!
                        self.careGiverOfficeUserIds = userOfficeIds!
                        self.careGiverCheckedRows = [Bool](count: self.careGiverNames.count, repeatedValue: false)
                        querySuccessCheck.successfullyQueriedCareGiverUsers = true
                    }
                    if querySuccessCheck.successfullyQueriedAllUsers() {
                        self.numberOfTimesReloadDataIsCalled++
                        self.tableView.reloadData()
                    }
                }
            })
            
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
    
    func setUserNamesForSelectedUserType(selectedUserType: UserType) {
       
        if selectedUserType == UserType.client {
            self.userNames = self.clientNames
        } else if selectedUserType == UserType.cathy {
            self.userNames = self.cathyNames
        } else if selectedUserType == UserType.careGiver {
            self.userNames = self.careGiverNames
        }
        
    }
    
    func setUserNotesForSelectedUserType(selectedUserType: UserType) {
        
        if selectedUserType == UserType.client {
            self.userNotes = self.clientNotes
        } else if selectedUserType == UserType.cathy {
            self.userNotes = self.cathyNotes
        } else if selectedUserType == UserType.careGiver {
            self.userNotes = self.careGiverNotes
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
    
    func setUserObjectIdsForSelectedUserType(selectedUserType: UserType) {
        
        if selectedUserType == UserType.client {
            self.userObjectIds = self.clientObjectIds
        } else if selectedUserType == UserType.cathy {
            self.userObjectIds = self.cathyObjectIds
        } else if selectedUserType == UserType.careGiver {
            self.userObjectIds = self.careGiverObjectIds
        }
    }
    
    func deleteRowForSelectedUserType(selectedUserType: UserType, indexPath: NSIndexPath) {
        
        self.officeConnectUserHelper.selectedUserType = self.selectedUserType // deleteUserFromOfficeUserInCloud needs the correct selectedUserType from this class to execute it's function properly.

        if selectedUserType == UserType.client {
            self.officeConnectUserHelper.deleteUserFromOfficeUserInCloud(self.clientObjectIds, officeUserIdsForUser: self.clientOfficeUserIds, indexPath: indexPath)
            self.clientNames.removeAtIndex(indexPath.row)
            self.clientObjectIds.removeAtIndex(indexPath.row)
            self.clientNotes.removeAtIndex(indexPath.row)
        } else if selectedUserType == UserType.cathy {
            self.officeConnectUserHelper.deleteUserFromOfficeUserInCloud(self.cathyObjectIds, officeUserIdsForUser: self.cathyOfficeUserIds, indexPath: indexPath)
            self.cathyNames.removeAtIndex(indexPath.row)
            self.cathyObjectIds.removeAtIndex(indexPath.row)
            self.cathyNotes.removeAtIndex(indexPath.row)
        } else if selectedUserType == UserType.careGiver {
            self.officeConnectUserHelper.deleteUserFromOfficeUserInCloud(self.careGiverObjectIds, officeUserIdsForUser: self.careGiverOfficeUserIds, indexPath: indexPath)
            self.careGiverNames.removeAtIndex(indexPath.row)
            self.careGiverObjectIds.removeAtIndex(indexPath.row)
            self.careGiverNotes.removeAtIndex(indexPath.row)
        }
        
        
    }
    
    func changeUserCheckedRowsForSelectedUserType(selectedUserType: UserType, rowChecked: Bool, indexPath: NSIndexPath) {
        
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
                self.changeUserCheckedRowsForSelectedUserType(self.selectedUserType, rowChecked: false, indexPath: indexPath)
            } else {
                cell.accessoryType = .Checkmark
                self.changeUserCheckedRowsForSelectedUserType(self.selectedUserType, rowChecked: true, indexPath: indexPath)
            }
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let originalHeight = UITableViewAutomaticDimension
        var expandedHeight: CGFloat = CGFloat(20.0 + (20.0 * Double(self.clientConnectedCathyNames.count)))
        
        // The reason for indexPath.row < self.tableView.visibleCells.count is because if self.expandedRowHeights[indexPath.row] only holds row heights of visible cells not cells that have gone off the screen. And since indexPath will call as many times as it is specified  numberOfRowsInSection delegate function, it will cause the app to crash.
        if self.expandButtonTappedAfterViewAppears == true  && indexPath.row < self.tableView.visibleCells.count {
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
        self.setUserNamesForSelectedUserType(self.selectedUserType)
        return self.userNames.count

    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? OfficeConnectUserTableViewCell {
            cell.nameButton.setTitle("", forState: UIControlState.Normal)
        }
        
    }
    
    func configureCellForUserType(cell: OfficeConnectUserTableViewCell, userType: UserType, indexPath: NSIndexPath) {
        self.setUserNamesForSelectedUserType(self.selectedUserType)
        self.setUserNotesForSelectedUserType(self.selectedUserType)
        cell.nameButton.setTitle(self.userNames[indexPath.row], forState: UIControlState.Normal)
        if self.userNotes[indexPath.row] == "" {
            cell.notesLabel.text = "No notes"
        } else {
            cell.notesLabel.text = self.userNotes[indexPath.row]
        }
    }
    
    func configureCellContentAnimation(cell: OfficeConnectUserTableViewCell) {
        
        cell.nameButton.alpha = 0.0
        cell.notesLabel.alpha = 0.0
        
        if self.numberOfTimesReloadDataIsCalled == 1 {
            cell.nameButton.alpha = 1.0
            cell.notesLabel.alpha = 1.0
            
        }
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            cell.nameButton.alpha = 1.0
        })
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            cell.notesLabel.alpha = 1.0
        })
        
    }
    
    func configureCellForCheckedRows(cell: OfficeConnectUserTableViewCell, selectedUserType: UserType, indexPath: NSIndexPath) {
        
        self.setUserCheckedRowsForSelectedUserType(self.selectedUserType)
        
        if !self.userCheckedRows[indexPath.row] {
            cell.accessoryType = .None
        } else {
            cell.accessoryType = .Checkmark
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! OfficeConnectUserTableViewCell
        
        // The reason for self.expandButtonTapped == true is because self.rowHeights doesn't get initialized until expandButton is tapped. So without this check, it will cause the app to crash.
        if self.expandButtonTappedAfterViewAppears == true && indexPath.row < self.tableView.visibleCells.count {

            cell.width = self.tableView.frame.width
            cell.height = self.originalRowHeights[indexPath.row]
            cell.spaceBetweenUserLabelsAndUsers = self.spaceBetweenUserLabelsAndUsersInExpandedCell
            cell.spaceBetweenUsers = self.spaceBetweenUsersInExpandedCell
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
        for visibleCell in self.tableView.visibleCells {
            let rowHeight = CGRectGetHeight(visibleCell.bounds)
            originalRowHeights.append(rowHeight)
        }
    
        for originalRowHeight in originalRowHeights {
            var newHeight: CGFloat
            if self.clientConnectedCathyNames.count > self.clientConnectedCareGiverNames.count {
                newHeight = originalRowHeight + CGFloat(self.spaceBetweenUserLabelsAndUsersInExpandedCell + (self.spaceBetweenUsersInExpandedCell * CGFloat(self.clientConnectedCathyNames.count)))
                expandedRowHeights.append(newHeight)
            } else if self.clientConnectedCathyNames.count <= self.clientConnectedCareGiverNames.count {
                newHeight = originalRowHeight + CGFloat(self.spaceBetweenUserLabelsAndUsersInExpandedCell + (self.spaceBetweenUsersInExpandedCell * CGFloat(self.clientConnectedCareGiverNames.count)))
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
    
    func getCheckedUserObjectIds(userType: UserType) -> [String] {
        
        self.setUserCheckedRowsForSelectedUserType(userType)
        self.setUserObjectIdsForSelectedUserType(userType)
        
        var objectIds: [String] = [String]()
        var userNumberOfRowsChecked: Int = 0
        for var row = 0; row < self.userCheckedRows.count; row++ {
            if self.userCheckedRows[row] == true {
                objectIds.append(self.userObjectIds[row])
                userNumberOfRowsChecked++
            }
        }

        return objectIds
    }
    
    func getCheckedUserNames(userType: UserType) -> [String] {
        
        self.setUserCheckedRowsForSelectedUserType(userType)
        self.setUserNamesForSelectedUserType(userType)
        
        var names: [String] = [String]()
        var userNumberOfRowsChecked: Int = 0
        for var row = 0; row < self.userCheckedRows.count; row++ {
            if self.userCheckedRows[row] == true {
                names.append(self.userNames[row])
                userNumberOfRowsChecked++
            }
        }
        
        return names
    
    }
    
    @IBAction func connectButtonTapped(sender: AnyObject) {

        if self.correctNumberOfUsersAreChecked() {
            
            let checkedClientObjectIds: [String] = self.getCheckedUserObjectIds(UserType.client)
            let checkedCathyObjectIds: [String]  = self.getCheckedUserObjectIds(UserType.cathy)
            let checkedCareGiverObjectIds: [String] = self.getCheckedUserObjectIds(UserType.careGiver)
            
            let checkedClientNames: [String] = self.getCheckedUserNames(UserType.client)
            let checkedCathysNames: [String]  = self.getCheckedUserNames(UserType.cathy)
            let checkedCareGiverNames: [String] = self.getCheckedUserNames(UserType.careGiver)

            for userType in userTypes {
                self.officeConnectUserHelper.connectUserIdsForUserTypeInCloud(userType, checkedClientObjectIds: checkedClientObjectIds, checkedCathyObjectIds: checkedCathyObjectIds, checkedCareGiverObjectIds: checkedCareGiverObjectIds, checkedClientNames: checkedClientNames, checkedCathyNames: checkedCathysNames, checkedCareGiverNames: checkedCareGiverNames)
                
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
                self.setUserObjectIdsForSelectedUserType(self.selectedUserType)
                userProfileViewController.userObjectId = self.userObjectIds[self.nameButtonTappedRow]
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


