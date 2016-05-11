//
//  FirstPageViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 12/15/15.
//  Copyright © 2015 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class FirstPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
      
        if PFUser.currentUser() != nil {
            let userType = PFUser.currentUser()?.objectForKey("userType") as! String
            if userType == UserType.office.rawValue {
                self.performSegueWithIdentifier("firstPageToOffice", sender: nil)
            } else if userType == UserType.careGiver.rawValue {
                self.performSegueWithIdentifier("firstPageToCareGiver", sender: nil)
            } else if userType == UserType.cathy.rawValue {
                self.performSegueWithIdentifier("firstPageToCathy", sender: nil)
            }
        } else {
            self.performSegueWithIdentifier("firstPageToSignUpSignIn", sender: nil)
        }
        
    }


}
