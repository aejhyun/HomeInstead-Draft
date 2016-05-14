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
    
    func attemptQueryingUsersAddedByOfficeUserFromCloud(userType: UserType, completion: (querySuccessful: Bool, userNames: [String]?, userObjectIds: [String]?, userNotes: [String]?, connectedObjectIds: [Dictionary<String, [String]>]?, userOfficeIds: [[String]]?) -> Void) {

        var userNames: [String] = [String]()
        var userObjectIds: [String] = [String]()
        var userNotes: [String] = [String]()
        var userOfficeIds: [[String]] = [[String]]() // These variables are to hold the ids of the office users who added the non office user.
        
        var connectedObjectIds: [Dictionary<String, [String]>] = [Dictionary<String, [String]>]()
        
        let query = PFQuery(className: classNameForCloud.getClassName(userType)!)
        query.whereKey("idsOfOfficeUsersWhoAddedThisUser", containedIn: [(PFUser.currentUser()?.objectId)!])
        //query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        if userType == UserType.careGiver {
                            
                            connectedObjectIds.append(object.objectForKey("connectedObjectIds") as! Dictionary<String, [String]>)
                            
                        }
 
                        userNames.append(object.objectForKey("name") as! String)
                        userObjectIds.append(object.objectId!)
                        userNotes.append(object.objectForKey("notes") as! String)
                        userOfficeIds.append(object.objectForKey("idsOfOfficeUsersWhoAddedThisUser") as! [String])
                        object.pinInBackground()

                    }
                    completion(querySuccessful: true, userNames: userNames, userObjectIds: userObjectIds, userNotes: userNotes, connectedObjectIds: connectedObjectIds, userOfficeIds: userOfficeIds)
                }
            } else {
                completion(querySuccessful: false, userNames: nil, userObjectIds: nil, userNotes: nil, connectedObjectIds: nil, userOfficeIds: nil)
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }
    
    func attemptQueryingUsersObjectIdsAndNames(userType: UserType, completion: (querySuccessful: Bool, userObjectIdsAndNames: [String: String]) -> Void) {
        
        if userType != UserType.office {
            
            var userObjectIdsAndNames: [String: String] = [String: String]()
            
            let query = PFQuery(className: classNameForCloud.getClassName(userType)!)
            query.whereKey("idsOfOfficeUsersWhoAddedThisUser", containedIn: [(PFUser.currentUser()?.objectId)!])
            //query.fromLocalDatastore()
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    if let objects = objects {
                        for object in objects {
                            userObjectIdsAndNames[object.objectId!] = object.objectForKey("name") as? String
                        }
                        completion(querySuccessful: true, userObjectIdsAndNames: userObjectIdsAndNames)
                    }
                } else {
                    completion(querySuccessful: false, userObjectIdsAndNames: userObjectIdsAndNames)
                }
            }
            
        }

    }
    
    func attemptQueryingCathyObjectIdsAndUserIds(completion: (querySuccessful: Bool, cathyObjectIdsAndUserIds: [String: String]) -> Void) {
        
        var cathyObjectIdsAndUserIds: [String: String] = [String: String]()
        
        let query = PFQuery(className: classNameForCloud.getClassName(UserType.cathy)!)
        query.whereKey("idsOfOfficeUsersWhoAddedThisUser", containedIn: [(PFUser.currentUser()?.objectId)!])
        //query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        cathyObjectIdsAndUserIds[object.objectId!] = object.objectForKey("userId") as? String
                    }
                    completion(querySuccessful: true, cathyObjectIdsAndUserIds: cathyObjectIdsAndUserIds)
                }
            } else {
                completion(querySuccessful: false, cathyObjectIdsAndUserIds: cathyObjectIdsAndUserIds)
            }
        }
        
    }
    
    func deleteUserFromOfficeUserInCloud(userType: UserType, keepConnections: Bool, userObjectId: String, officeUserIdsForUser: [String]) {
        
        let newOfficeUserIdsForUser: [String] = officeUserIdsForUser.filter { $0 != PFUser.currentUser()?.objectId }
        let query = PFQuery(className: classNameForCloud.getClassName(userType)!)
        let emptyDictionaryOfArray: Dictionary<String, [String]> = [:]
        
        query.getObjectInBackgroundWithId(userObjectId) {
            (objects: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let object = objects {
                if userType == UserType.careGiver && keepConnections == false {
                    object["connectedObjectIds"] = emptyDictionaryOfArray
                }
                object["idsOfOfficeUsersWhoAddedThisUser"] = newOfficeUserIdsForUser
                object.saveInBackground()
            }
        }
    }
    
    
    func connectObjectIdsToCareGiverInCloud(checkedCareGiverObjectId: String, objectIdsToBeConnected: Dictionary<String, [String]>, clientObjectIdsAndNames: [String: String], cathyObjectIdsAndUserIds: [String: String], completion: (connectionSuccessful: Bool) -> Void) {
        
        let query = PFQuery(className: classNameForCloud.getClassName(UserType.careGiver)!)
        query.getObjectInBackgroundWithId(checkedCareGiverObjectId) {
            (objects: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
                completion(connectionSuccessful: false)
            } else if let object = objects {
                object["connectedObjectIds"] = objectIdsToBeConnected
                object["clientObjectIdsAndNames"] = clientObjectIdsAndNames
                object["cathyObjectIdsAndUserIds"] = cathyObjectIdsAndUserIds
                object.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        completion(connectionSuccessful: true)
                    } else {
                        print(error?.description)
                        completion(connectionSuccessful: false)
                    }
                }
                object.pinInBackground()
            }
        }
        
        
    }
    
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}



