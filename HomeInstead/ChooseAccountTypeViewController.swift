//
//  ChooseAccountTypeViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 4/3/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class ChooseAccountTypeViewController: UIViewController {
    
    var accountTypeSelected: AccountType!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func officeButtonTapped(sender: AnyObject) {
        self.accountTypeSelected = AccountType.Office
    }

    @IBAction func careGiverButtonTapped(sender: AnyObject) {
        self.accountTypeSelected = AccountType.CareGiver
    }
    
    @IBAction func cathyButtonTapped(sender: AnyObject) {
        self.accountTypeSelected = AccountType.Cathy
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let navigationController = segue.destinationViewController as? UINavigationController {
            if let signUpViewController = navigationController.topViewController as? SignUpViewController {
                
                signUpViewController.accountTypeSelected = self.accountTypeSelected
                
            } else {
                print("signUpViewController returned nil")
            }
        } else {
            print("navigationController returned nil")
        }
        
        
        
        
    }

}


//override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//    if (segue.identifier == "officeGiverListToClientList") {
//        let officeClientListTableViewController = segue.destinationViewController as! OfficeClientListTableViewController
//        officeClientListTableViewController.passedGiverName = giverNameToBePassed
//        officeClientListTableViewController.passedGiverId = giverIdToBePassed
//        officeClientListTableViewController.passedGiverEmail = giverEmailToBePassed
//    } else if segue.identifier == "officeGiverListToOfficeCreateClientProfile" {
//        
//        if let navigationController = segue.destinationViewController as? UINavigationController {
//            if let officeCreateClientProfileViewController = navigationController.topViewController as? OfficeCreateClientProfileViewController {
//                officeCreateClientProfileViewController.clientInformationDelegate = self
//                officeCreateClientProfileViewController.segueBehindModalViewControllerDelegate = self
//            } else {
//                print("officeCreateClientProfileViewController is nil")
//            }
//        } else {
//            print("navigationController is nil")
//        }
//        
//    } else if segue.identifier == "officeGiverListToOfficeClientProfile" {
//        
//        if let officeClientProfileViewController = segue.destinationViewController as? OfficeClientProfileViewController {
//            officeClientProfileViewController.firstName = self.clientFirstName
//            officeClientProfileViewController.lastName = self.clientLastName
//            officeClientProfileViewController.notes = self.clientNotes
//            officeClientProfileViewController.image = self.clientImage
//            officeClientProfileViewController.cathyNames = self.cathyNames
//            officeClientProfileViewController.cathyEmails = self.cathyEmails
//        } else {
//            print("officeClientProfileViewController is nil")
//        }
//        
//    }
//}