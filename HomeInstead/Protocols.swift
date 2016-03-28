//
//  Protocols.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 12/31/15.
//  Copyright © 2015 Jae Hyun Kim. All rights reserved.
//

import Foundation

protocol ReceiveMessageDelegate {
    func receiveMessageFromTaskMessageViewController(message: String)
}

protocol OfficeGiverListTableViewControllerDelegate {
    
    func getClientFirstName(firstName: String)
    func getClientLastName(lastName: String)
    func getClientNotes(notes: String)
    func getClientImage(image: UIImage?)
    func segueToOfficeClientProfileViewController()
    
}