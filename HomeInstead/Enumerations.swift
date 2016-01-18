//
//  Enumerations.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 1/15/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import Foundation
import Parse

enum UserDefaultsKeys {
    
    static let officeGiverListKey = "\(PFUser.currentUser()!.objectId)OfficeGiverListFirstTimeLoad"
    static let officeClientListKey = "\(PFUser.currentUser()!.objectId)OfficeClientListFirstTimeLoad"
    static let officeCathyListKey = "\(PFUser.currentUser()!.objectId)OfficeCathyListFirstTimeLoad"
    static let giverClientListKey = "\(PFUser.currentUser()!.objectId)GiverCientListFirstTimeLoad"
    
}