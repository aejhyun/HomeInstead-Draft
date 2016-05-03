//
//  Miscellaneous.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 12/29/15.
//  Copyright © 2015 Jae Hyun Kim. All rights reserved.
//

import Foundation

//Office giver list crashes when I navigate using the navigation bar too quickly because the array is not completely filled with data before I try to make a transition from Parse. So data is being pulled from Parse too slowly. 




//Set activity indicator for when deleting because if you exit the app before the delete is complete, the update won't occur on parse.


//func returnCathyUserInformationInDictionary() -> Dictionary <String, NSObject> {
//    
//    let fullName: String = self.firstNameTextField.text! + " " + self.lastNameTextField.text!
//    let imageFile: NSData? = self.getImageFile()
//    
//    var cathyUserInformation = [String: NSObject]()
//    cathyUserInformation["id"] = PFUser.currentUser()?.objectId
//    cathyUserInformation["name"] = fullName
//    cathyUserInformation["email"] = self.emailTextField.text
//    cathyUserInformation["province"] = self.provinceTextField.text
//    cathyUserInformation["city"] = self.cityTextField.text
//    cathyUserInformation["street"] = self.streetTextField.text
//    cathyUserInformation["postalCode"] = self.postalCodeTextField.text
//    cathyUserInformation["phoneNumber"] = self.phoneNumberTextField.text
//    cathyUserInformation["emergencyPhoneNumber"] = self.emergencyPhoneNumberTextField.text
//    cathyUserInformation["imageFile"] = imageFile
//    cathyUserInformation["alreadyAddedByOfficeUser"] = false
//    
//    return cathyUserInformation
//    
//}




//        var originalRowHeights: [CGFloat] = [CGFloat]()
//        var expandedRowHeights: [CGFloat] = [CGFloat]()
//
//        self.expandButtonTappedAfterViewAppears = true
//
//
//
//        // I use the code below to get the row height for each cell so that xcode knows where to add the connected names, that is, right below the notes in the cell. I can't use the row height in the cell for row index path because it is not returning the correct row height. In order to get the correct heights, I have to put the function in the expandButtonTapped function.
//        for visibleCell in self.tableView.visibleCells {
//            let rowHeight = CGRectGetHeight(visibleCell.bounds)
//            originalRowHeights.append(rowHeight)
//        }
//
//        //        print(originalRowHeights)
//
//        for var row: Int = 0; row < originalRowHeights.count; row++ {
//            var newRowHeight: CGFloat = 0.0
//            var numberOfClients: Int = 0
//            var numberOfCathys: Int = 0
//
//            numberOfClients += self.connectedNames[row].count
//
//            for (clientName, _) in self.connectedNames[row] {
//                numberOfCathys += self.connectedNames[row][clientName]!.count
//            }
//            print(originalRowHeights[row])
//            newRowHeight = originalRowHeights[row] + self.spaceBetweenUserLabelsAndUsersInExpandedCell + (CGFloat(numberOfClients - 1) * self.spaceBetweenCathyGroupsInExpandedCell) + (CGFloat(numberOfCathys) * self.spaceBetweenCathysInExpandedCell)
//            expandedRowHeights.append(newRowHeight)
//        }
//
//
//        self.originalRowHeights = originalRowHeights
//        self.expandedRowHeights = expandedRowHeights
//
//        originalRowHeights.removeAll()
//        expandedRowHeights.removeAll()


















//override func viewDidLoad() {
//    super.viewDidLoad()
//
//    tableViewHeader.layer.borderWidth = 1
//    tableViewHeader.layer.borderColor = UIColor.lightGrayColor().CGColor
//    
//    addHeaderSpace()
//
//}
//
//func addHeaderSpace() {
//    let headerView = taskListTableView.tableHeaderView
//    headerView!.setNeedsLayout()
//    headerView!.layoutIfNeeded()
//    var frame = headerView!.frame
//    frame.size.height = CGFloat(60.0)
//    headerView!.frame = frame
//    taskListTableView.tableHeaderView = headerView
//}




//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let taskMessageViewController = storyboard.instantiateViewControllerWithIdentifier("taskMessageViewController")
//            taskMessageViewController.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
//            taskMessageViewController.transitioningDelegate = self
//            self.presentViewController(taskMessageViewController, animated: true, completion: nil)



//var location = cLLocationManager.location
//let latitude = location?.coordinate.latitude
//let longitude = location?.coordinate.longitude
//let cLGeocoder = CLGeocoder()
//var placemark: CLPlacemark!
//var address: String = ""
//
//if let latitude = latitude {
//    if let longitude = longitude {
//        location = CLLocation(latitude: latitude, longitude: longitude)
//    } else {
//        print("Longitude is nil")
//    }
//} else {
//    print("Latitude and longitude is nil")
//}
//
//cLGeocoder.reverseGeocodeLocation(location!) { (placemarks, error) -> Void in
//    
//    if error == nil {
//        
//        placemark = placemarks![0]
//        
//        if let street = placemark.addressDictionary!["Thoroughfare"] as? String {
//            address = street
//        }
//        if let city = placemark.addressDictionary!["City"] as? String {
//            address += ", " + city
//        }
//        if let zipCode = placemark.addressDictionary!["ZIP"] as? String {
//            address += " " + zipCode
//        }
//        
//        for index in 0...(self.cathyIds.count - 1) {
//            let taskInformation = PFObject(className:"TaskInformation")
//            taskInformation["cathyId"] = self.cathyIds[index]
//            taskInformation["cathyName"] = self.cathyNames[index]
//            taskInformation["giverId"] = PFUser.currentUser()?.objectId
//            taskInformation["giverName"] = self.getGiverName()
//            taskInformation["clientName"] = self.passClientName
//            taskInformation["task"] = task
//            taskInformation["date"] = self.getDate()
//            taskInformation["time"] = self.getTime()
//            taskInformation["address"] = address
//            
//            taskInformation.saveInBackgroundWithBlock {
//                (success: Bool, error: NSError?) -> Void in
//                if (success) {
//                    print("The object has been saved.")
//                } else {
//                    // There was a problem, check error.description
//                }
//            }
//        }
//        
//    } else {
//        print(error)
//    }
//    
//}
