//
//  SignInViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 12/10/15.
//  Copyright © 2015 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        emailAddress.becomeFirstResponder()
        activityIndicator.hidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.view.endEditing(true);
    }
    
    @IBAction func signInButtonTapped(sender: AnyObject) {
        var ready = false
        
        if self.emailAddress.text == "" {
            setAlertControllerMessage("Please enter your email address")
        } else if self.password.text == "" {
            setAlertControllerMessage("Please enter your password")
        } else {
            ready = true;
        }
        
        if ready == true {

            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
            
            PFUser.logInWithUsernameInBackground(emailAddress.text!, password: password.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    
                    let query = PFQuery(className:"_User")
                    query.whereKey("username", equalTo: self.emailAddress.text!)
                    query.findObjectsInBackgroundWithBlock {
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        
                        if error == nil {
                            //print("Successfully retrieved \(objects!.count) objects.")
                            if let objects = objects {
                                for object in objects {
                                    let userType = object.objectForKey("userType") as! String
                                    if userType == "office" {
                                        self.performSegueWithIdentifier("signInToOffice", sender: nil)
                                    } else if userType == "giver" {
                                        self.performSegueWithIdentifier("signInToGiver", sender: nil)
                                    } else if userType == "cathy" {
                                        self.performSegueWithIdentifier("signInToCathy", sender: nil)
                                    }
                                }
                            }
                        } else {
                            print("Error: \(error!) \(error!.userInfo)")
                        }
                    }
                    
                } else {
                    self.setAlertControllerMessage("Incorrect email address or password")
                }
                
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                self.activityIndicator.hidden = true
            }
        }
    }
    
    func setAlertControllerMessage(message: String) {
        let alertController = UIAlertController(title: "", message: "\(message)", preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
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