//func connectUsersWithClientTypeInCloud(selectedUserType: UserType, checkedClientObjectIds: [String], checkedCathyObjectIds: [String], checkedCareGiverObjectIds: [String], checkedClientNames: [String], checkedCathyNames: [String], checkedCareGiverNames: [String], completion: (connectSuccessful: Bool) -> Void) {
//    
//    let query = PFQuery(className: classNameForCloud.getClassName(selectedUserType)!)
//    query.getObjectInBackgroundWithId(checkedClientObjectIds[0]) {
//        (objects: PFObject?, error: NSError?) -> Void in
//        if error != nil {
//            print(error)
//            completion(connectSuccessful: false)
//        } else if let object = objects {
//            object["connectedCathyObjectIds"] = checkedCathyObjectIds
//            object["connectedCareGiverObjectIds"] = checkedCareGiverObjectIds
//            object["connectedCathyNames"] = checkedCathyNames
//            object["connectedCareGiverNames"] = checkedCareGiverNames
//            object.saveInBackgroundWithBlock {
//                (success: Bool, error: NSError?) -> Void in
//                if (success) {
//                    completion(connectSuccessful: true)
//                } else {
//                    print(error?.description)
//                }
//            }
//            object.pinInBackground()
//        }
//    }
//    
//}




//func queryConnectedUsersFromCloud(userType: UserType, connectedUsers: [String], completion: (querySuccessful: Bool, connectedUsers: [[String: String]]) -> Void) {
//    
//    var connectedUserInformation: [String: String] = [String: String]()
//    var users: [[String: String]] = [[String: String]]()
//    
//    for var index: Int = 0; index < connectedUsers.count; index++ {
//        
//        let query = PFQuery(className: self.classNameForCloud.getClassName(userType)!)
//        query.getObjectInBackgroundWithId(connectedUsers[index]) {
//            (object: PFObject?, error: NSError?) -> Void in
//            if error != nil {
//                print(error)
//            } else if let object = object {
//                connectedUserInformation["name"] = object.objectForKey("name") as? String
//                connectedUserInformation["notes"] = object.objectForKey("notes") as? String
//                connectedUserInformation["email"] = object.objectForKey("email") as? String
//                connectedUserInformation["province"] = object.objectForKey("province") as? String
//                connectedUserInformation["city"] = object.objectForKey("city") as? String
//                connectedUserInformation["district"] = object.objectForKey("district") as? String
//                connectedUserInformation["streetOne"] = object.objectForKey("streetOne") as? String
//                connectedUserInformation["streetTwo"] = object.objectForKey("streetTwo") as? String
//                connectedUserInformation["streetThree"] = object.objectForKey("streetThree") as? String
//                connectedUserInformation["postalCode"] = object.objectForKey("postalCode") as? String
//                connectedUserInformation["phoneNumber"] = object.objectForKey("phoneNumber") as? String
//                connectedUserInformation["emergencyPhoneNumber"] = object.objectForKey("emergencyPhoneNumber") as? String
//                connectedUserInformation["userType"] = object.objectForKey("userType") as? String
//                connectedUserInformation["userId"] = object.objectForKey("userId") as? String
//                connectedUserInformation["objectId"] = object.objectId
//                users.append(connectedUserInformation)
//                completion(querySuccessful: true, connectedUsers: users)
//            }
//        }
//        
//    }
//    
//}












