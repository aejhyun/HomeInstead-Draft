//
//  Structures.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 4/4/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import Foundation

struct VerificationCode {
    
    var office: String
    var careGiver: String
    var cathy: String
    
    init() {
        
        self.office = "office"
        self.careGiver = "careGiver"
        self.cathy = "cathy"
    }
    
    func generateVerificationCode(length: Int) -> String {
        
        let allowedCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharactersCount = UInt32(allowedCharacters.characters.count)
        var verificationCode = ""
        
        for _ in (0..<length) {
            let randomNum = Int(arc4random_uniform(allowedCharactersCount))
            let newCharacter = allowedCharacters[allowedCharacters.startIndex.advancedBy(randomNum)]
            verificationCode += String(newCharacter)
        }
        
        return verificationCode
    }
}

struct HelperFunctions {
    
    func setBasicAlertController(title: String?, message: String) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        return alertController
    }
    
}

struct ClassNameForCloud {
    
    let officeUser: String
    let careGiverUser: String
    let cathyUser: String
    let clientUser: String
    
    init() {
        
        self.officeUser = "OfficeUser"
        self.careGiverUser = "CareGiverUser"
        self.cathyUser = "CathyUser"
        self.clientUser = "ClientUser"
        
    }
    
    func getClassName(selectedUserType: UserType) -> String? {
        
        if selectedUserType == UserType.office {
            return self.officeUser
        } else if selectedUserType == UserType.careGiver {
            return self.careGiverUser
        } else if selectedUserType == UserType.cathy {
            return self.cathyUser
        } else if selectedUserType == UserType.client {
            return self.clientUser
        }
        return nil
        
    }
    
}

struct QuerySuccessCheck {
    
    var successfullyQueriedCareGiverUsers: Bool
    var successfullyQueriedCathyUsers: Bool
    var successfullyQueriedClientUsers: Bool
    
    init() {
        
        self.successfullyQueriedCareGiverUsers = false
        self.successfullyQueriedCathyUsers = false
        self.successfullyQueriedClientUsers = false
        
    }
    
    func successfullyQueriedAllUsers () -> Bool {
        
        if self.successfullyQueriedClientUsers && self.successfullyQueriedCathyUsers && self.successfullyQueriedCareGiverUsers {
            return true
        } else {
            return false
        }
        
    }
    
}

struct UpdateSuccessCheck {
    
    var firstUpdateSuccessful: Bool
    var secondUpdateSuccessful: Bool
    var thirdUpdateSuccessful: Bool
    
    init() {
        
        self.firstUpdateSuccessful = false
        self.secondUpdateSuccessful = false
        self.thirdUpdateSuccessful = false
        
    }
    
    func allUpdatesAreSuccessful() -> Bool {
        
        if self.thirdUpdateSuccessful && self.secondUpdateSuccessful && self.firstUpdateSuccessful {
            return true
        } else {
            return false
        }
        
    }
    
}












