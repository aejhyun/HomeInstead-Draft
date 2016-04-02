//
//  SignUpViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 12/10/15.
//  Copyright © 2015 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class OlderSignUpViewController: UIViewController {
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var verificationCode: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstName.becomeFirstResponder()
        activityIndicator.hidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.view.endEditing(true);
    }
    
    @IBAction func signUpButtonTapped(sender: AnyObject) {
        var ready = false
        
        let user = PFUser()
        user["firstName"] = firstName.text
        user["lastName"] = lastName.text
        user["fullName"] = firstName.text! + " " + lastName.text!
        user.email = emailAddress.text
        user.password = password.text
        user.username = emailAddress.text
        //Try taking the verificaiton code to parse saving out.
        user["verificationCode"] = verificationCode.text
        
        //user["type"] is also included down below
        
        if self.firstName.text == "" {
            setAlertControllerMessage("Please enter your first name")
        } else if self.lastName.text == "" {
            setAlertControllerMessage("Please enter your last name")
        } else if self.emailAddress.text == "" {
            setAlertControllerMessage("Please enter your email address")
        } else if self.password.text == "" {
            setAlertControllerMessage("Please enter your password")
        } else if self.verificationCode.text == "" {
            setAlertControllerMessage("Please enter the verification code")
        } else {
            ready = true;
        }
        
        //if I can check for whether the email is a valid email here, that would be awesome.
        
        if ready == true {
            if self.verificationCode.text == "office" {
                user["userType"] = "office"
            } else if self.verificationCode.text == "giver" {
                user["userType"] = "giver"
            } else if self.verificationCode.text == "cathy" {
                user["userType"] = "cathy"
            } else {
                setAlertControllerMessage("Incorrect verification code")
                ready = false
            }
        }
        
        if ready == true {
            
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    
                    var errorString = error.userInfo["error"] as! NSString
                    if errorString == "invalid email address" {
                        errorString = "Invalid email address"
                    } else if errorString == "username \(self.emailAddress.text!) already taken" {
                        errorString = "The email \(self.emailAddress.text!) is already taken"
                    }
                    self.setAlertControllerMessage("\(errorString)")
                    
                } else {
                    
                    if self.verificationCode.text == "office" {
                        self.performSegueWithIdentifier("signUpToOffice", sender: nil)
                    } else if self.verificationCode.text == "giver" {
                        
                        let giverList = PFObject(className:"GiverList")
                        giverList["giverId"] = PFUser.currentUser()?.objectId
                        giverList["giverName"] = self.firstName.text! + " " + self.lastName.text!
                        giverList["giverEmail"] = self.emailAddress.text!
                        giverList["alreadyAddedByOffice"] = false
                        giverList.saveInBackgroundWithBlock {
                            (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                
                            } else {
                                print(error?.description)
                                // There was a problem, check error.description
                            }
                        }
                        
                        self.performSegueWithIdentifier("signUpToGiver", sender: nil)
                    } else if self.verificationCode.text == "cathy" {
                        
                        let cathyList = PFObject(className: "CathyList")
                        cathyList["cathyName"] = self.firstName.text! + " " + self.lastName.text!
                        cathyList["cathyId"] = PFUser.currentUser()?.objectId
                        cathyList["cathyEmail"] = self.emailAddress.text!
                        cathyList["alreadyAddedByOffice"] = false
                        cathyList.saveInBackgroundWithBlock {
                            (success: Bool, error: NSError?) -> Void in
                            if (success) {
                                
                            } else {
                                print(error?.description)
                                // There was a problem, check error.description
                            }
                        }
                        
                        self.performSegueWithIdentifier("signUpToCathy", sender: nil)
                    }
                    
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