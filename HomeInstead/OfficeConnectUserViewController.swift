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
    
    var careGiverCheckedRow: Int = -1
    var clientCheckedRow: Int = -1
    var cathyCheckedRows: [Bool] = [Bool]()
    
    var connectedObjectIds: [Dictionary<String, [String]>] = [Dictionary<String, [String]>]()
    
    var userObjectIdsAndNames: [String: String] = [String: String]() // I am using the objectIds to get the names associated with those objectIds so that when I am displaying the names for the connected user, I don't have to query both the objectIds and names. Also, it ensure that displaying correct connected client and cathy names is not contingent upon the order of the queries.
    var cathyObjectIdsAndUserIds: [String: String] = [String: String]()
    
    var userTypeForConnectedName: UserType! // I wish I didn't have to use this variable but the button's sender isn't working as it should.
    
    var nameButtonSelectedRow: Int = -1
    var expandButtonTappedIndexPath: NSIndexPath? = nil
    var clientSelectedRowIndexPath: NSIndexPath? = nil
    var careGiverSelectedRowIndexPath: NSIndexPath? = nil

    var numberOfTimesReloadDataIsCalled: Int = 0
    
    var originalRowHeight: CGFloat = 43.5 // Depending on the number of connected care givers or cathys, the row of expanded cells will vary.
    var expandedRowHeights: [CGFloat] = [CGFloat]()
    
    var spaceBetweenUserLabelsAndUsersInExpandedCell: CGFloat = 20.0 // When a row is expanded there are two labels, Care Giver(s) and Client(s) indicating which rows of users are of which user Type. And this variable will determine the space between the two lables and the actual users connected to the clients.
    var spaceBetweenCathysInExpandedCell: CGFloat = 20.0
    var spaceBetweenCathyGroupsInExpandedCell: CGFloat = 10.0
    
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
    
    func setTabBarTopBorderLine() {
        
        let viewFrame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 1.0)
        let tabBarTopHairLine: UIView = UIView(frame: viewFrame)
        tabBarTopHairLine.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(tabBarTopHairLine)
        
        self.tabBarController!.tabBar.addSubview(tabBarTopHairLine)
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
    
    func setUserObjectIdsForSelectedUserType(selectedUserType: UserType) {
        
        if selectedUserType == UserType.client {
            self.userObjectIds = self.clientObjectIds
        } else if selectedUserType == UserType.cathy {
            self.userObjectIds = self.cathyObjectIds
        } else if selectedUserType == UserType.careGiver {
            self.userObjectIds = self.careGiverObjectIds
        }
    }
    
    func deleteRowForCareGiverHelper(indexPath: NSIndexPath, keepConnections: Bool) {
        
        self.officeConnectUserHelper.deleteUserFromOfficeUserInCloud(self.selectedUserType, keepConnections: keepConnections, userObjectId: self.careGiverObjectIds[indexPath.row], officeUserIdsForUser: self.careGiverOfficeUserIds[indexPath.row])
        
        self.careGiverNames.removeAtIndex(indexPath.row)
        self.careGiverObjectIds.removeAtIndex(indexPath.row)
        self.careGiverNotes.removeAtIndex(indexPath.row)
        self.connectedObjectIds.removeAtIndex(indexPath.row)
        
        if self.careGiverCheckedRow == indexPath.row {
            self.careGiverCheckedRow = -1
        } else if self.careGiverCheckedRow > indexPath.row {
            self.careGiverCheckedRow -= 1
        }
        
    }
    
    func deleteRowForCareGiver(indexPath: NSIndexPath, completion: (deleteRowsAtIndexPath: Bool) -> Void) {
        
        let alertController = UIAlertController(title: "", message: "Please select from one of the options:", preferredStyle: UIAlertControllerStyle.Alert)
        
        var alertAction = UIAlertAction(title: "Keep Connections", style: .Default, handler: { (UIAlertAction) -> Void in
            
            self.deleteRowForCareGiverHelper(indexPath, keepConnections: true)
            completion(deleteRowsAtIndexPath: true)
        })
        
        alertController.addAction(alertAction)
        
        alertAction = UIAlertAction(title: "Disconnect", style: .Default, handler: { (UIAlertAction) -> Void in
            
            self.deleteRowForCareGiverHelper(indexPath, keepConnections: false)
            completion(deleteRowsAtIndexPath: true)
        })
        
        alertController.addAction(alertAction)

        alertAction = UIAlertAction(title: "Cancel", style: .Default, handler: { (UIAlertAction) -> Void in
            completion(deleteRowsAtIndexPath: false)
        })
       
        alertController.addAction(alertAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func deleteRowForClientAndCathy(indexPath: NSIndexPath, completion: (deleteRowsAtIndexPath: Bool) -> Void) {
        
        var clientObjectIds: [String] = [String]()
        var cathyObjectIds: [String] = [String]()
        
    


    
        
//        if self.connectedObjectIds.count != 0 {
//            for (connectedClientObjectId, connectedCathyObjectIds) in self.connectedObjectIds[indexPath.row] {
// 
//                clientObjectIds.append(connectedClientObjectId)
//                cathyObjectIds.appendContentsOf(connectedCathyObjectIds)
//            }
//        }
        
        print(self.connectedObjectIds)
        
        if self.connectedObjectIds.count != 0 {
            for (connectedClientObjectIds) in self.connectedObjectIds {
                
                for (connectedClientObjectId, connectedCathyObjectIds) in connectedClientObjectIds {
            
                    clientObjectIds.append(connectedClientObjectId)
                    for connectedCathyObjectId in connectedCathyObjectIds {
                        if !cathyObjectIds.contains(connectedCathyObjectId) {
                            cathyObjectIds.append(connectedCathyObjectId)
                        }
                        
                    }
                }
                
            }
        }
        
        if selectedUserType == UserType.client {
            
            if clientObjectIds.contains(self.clientObjectIds[indexPath.row]) {
                
                self.presentBasicAlertControllerWithMessage("Cannot delete client because of the client's current connection(s)")
                completion(deleteRowsAtIndexPath: false)
            } else {
                
                self.officeConnectUserHelper.deleteUserFromOfficeUserInCloud(self.selectedUserType, keepConnections: true, userObjectId: self.clientObjectIds[indexPath.row], officeUserIdsForUser: self.clientOfficeUserIds[indexPath.row])
                self.clientNames.removeAtIndex(indexPath.row)
                self.clientObjectIds.removeAtIndex(indexPath.row)
                self.clientNotes.removeAtIndex(indexPath.row)
                
                if self.clientCheckedRow == indexPath.row {
                    self.clientCheckedRow = -1
                } else if self.clientCheckedRow > indexPath.row {
                    self.clientCheckedRow -= 1
                }
                completion(deleteRowsAtIndexPath: true)
        
            }
            
        } else if selectedUserType == UserType.cathy {
            
            if cathyObjectIds.contains(self.cathyObjectIds[indexPath.row]) {
                
                self.presentBasicAlertControllerWithMessage("Cannot delete cathy because of the cathy's current connection(s)")
                completion(deleteRowsAtIndexPath: false)
                
            } else {
                
                self.officeConnectUserHelper.deleteUserFromOfficeUserInCloud(self.selectedUserType, keepConnections: true, userObjectId: self.cathyObjectIds[indexPath.row], officeUserIdsForUser: self.cathyOfficeUserIds[indexPath.row])
                self.cathyNames.removeAtIndex(indexPath.row)
                self.cathyObjectIds.removeAtIndex(indexPath.row)
                self.cathyNotes.removeAtIndex(indexPath.row)
                self.cathyCheckedRows.removeAtIndex(indexPath.row)
                completion(deleteRowsAtIndexPath: true)
            }
            
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
        
        cell.expandButton.hidden = true
        
        if self.selectedUserType == UserType.careGiver {
            if self.connectedObjectIds[indexPath.row].count == 0 {
                cell.expandButton.hidden = true
            } else if indexPath == self.expandButtonTappedIndexPath {
                cell.expandButton.hidden = false
                cell.clientLabel.hidden = false
                cell.cathyLabel.hidden = false
                for nameButton in cell.nameButtons {
                    nameButton.hidden = false
                }
                cell.expandButton.setTitle("(\(self.connectedObjectIds[indexPath.row].count))", forState: UIControlState.Normal)
            } else {
                cell.expandButton.hidden = false
                cell.clientLabel.hidden = true
                cell.cathyLabel.hidden = true
                for nameButton in cell.nameButtons {
                    nameButton.hidden = true
                }
                cell.expandButton.setTitle("(\(self.connectedObjectIds[indexPath.row].count))", forState: UIControlState.Normal)
            }
        } else {
            cell.expandButton.hidden = true
            cell.clientLabel.hidden = true
            cell.cathyLabel.hidden = true
            for nameButton in cell.nameButtons {
                nameButton.hidden = true
            }
            
        }
        
    }
    
    func configureCellContentAnimation(cell: OfficeConnectUserTableViewCell) {
        
        cell.nameButton.alpha = 0.0
        cell.notesLabel.alpha = 0.0
        cell.expandButton.alpha = 0.0
        
        if self.numberOfTimesReloadDataIsCalled == 1 {
            cell.nameButton.alpha = 1.0
            cell.notesLabel.alpha = 1.0
            cell.expandButton.alpha = 1.0
            
        }
        
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            cell.nameButton.alpha = 1.0
        })
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            cell.notesLabel.alpha = 1.0
        })
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            cell.expandButton.alpha = 1.0
        })
        
    }
    
    func configureCellForCheckedRows(cell: OfficeConnectUserTableViewCell, selectedUserType: UserType, indexPath: NSIndexPath) {
        
        if self.selectedUserType == UserType.careGiver {
        
            if indexPath.row == self.careGiverCheckedRow {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
            
        } else if self.selectedUserType == UserType.client {

            if indexPath.row == self.clientCheckedRow {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
            
        } else if self.selectedUserType == UserType.cathy {
            
            if !self.cathyCheckedRows[indexPath.row] {
                cell.accessoryType = .None
            } else {
                cell.accessoryType = .Checkmark
            }
            
        }

    }
    
    func presentBasicAlertControllerWithMessage(message: String) {
        
        let alertController = UIAlertController(title: "", message: "\(message)", preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func correctNumberOfUsersAreCheckedForConnecting() -> Bool {
        
        if self.careGiverCheckedRow == -1 {
            self.presentBasicAlertControllerWithMessage("Please select a care giver to connect")
            return false
        } else if self.clientCheckedRow == -1 {
            self.presentBasicAlertControllerWithMessage("Please select a client to connect")
            return false
        } else if !self.cathyCheckedRows.contains(true) {
            self.presentBasicAlertControllerWithMessage("Please select at least one cathy to connect")
            return false
        }
        
        if self.careGiverCheckedRow != -1 && self.clientCheckedRow != -1 && self.cathyCheckedRows.contains(true) {
            return true
        }
        
        return false
    }
    
    func getCheckedUserObjectIds(userType: UserType) -> [String]? {
        
        var objectIds: [String] = [String]()
        
        if userType == UserType.careGiver {
            objectIds.append(self.careGiverObjectIds[self.careGiverCheckedRow])
            return objectIds
        } else if userType == UserType.client {
            objectIds.append(self.clientObjectIds[self.clientCheckedRow])
            return objectIds
        } else if userType == UserType.cathy {
            
            for var row = 0; row < self.cathyCheckedRows.count; row++ {
                if self.cathyCheckedRows[row] == true {
                    objectIds.append(self.cathyObjectIds[row])
                }
            }

            return objectIds
        }
        
        return nil
        
    }
    
    func setAccessoryTypeForSelectedUserTypeAtIndexPath(selectedUserType: UserType, tableView: UITableView, indexPath: NSIndexPath) {
        
        if self.selectedUserType == UserType.careGiver {
            
            self.careGiverCheckedRow = indexPath.row
            for var row: Int = 0; row < self.careGiverNames.count; row++ {
                if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) {
                    if self.careGiverCheckedRow == row {
                        if cell.accessoryType == .Checkmark {
                            cell.accessoryType = .None
                            self.careGiverCheckedRow = -1
                        } else {
                            cell.accessoryType = .Checkmark
                        }
                    } else {
                        cell.accessoryType = .None
                    }
                }
            }
            
        } else if self.selectedUserType == UserType.client {
            
            self.clientCheckedRow = indexPath.row
            for var row: Int = 0; row < self.clientNames.count; row++ {
                if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) {
                    if self.clientCheckedRow == row {
                        if cell.accessoryType == .Checkmark {
                            cell.accessoryType = .None
                            self.clientCheckedRow = -1
                        } else {
                            cell.accessoryType = .Checkmark
                        }
                    } else {
                        cell.accessoryType = .None
                    }
                }
            }
            
        } else if self.selectedUserType == UserType.cathy {
            
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                if cell.accessoryType == .Checkmark {
                    cell.accessoryType = .None
                    self.cathyCheckedRows[indexPath.row] = false
                } else {
                    cell.accessoryType = .Checkmark
                    self.cathyCheckedRows[indexPath.row] = true
                }
            }
            
            
        }
        
    }
    
    func setExpandedRowHeights() {
        
        var expandedRowHeights: [CGFloat] = [CGFloat]()
        
        for var row: Int = 0; row < connectedObjectIds.count; row++ {
            var newRowHeight: CGFloat = 0.0
            var numberOfClients: Int = 0
            var numberOfCathys: Int = 0
            
            numberOfClients += self.connectedObjectIds[row].count
        
            for (clientObjectId, _) in self.connectedObjectIds[row] {
                numberOfCathys += self.connectedObjectIds[row][clientObjectId]!.count
            }

            newRowHeight = self.originalRowHeight + self.spaceBetweenUserLabelsAndUsersInExpandedCell + (CGFloat(numberOfClients - 1) * self.spaceBetweenCathyGroupsInExpandedCell) + (CGFloat(numberOfCathys) * self.spaceBetweenCathysInExpandedCell)
            expandedRowHeights.append(newRowHeight)
        }

        self.expandedRowHeights = expandedRowHeights
        expandedRowHeights.removeAll()
        
    }
    
    func getObjectIdsToBeConnected(checkedClientObjectId: String, checkedCathyObjectIds: [String]) -> Dictionary<String, [String]> {
        
        var connectedObjectIds = self.connectedObjectIds[self.careGiverCheckedRow]
        
        var clientObjectIdIsAlreadyConnected: Bool = false
        
        for (clientName, _) in connectedObjectIds {
            if clientName == checkedClientObjectId {
                clientObjectIdIsAlreadyConnected = true
                break
            }
        }
        
        if clientObjectIdIsAlreadyConnected == true {
            
            for checkedCathyName in checkedCathyObjectIds {
                if !connectedObjectIds[checkedClientObjectId]!.contains(checkedCathyName) {
                    connectedObjectIds[checkedClientObjectId]!.append(checkedCathyName)
                }
            }
            return connectedObjectIds
            
        } else {
            connectedObjectIds[checkedClientObjectId] = checkedCathyObjectIds
            return connectedObjectIds
        }
        
        
    }
    
    func getObjectIdsToBeConnectedAfterTheirDisconnection(checkedClientObjectId: String, checkedCathyObjectIds: [String]) -> Dictionary<String, [String]>? {
        
        var connectedClientObjectIds = self.connectedObjectIds[self.careGiverCheckedRow]
        
        var clientObjectIdIsConnected: Bool = false
        
        var checkedCathyObjectIds = checkedCathyObjectIds
        
        for (clientObjectId, _) in connectedClientObjectIds {
            if clientObjectId == checkedClientObjectId {
                clientObjectIdIsConnected = true
                break
            }
        }
        
        if clientObjectIdIsConnected == true {
            
            if checkedCathyObjectIds.count == 0 {
                connectedClientObjectIds.removeValueForKey(checkedClientObjectId)
                return connectedClientObjectIds
            }
            
            var connectedCathyObjectIds = connectedClientObjectIds[checkedClientObjectId]!
            
            for var row: Int = 0; row < checkedCathyObjectIds.count; row++ {
                if connectedCathyObjectIds.contains(checkedCathyObjectIds[row]) {
                    if connectedCathyObjectIds.count == 1 {
                        self.presentBasicAlertControllerWithMessage("A client must be connected to at least one cathy")
                        return nil
                    }
                    connectedCathyObjectIds = connectedCathyObjectIds.filter() {$0 != checkedCathyObjectIds[row]}
                }
            }
            
            connectedClientObjectIds[checkedClientObjectId] = connectedCathyObjectIds
            return connectedClientObjectIds
            
            
        } else {
            return nil
        }
        
    }
    
    func correctNumberOfUsersAreCheckedForDisconnecting() -> Bool {
        
        if self.careGiverCheckedRow != -1 && self.clientCheckedRow != -1 && self.cathyCheckedRows.contains(true) {
            return true
        } else if self.careGiverCheckedRow != -1 && self.clientCheckedRow != -1 {
            return true
        } else if self.careGiverCheckedRow == -1 {
            self.presentBasicAlertControllerWithMessage("Please select a care giver to disconnect")
            return false
        } else if self.clientCheckedRow == -1 {
            self.presentBasicAlertControllerWithMessage("Please select a client to disconnect")
            return false
        }
        return false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setSegmentedControlWidth()
        self.removeBottomLineFromNavigationBar()
        self.setTabBarTopBorderLine()
        
        
        
        
        
        // Need to set the initial chosen segment for the segment control. If this is not present, it will cause a crash.
        self.selectedUserType = UserType.careGiver
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.tableView.reloadData()
        self.numberOfTimesReloadDataIsCalled = 0
        
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        var querySuccessCheck = QuerySuccessCheck()
        
        self.officeConnectUserHelper.attemptQueryingCathyObjectIdsAndUserIds { (querySuccessful, cathyObjectIdsAndUserIds) -> Void in
            if querySuccessful {
                self.cathyObjectIdsAndUserIds = cathyObjectIdsAndUserIds
            }
        }
        
        for userType in self.userTypes {
            
            self.officeConnectUserHelper.attemptQueryingUsersObjectIdsAndNames(userType, completion: { (querySuccessful, userObjectIdsAndNames) -> Void in
                if querySuccessful {
                    self.userObjectIdsAndNames += userObjectIdsAndNames
                }
            })
            
            self.officeConnectUserHelper.attemptQueryingUsersAddedByOfficeUserFromCloud(userType, completion: { (querySuccessful, userNames, userObjectIds, userNotes, connectedObjectIds, userOfficeUserIds) -> Void in
                
                if querySuccessful {
                    
                    if userType == UserType.careGiver {
                        self.careGiverNames = userNames!
                        self.careGiverObjectIds = userObjectIds!
                        self.careGiverNotes = userNotes!
                        self.careGiverOfficeUserIds = userOfficeUserIds!
                        self.connectedObjectIds = connectedObjectIds!
                        //self.careGiverCheckedRows = [Bool](count: self.careGiverNames.count, repeatedValue: false)
                        querySuccessCheck.successfullyQueriedCareGiverUsers = true
                        
                    } else if userType == UserType.client {
                        
                        self.clientNames = userNames!
                        self.clientObjectIds = userObjectIds!
                        self.clientNotes = userNotes!
                        self.clientOfficeUserIds = userOfficeUserIds!
                        //self.clientCheckedRows = [Bool](count: self.clientNames.count, repeatedValue: false)
                        
                        querySuccessCheck.successfullyQueriedClientUsers = true
                        
                    } else if userType == UserType.cathy {
                        self.cathyNames = userNames!
                        self.cathyObjectIds = userObjectIds!
                        self.cathyNotes = userNotes!
                        self.cathyOfficeUserIds = userOfficeUserIds!
                        self.cathyCheckedRows = [Bool](count: self.cathyNames.count, repeatedValue: false)
                        querySuccessCheck.successfullyQueriedCathyUsers = true

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
            self.selectedUserType = UserType.careGiver
        } else if self.segmentedControl.selectedSegmentIndex == 1 {
            self.selectedUserType = UserType.client
        } else if self.segmentedControl.selectedSegmentIndex == 2 {
            self.selectedUserType = UserType.cathy
        }
        self.numberOfTimesReloadDataIsCalled++
        self.tableView.reloadData()
    
    }
    

    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        self.setAccessoryTypeForSelectedUserTypeAtIndexPath(self.selectedUserType, tableView: tableView, indexPath: indexPath)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let originalHeight = UITableViewAutomaticDimension
        var expandedHeight: CGFloat = 200.0

        // The reason for indexPath.row < self.tableView.visibleCells.count is because if self.expandedRowHeights[indexPath.row] only holds row heights of visible cells not cells that have gone off the screen. And since indexPath will call as many times as it is specified  numberOfRowsInSection delegate function, it will cause the app to crash.

        if self.selectedUserType == UserType.careGiver {

            let indexPath = indexPath
            if self.expandButtonTappedIndexPath != nil {
                if indexPath == self.expandButtonTappedIndexPath! {
                    expandedHeight = self.expandedRowHeights[indexPath.row]
                    return expandedHeight
                } else {
                    return originalHeight
                }
            } else {
                return originalHeight
            }
            
        } else {
            return originalHeight
        }
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            if self.selectedUserType == UserType.careGiver {
                self.deleteRowForCareGiver(indexPath, completion: { (deleteRowsAtIndexPath) -> Void in
                    if deleteRowsAtIndexPath {
                        self.expandButtonTappedIndexPath = nil
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    }
                })
            } else {
                self.deleteRowForClientAndCathy(indexPath, completion: { (deleteRowsAtIndexPath) -> Void in
                    if deleteRowsAtIndexPath {
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    }
                })
                
            }

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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! OfficeConnectUserTableViewCell
        
        // The reason for self.expandButtonTapped == true is because self.rowHeights doesn't get initialized until expandButton is tapped. So without this check, it will cause the app to crash.
        if self.expandButtonTappedIndexPath != nil && self.selectedUserType == UserType.careGiver {
            
            cell.userObjectIdsAndNames = self.userObjectIdsAndNames
            cell.width = self.tableView.frame.width
            cell.height = self.originalRowHeight
            cell.spaceBetweenCathyGroups = self.spaceBetweenCathyGroupsInExpandedCell
            cell.spaceBetweenUserLabelsAndUsers = self.spaceBetweenUserLabelsAndUsersInExpandedCell
            cell.spaceBetweenCathys = self.spaceBetweenCathysInExpandedCell
            cell.removeUserTypeLabels()
            cell.createClientLabel()
            cell.createCathyLabel()
            cell.removeNameButtons()
            cell.createNameButtons(self.connectedObjectIds[indexPath.row])
            for nameButton in cell.nameButtons {
                nameButton.addTarget(self, action: "connectedNameButtonTapped:", forControlEvents: .TouchUpInside)
            }
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
        self.nameButtonSelectedRow = (indexPath?.row)!
        self.performSegueWithIdentifier("officeConnectUsersToUserProfile", sender: nil)
    }
    
    @IBAction func expandButtonTapped(sender: AnyObject) {

        self.setExpandedRowHeights()
        
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
                //self.tableView.scrollToRowAtIndexPath(indexPath!, atScrollPosition: .Top, animated: true)
            }
        }

        self.tableView.beginUpdates()
        self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
        self.tableView.endUpdates()
        
        // It will continue to append the row heights so the elements in the array does not reflect the actual row heights of the rows in the table view. Only by removing all, could we get the correct values.
    }
    
    func getConnectedClientObjectIdsAndNamesForCareGiver(clientObjectIds: Dictionary<String, [String]>) -> [String: String] {
        
        var clientObjectIdAndName: [String: String] = [String: String]()
        for (clientObjectId, _) in clientObjectIds {
            clientObjectIdAndName[clientObjectId] = self.userObjectIdsAndNames[clientObjectId]
        }
        return clientObjectIdAndName
    }
    
    func clearCheckMarks()  {
        
        self.careGiverCheckedRow = -1
        self.clientCheckedRow = -1
        
        for(var i: Int = 0; i < self.cathyCheckedRows.count; i++) {
            if(self.cathyCheckedRows[i] == true) {
                self.cathyCheckedRows[i] = false
            }
        }
        
    }

    @IBAction func connectButtonTapped(sender: AnyObject) {
  
        if self.correctNumberOfUsersAreCheckedForConnecting() {
        
            let checkedCareGiverObjectId: String = self.getCheckedUserObjectIds(UserType.careGiver)![0]
            let checkedClientObjectId: String = self.getCheckedUserObjectIds(UserType.client)![0]
            let checkedCathyObjectIds: [String]  = self.getCheckedUserObjectIds(UserType.cathy)!

            let objectIdsToBeConnected = self.getObjectIdsToBeConnected(checkedClientObjectId, checkedCathyObjectIds: checkedCathyObjectIds)
            
            // The reason for this function is an architectural faulty. Because the way that objectIds are stored, namely, in an array of a dictionary which has another [String] associated to a key, I was not sure if I were to store the names in another row, it would be queried in the same manner. So in order to prevent that from happening, I had to do this, which also means that when the care giver queries her client, she will only be able to get the objectIds of the client. So, I need an efficient way to some how connect the objectIds to the names. This is the best way that I found so far how to do it.
            let clientObjectIdsAndNames = self.getConnectedClientObjectIdsAndNamesForCareGiver(objectIdsToBeConnected)

            // The following function also uploads the clientObjectIdsAndNames to the cloud. But the primary function is to connect users in the cloud. Also, right now self.cathyObjectIdsAndUserIds is being uploaded which holds all the cathy object ids and user ids that are added by the user not necessarily the ones that are connected to a certain giver. So I will eventually make this change. But for the sake of finishing the app, I will hold this off for now.
            self.officeConnectUserHelper.connectObjectIdsToCareGiverInCloud(checkedCareGiverObjectId, objectIdsToBeConnected: objectIdsToBeConnected, clientObjectIdsAndNames: clientObjectIdsAndNames, cathyObjectIdsAndUserIds: self.cathyObjectIdsAndUserIds, completion: { (connectionSuccessful) -> Void in
                if connectionSuccessful {
                    self.connectedObjectIds[self.careGiverCheckedRow] = objectIdsToBeConnected
                    self.setExpandedRowHeights()
                    self.clearCheckMarks()
   
                    self.tableView.reloadData()
                    self.presentBasicAlertControllerWithMessage("Connection successful :)")
                }
            })
 
        }
        
    }

    @IBAction func disconnectButtonTapped(sender: AnyObject) {
        
        if self.correctNumberOfUsersAreCheckedForDisconnecting() {
            
            let checkedCareGiverObjectId: String = self.getCheckedUserObjectIds(UserType.careGiver)![0]
            let checkedClientObjectId: String = self.getCheckedUserObjectIds(UserType.client)![0]
            let checkedCathyObjectIds: [String]  = self.getCheckedUserObjectIds(UserType.cathy)!

            if let objectIdsToBeConnected = self.getObjectIdsToBeConnectedAfterTheirDisconnection(checkedClientObjectId, checkedCathyObjectIds: checkedCathyObjectIds) {
                
                let clientObjectIdsAndNames = self.getConnectedClientObjectIdsAndNamesForCareGiver(objectIdsToBeConnected)
    
                self.officeConnectUserHelper.connectObjectIdsToCareGiverInCloud(checkedCareGiverObjectId, objectIdsToBeConnected: objectIdsToBeConnected, clientObjectIdsAndNames: clientObjectIdsAndNames, cathyObjectIdsAndUserIds: self.cathyObjectIdsAndUserIds, completion: { (connectionSuccessful) -> Void in
                    if connectionSuccessful {
                        self.connectedObjectIds[self.careGiverCheckedRow] = objectIdsToBeConnected
                        self.setExpandedRowHeights()
                        self.clearCheckMarks()

                        self.tableView.reloadData()
                        self.presentBasicAlertControllerWithMessage("Disconnection successful :)")
                    }
                })
                
            }
        }
    }
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("officeConnectUserToOfficeAddUser", sender: nil)
    }
    
    func connectedNameButtonTapped(sender: IdentifiedButton) {
        self.userTypeForConnectedName = sender.userType
        self.performSegueWithIdentifier("officeConnectUsersToUserProfile", sender: sender)
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
                
                if sender == nil {
                    self.setUserObjectIdsForSelectedUserType(self.selectedUserType)
                    userProfileViewController.userObjectId = self.userObjectIds[self.nameButtonSelectedRow]
                    userProfileViewController.selectedUserType = self.selectedUserType
                } else {
                    userProfileViewController.userObjectId = sender!.identifier!!
                    userProfileViewController.selectedUserType = self.userTypeForConnectedName
                }
                
                
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


