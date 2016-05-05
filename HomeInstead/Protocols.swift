//
//  Protocols.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 12/31/15.
//  Copyright © 2015 Jae Hyun Kim. All rights reserved.
//

import Foundation

protocol OfficeGiverListTableViewControllerDelegate {
    
    func getClientFirstName(firstName: String)
    func getClientLastName(lastName: String)
    func getClientNotes(notes: String)
    func getClientImage(image: UIImage?)
    func getCathyNames(names: [String])
    func getCathyEmails(emails: [String])
    func segueToOfficeClientProfileViewController()
    
}

protocol ClientInformationDelegate {
    
    func getClientFirstName(firstName: String)
    func getClientLastName(lastName: String)
    func getClientNotes(notes: String)
    func getClientImage(image: UIImage?)
    func getCathyNames(names: [String])
    func getCathyEmails(emails: [String])
    
}

protocol SegueBehindModalViewControllerDelegate {
    func segueBehindModalViewController()
}

protocol PassUserInformationDelegate {
    func passUserInformation(user: [String: String])
}

protocol DismissViewControllerDelegate {
    func dismissViewController()
}




//if let navigationController = segue.destinationViewController as? UINavigationController {
//    if let officeCreateClientProfileViewController = navigationController.topViewController as? OfficeCreateClientProfileViewController {
//        officeCreateClientProfileViewController.delegate = self
//    } else {
//        print("officeCreateClientProfileViewController is nil")
//    }
//} else {
//    print("navigationController is nil")
//}