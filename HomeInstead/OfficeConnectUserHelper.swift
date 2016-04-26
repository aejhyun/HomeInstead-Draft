//
//  CloudFunctions.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 4/25/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import Foundation
import Parse

class OfficeConnectUserHelper {
    
    let classNameForCloud = ClassNameForCloud()
    
    var clientOfficeUserIds: [[String]] = [[String]]() // These variables are to hold the ids of the office users who added the non office user.
    var cathyOfficeUserIds: [[String]] = [[String]]()
    var careGiverOfficeUserIds: [[String]] = [[String]]()
    
    var clientConnectedCathysIds: [[String]] = [[String]]()
    var clientConnectedCareGiverIds: [[String]] = [[String]]()
    
    var selectedUserType: UserType!
    
    func queryUsersAddedByOfficeUserFromCloud(userType: UserType, completion: (querySuccessful: Bool, users: [[String: String]]) -> Void) {
        
        var idsOfOfficeUsersWhoAddedThisUser: [String] = [String]()
        var users: [[String: String]] = [[String: String]]()
        var userInformation: [String: String] = [String: String]()
        
        let query = PFQuery(className: classNameForCloud.getClassName(userType)!)
        query.whereKey("idsOfOfficeUsersWhoAddedThisUser", containedIn: [(PFUser.currentUser()?.objectId)!])
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        
                        idsOfOfficeUsersWhoAddedThisUser = object.objectForKey("idsOfOfficeUsersWhoAddedThisUser") as! [String]
                        if userType == UserType.client {
                            self.clientOfficeUserIds.append(idsOfOfficeUsersWhoAddedThisUser)
                            //self.clientConnectedCathysIds.append
                        } else if userType == UserType.cathy {
                            self.cathyOfficeUserIds.append(idsOfOfficeUsersWhoAddedThisUser)
                        } else if userType == UserType.careGiver {
                            self.careGiverOfficeUserIds.append(idsOfOfficeUsersWhoAddedThisUser)
                        }
                        
                        
                        
//                        userInformation["clientConnections"] = object.objectForKey("clientConnections")
//                        userInformation["cathyConnections"] = object.objectForKey("cathyConnections")
//                        userInformation["careGiverConnections"] = object.objectForKey("careGiverConnections")
                        
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
                        object.pinInBackground()
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
    
    func deleteUserFromOfficeUserInCloud(user: [[String: String]], officeUserIdsForUser: [[String]], indexPath: NSIndexPath) {
        
        let newOfficeUserIdsForUser: [String] = officeUserIdsForUser[indexPath.row].filter { $0 != PFUser.currentUser()?.objectId }
        
        let query = PFQuery(className: classNameForCloud.getClassName(self.selectedUserType)!)
        
        query.getObjectInBackgroundWithId(user[indexPath.row]["objectId"]!) {
            (objects: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let object = objects {
                object["idsOfOfficeUsersWhoAddedThisUser"] = newOfficeUserIdsForUser
                object.saveInBackground()
            }
        }
    }
    
    func connectUsersForUserTypeInCloud(selectedUserType: UserType, checkedClientObjectId: [String], checkedCathysObjectIds: [String], checkedCareGiversObjectIds: [String]) {
        
        var objectIdsForQuery: [String] = [String]()
        var firstSetOfObjectIdsToBeUploaded: [String] = [String]()
        var secondSetOfObjectIdsToBeUploaded: [String] = [String]()
        var nameOfFirstField: String = String()
        var nameOfSecondField: String = String()
        
        if selectedUserType == UserType.client {
            objectIdsForQuery = checkedClientObjectId
            nameOfFirstField = "cathyConnections"
            nameOfSecondField = "careGiverConnections"
            firstSetOfObjectIdsToBeUploaded = checkedCathysObjectIds
            secondSetOfObjectIdsToBeUploaded = checkedCareGiversObjectIds
        } else if selectedUserType == UserType.cathy {
            objectIdsForQuery = checkedCathysObjectIds
            nameOfFirstField = "clientConnections"
            nameOfSecondField = "careGiverConnections"
            firstSetOfObjectIdsToBeUploaded = checkedClientObjectId
            secondSetOfObjectIdsToBeUploaded = checkedCareGiversObjectIds
        } else if selectedUserType == UserType.careGiver {
            objectIdsForQuery = checkedCareGiversObjectIds
            nameOfFirstField = "clientConnections"
            nameOfSecondField = "cathyConnections"
            firstSetOfObjectIdsToBeUploaded = checkedClientObjectId
            secondSetOfObjectIdsToBeUploaded = checkedCathysObjectIds
        }
        
        for var index: Int = 0; index < objectIdsForQuery.count; index++ {
            
            let query = PFQuery(className: classNameForCloud.getClassName(selectedUserType)!)
            query.getObjectInBackgroundWithId(objectIdsForQuery[index]) {
                (objects: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    print(error)
                } else if let object = objects {
                    object[nameOfFirstField] = firstSetOfObjectIdsToBeUploaded
                    object[nameOfSecondField] = secondSetOfObjectIdsToBeUploaded
                    object.saveInBackground()
                    object.pinInBackground()
                }
            }
            
        }
        
    }

    
    
    

}