//
//  SignInViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 4/7/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.becomeFirstResponder()

    }
    
    override func viewWillDisappear(animated: Bool) {
        self.view.endEditing(true);
    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func signInButtonTapped(sender: AnyObject) {
        
        if self.allRequiredFieldsAreNotEmpty() {
            
            self.attemptLogInWithUsername({ (logInSuccessful) -> Void in
                if logInSuccessful {
                    
                    self.attemptQueryUserType({ (querySuccessful, userType) -> Void in
                        if querySuccessful {
                            
                            if userType == UserType.office.rawValue {
                                print("segue to office's first view controller")
                            } else if userType == UserType.careGiver.rawValue {
                                print("segue to careGiver's first view controller")
                            } else if userType == UserType.cathy.rawValue {
                                print("segue to cathy's first view controller")
                            }
                            
                        } else {
                            self.presentAlertControllerWithMessage("An error has occurred.")
                        }
                    })
                    
                } else {
                    self.presentAlertControllerWithMessage("Incorrect email address or password")
                }
            })
            
        }
    }
    
    func attemptQueryUserType(completion: (querySuccessful: Bool, userType: String?) -> Void) {
        
        let query = PFUser.query()
        query?.whereKey("username", equalTo: self.emailTextField.text!)
        query?.findObjectsInBackgroundWithBlock({ (object: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let object = object {
                    if object[0].objectForKey("userType") != nil {
                        let userType = object[0].objectForKey("userType") as! String
                        completion(querySuccessful: true, userType: userType)
                    } else {
                        print("Queried user but \"userType\" returned nil")
                        completion(querySuccessful: false, userType: nil)
                    }
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
                completion(querySuccessful: false, userType: nil)
            }
        })
        
    }
    
    func attemptLogInWithUsername(completion: (logInSuccessful: Bool) -> Void) {
        
        PFUser.logInWithUsernameInBackground(self.emailTextField.text!, password:self.passwordTextField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                completion(logInSuccessful: true)
            } else {
                completion(logInSuccessful: false)
            }
        }
        
    }
    
    
    func allRequiredFieldsAreNotEmpty() -> Bool {
        
        if self.emailTextField.text == "" {
            self.presentAlertControllerWithMessage("Please enter your email")
        } else if self.passwordTextField.text == "" {
            self.presentAlertControllerWithMessage("Please enter your password")
        } else {
            return true
        }
        return false
        
    }
    
    func presentAlertControllerWithMessage(message: String) {
        
        let alertController = UIAlertController(title: "", message: "\(message)", preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    
    
}
