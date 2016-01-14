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