//func connectUserIdsForUserTypeInCloud(selectedUserType: UserType, checkedClientObjectIds: [String], checkedCathyObjectIds: [String], checkedCareGiverObjectIds: [String], checkedClientNames: [String], checkedCathyNames: [String], checkedCareGiverNames: [String], completion: (connectSuccessful: Bool) -> Void) {
//    
//    // , completion: (connectSuccessful: Bool) -> Void
//    
//    var objectIdsForQuery: [String] = [String]()
//    
//    var firstSetOfObjectIdsToBeUploaded: [String] = [String]()
//    var secondSetOfObjectIdsToBeUploaded: [String] = [String]()
//    var firstSetOfNamesToBeUploaded: [String] = [String]()
//    var secondSetOfNamesToBeUploaded: [String] = [String]()
//    
//    var nameOfFirstField: String = String()
//    var nameOfSecondField: String = String()
//    var nameOfThirdField: String = String()
//    var nameOfFourthField: String = String()
//    
//    if selectedUserType == UserType.client {
//        objectIdsForQuery = checkedClientObjectIds
//        nameOfFirstField = "connectedCathyIds"
//        nameOfSecondField = "connectedCareGiverIds"
//        nameOfThirdField = "connectedCathyNames"
//        nameOfFourthField = "connectedCareGiverNames"
//        firstSetOfObjectIdsToBeUploaded = checkedCathyObjectIds
//        secondSetOfObjectIdsToBeUploaded = checkedCareGiverObjectIds
//        firstSetOfNamesToBeUploaded = checkedCathyNames
//        secondSetOfNamesToBeUploaded = checkedCareGiverNames
//    } else if selectedUserType == UserType.cathy {
//        objectIdsForQuery = checkedCathyObjectIds
//        nameOfFirstField = "connectedClientIds"
//        nameOfSecondField = "connectedCareGiverIds"
//        nameOfThirdField = "connectedClientNames"
//        nameOfFourthField = "connectedCareGiverNames"
//        firstSetOfObjectIdsToBeUploaded = checkedClientObjectIds
//        secondSetOfObjectIdsToBeUploaded = checkedCareGiverObjectIds
//        firstSetOfNamesToBeUploaded = checkedClientNames
//        secondSetOfNamesToBeUploaded = checkedCareGiverNames
//    } else if selectedUserType == UserType.careGiver {
//        objectIdsForQuery = checkedCareGiverObjectIds
//        nameOfFirstField = "connectedClientIds"
//        nameOfSecondField = "connectedCathyIds"
//        nameOfThirdField = "connectedClientNames"
//        nameOfFourthField = "connectedCathyNames"
//        firstSetOfObjectIdsToBeUploaded = checkedClientObjectIds
//        secondSetOfObjectIdsToBeUploaded = checkedCathyObjectIds
//        firstSetOfNamesToBeUploaded = checkedClientNames
//        secondSetOfNamesToBeUploaded = checkedCathyNames
//    }
//    
//    for var index: Int = 0; index < objectIdsForQuery.count; index++ {
//        
//        let query = PFQuery(className: classNameForCloud.getClassName(selectedUserType)!)
//        query.getObjectInBackgroundWithId(objectIdsForQuery[index]) {
//            (objects: PFObject?, error: NSError?) -> Void in
//            if error != nil {
//                print(error)
//                completion(connectSuccessful: false)
//            } else if let object = objects {
//                object[nameOfFirstField] = firstSetOfObjectIdsToBeUploaded
//                object[nameOfSecondField] = secondSetOfObjectIdsToBeUploaded
//                object[nameOfThirdField] = firstSetOfNamesToBeUploaded
//                object[nameOfFourthField] = secondSetOfNamesToBeUploaded
//                object.saveInBackgroundWithBlock {
//                    (success: Bool, error: NSError?) -> Void in
//                    if (success) {
//                        completion(connectSuccessful: true)
//                    } else {
//                        print(error?.description)
//                    }
//                }
//                object.pinInBackground()
//            }
//        }
//    }
//    
//    
//}