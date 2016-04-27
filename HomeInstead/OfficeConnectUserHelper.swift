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
    
    var selectedUserType: UserType!
    
    func attemptQueryingUsersAddedByOfficeUserFromCloud(userType: UserType, completion: (querySuccessful: Bool, userNames: [String], userObjectIds: [String], userNotes: [String], userOfficeIds: [[String]]) -> Void) {
        
        var userNames: [String] = [String]()
        var userObjectIds: [String] = [String]()
        var userNotes: [String] = [String]()
        var userOfficeIds: [[String]] = [[String]]() // These variables are to hold the ids of the office users who added the non office user.
//        var cathyOfficeUserIds: [[String]] = [[String]]()
//        var careGiverOfficeUserIds: [[String]] = [[String]]()
        
        let query = PFQuery(className: classNameForCloud.getClassName(userType)!)
        query.whereKey("idsOfOfficeUsersWhoAddedThisUser", containedIn: [(PFUser.currentUser()?.objectId)!])
        //query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        
//                        if userType == UserType.client {
//                            clientOfficeUserIds.append(object.objectForKey("idsOfOfficeUsersWhoAddedThisUser") as! [String])
//                            self.clientConnectedCathysIds.append(object.objectForKey("connectedCathysIds") as! [String])
//                            self.clientConnectedCareGiverIds.append(object.objectForKey("connectedCareGiverIds") as! [String])
//                        } else if userType == UserType.cathy {
//                            cathyOfficeUserIds.append(object.objectForKey("idsOfOfficeUsersWhoAddedThisUser") as! [String])
//                        } else if userType == UserType.careGiver {
//                            careGiverOfficeUserIds.append(object.objectForKey("idsOfOfficeUsersWhoAddedThisUser") as! [String])
//                        }
                        
                        
                        
                        userNames.append(object.objectForKey("name") as! String)
                        userObjectIds.append(object.objectId!)
                        userNotes.append(object.objectForKey("notes") as! String)
                        userOfficeIds.append(object.objectForKey("idsOfOfficeUsersWhoAddedThisUser") as! [String])
                        object.pinInBackground()

                        
                    }
                    completion(querySuccessful: true, userNames: userNames, userObjectIds: userObjectIds, userNotes: userNotes, userOfficeIds: userOfficeIds)
                    
                }
            } else {
                completion(querySuccessful: false, userNames: userNames, userObjectIds: userObjectIds, userNotes: userNotes, userOfficeIds: userOfficeIds)
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }
    
    func queryConnectedUsersFromCloud(userType: UserType, connectedUsers: [String], completion: (querySuccessful: Bool, connectedUsers: [[String: String]]) -> Void) {
        
        var connectedUserInformation: [String: String] = [String: String]()
        var users: [[String: String]] = [[String: String]]()
        
        for var index: Int = 0; index < connectedUsers.count; index++ {
            
            let query = PFQuery(className: self.classNameForCloud.getClassName(self.selectedUserType)!)
            query.getObjectInBackgroundWithId(connectedUsers[index]) {
                (object: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    print(error)
                } else if let object = object {
                    connectedUserInformation["name"] = object.objectForKey("name") as? String
                    connectedUserInformation["notes"] = object.objectForKey("notes") as? String
                    connectedUserInformation["email"] = object.objectForKey("email") as? String
                    connectedUserInformation["province"] = object.objectForKey("province") as? String
                    connectedUserInformation["city"] = object.objectForKey("city") as? String
                    connectedUserInformation["district"] = object.objectForKey("district") as? String
                    connectedUserInformation["streetOne"] = object.objectForKey("streetOne") as? String
                    connectedUserInformation["streetTwo"] = object.objectForKey("streetTwo") as? String
                    connectedUserInformation["streetThree"] = object.objectForKey("streetThree") as? String
                    connectedUserInformation["postalCode"] = object.objectForKey("postalCode") as? String
                    connectedUserInformation["phoneNumber"] = object.objectForKey("phoneNumber") as? String
                    connectedUserInformation["emergencyPhoneNumber"] = object.objectForKey("emergencyPhoneNumber") as? String
                    connectedUserInformation["userType"] = object.objectForKey("userType") as? String
                    connectedUserInformation["userId"] = object.objectForKey("userId") as? String
                    connectedUserInformation["objectId"] = object.objectId
                    users.append(connectedUserInformation)
                    completion(querySuccessful: true, connectedUsers: users)
                }
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
            nameOfFirstField = "connectedCathysIds"
            nameOfSecondField = "connectedCareGiverIds"
            firstSetOfObjectIdsToBeUploaded = checkedCathysObjectIds
            secondSetOfObjectIdsToBeUploaded = checkedCareGiversObjectIds
        } else if selectedUserType == UserType.cathy {
            objectIdsForQuery = checkedCathysObjectIds
            nameOfFirstField = "connectedClientIds"
            nameOfSecondField = "connectedCareGiverIds"
            firstSetOfObjectIdsToBeUploaded = checkedClientObjectId
            secondSetOfObjectIdsToBeUploaded = checkedCareGiversObjectIds
        } else if selectedUserType == UserType.careGiver {
            objectIdsForQuery = checkedCareGiversObjectIds
            nameOfFirstField = "connectedClientIds"
            nameOfSecondField = "connectedCathysIds"
            firstSetOfObjectIdsToBeUploaded = checkedClientObjectId
            secondSetOfObjectIdsToBeUploaded = checkedCathysObjectIds
        }
        
        print(checkedClientObjectId)
        print(checkedCathysObjectIds)
        print(checkedCareGiversObjectIds)
        
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