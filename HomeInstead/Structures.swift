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