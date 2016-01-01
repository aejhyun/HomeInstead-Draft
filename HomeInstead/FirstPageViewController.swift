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
            if userType == "office" {
                self.performSegueWithIdentifier("firstPageToOffice", sender: nil)
            } else if userType == "giver" {
                self.performSegueWithIdentifier("firstPageToGiver", sender: nil)
            } else if userType == "cathy" {
                self.performSegueWithIdentifier("firstPageToCathy", sender: nil)
            }
        } else {
            self.performSegueWithIdentifier("firstPageToSignUpSignIn", sender: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
