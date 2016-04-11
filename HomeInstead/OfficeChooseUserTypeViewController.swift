//
//  OfficeChooseUserTypeViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 4/9/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class OfficeChooseUserTypeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signOutButtonTapped(sender: AnyObject) {
        
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
            if let error = error {
                print(error)
            } else {
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    //self.dismissViewControllerAnimated(false, completion: nil)
                })
                
            }
        }
        
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
