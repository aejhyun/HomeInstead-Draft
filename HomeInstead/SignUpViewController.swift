//
//  SignUpViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 12/10/15.
//  Copyright © 2015 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: ImageManagerViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var verificationTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emergencyPhoneNumberTextField: UITextField!
 
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var clientSignUpButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeTextField: UITextField?
    var accountTypeSelected: AccountType!
    
    func setDefaultTextFieldValues() {
        
        self.firstNameTextField.text = "Jae"
        self.lastNameTextField.text = "Kim"
        self.emailTextField.text = "aejhyun@gmail.com"
        self.passwordTextField.text = "password"
        self.confirmPasswordTextField.text = "password"
        self.verificationTextField.text = "verification"
        self.provinceTextField.text = "Hubei Province"
        self.cityTextField.text = "Hanyang"
        self.streetTextField.text = "19300 Nassau St."
        self.postalCodeTextField.text = "92508"
        self.phoneNumberTextField.text = "9518077192"
        self.emergencyPhoneNumberTextField.text = "4350937283"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDefaultTextFieldValues()
        
        if self.accountTypeSelected == AccountType.Cathy {
            self.signUpButton.hidden = true
            self.navigationItem.title = "Cathy Sign Up"
        } else {
            if self.accountTypeSelected == AccountType.CareGiver {
                self.navigationItem.title = "CareGiver Sign Up"
            } else if self.accountTypeSelected == AccountType.Office {
                self.navigationItem.title = "Office Sign Up"
            }
            self.clientSignUpButton.hidden = true
        }
        
        self.addPhotoButton.titleLabel?.textAlignment = .Center
        self.editButton.hidden = true
        self.firstNameTextField.becomeFirstResponder()
        self.automaticallyAdjustsScrollViewInsets = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.view.endEditing(true);
    }

//TextField functions start here.
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.activeTextField = nil
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

//TextField functions end here.
//Keyboard functions start here.
    
    func keyboardDidShow(notification: NSNotification) {
        
        if let activeTextField = self.self.activeTextField, keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            if (CGRectContainsPoint(aRect, activeTextField.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeTextField.frame, animated: true)
            }
        }
        
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        
        let contentInsets = UIEdgeInsetsZero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
    }
    
//Keyboard functions end here.
//SignUp functions start here.
    
    @IBAction func clientSignUpButtonTapped(sender: AnyObject) {
        
        
    }
    
    @IBAction func signUpButtonTapped(sender: AnyObject) {
        
        if self.allFieldsAreNotEmpty() && self.isValidEmail() && self.passwordIsConfirmed() && self.isValidVerificationCode() {
            print("success")
        }

    }
    
//SignUp functions end here.
//Other functions start here.
    
    func setAlertController(message: String) {
        
        let alertController = UIAlertController(title: "", message: "\(message)", preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func allFieldsAreNotEmpty() -> Bool {
        
        if self.imageView.image == nil {
            self.setAlertController("Please add a photo")
        } else if self.firstNameTextField.text == "" {
            self.setAlertController("Please enter your first name")
        } else if self.lastNameTextField.text == "" {
            self.setAlertController("Please enter your last name")
        } else if self.emailTextField.text == "" {
            self.setAlertController("Please enter your email")
        } else if self.passwordTextField.text == "" {
            self.setAlertController("Please enter your password")
        } else if self.confirmPasswordTextField.text == "" {
            self.setAlertController("Please enter your confirmation password")
        } else if self.verificationTextField.text == "" {
            self.setAlertController("Please enter your verification code")
        } else if self.provinceTextField.text == "" {
            self.setAlertController("Please enter your province")
        } else if self.cityTextField.text == "" {
            self.setAlertController("Please enter your city")
        } else if self.streetTextField.text == "" {
            self.setAlertController("Please enter your street")
        } else if self.postalCodeTextField.text == "" {
            self.setAlertController("Please enter your postal code")
        } else if self.phoneNumberTextField.text == "" {
            self.setAlertController("Please enter your phone number")
        } else {
            return true
        }
        return false
    }
    
    func isValidEmail() -> Bool {
        return true
    }
    
    func passwordIsConfirmed() -> Bool {
        if self.passwordTextField.text != self.confirmPasswordTextField.text {
            self.setAlertController("Passwords do not match.")
            return false
        }
        return true
    }
    
    func isValidVerificationCode() -> Bool {
        return true
    }
    
//Other functions end here.
//Segue functions start here.

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//Segue functions end here.
    
    
    
    
    
    
//    @IBAction func signUpButtonTapped(sender: AnyObject) {
//        var ready = false
//        
//        let user = PFUser()
//        user["firstName"] = firstNameTextField.text
//        user["lastName"] = lastNameTextField.text
//        user["fullName"] = firstNameTextField.text! + " " + lastNameTextField.text!
//        user.email = emailTextField.text
//        user.password = passwordTextField.text
//        user.username = emailTextField.text
//        //Try taking the verificaiton code to parse saving out. 
//        user["verificationCode"] = verificationTextField.text
//
//        //user["type"] is also included down below
//        
//        if self.firstNameTextField.text == "" {
//            setAlertControllerMessage("Please enter your first name")
//        } else if self.lastNameTextField.text == "" {
//            setAlertControllerMessage("Please enter your last name")
//        } else if self.emailTextField.text == "" {
//            setAlertControllerMessage("Please enter your email address")
//        } else if self.passwordTextField.text == "" {
//            setAlertControllerMessage("Please enter your password")
//        } else if self.verificationTextField.text == "" {
//            setAlertControllerMessage("Please enter the verification code")
//        } else {
//            ready = true;
//        }
//        
//        //if I can check for whether the email is a valid email here, that would be awesome.
//        
//        if ready == true {
//            if self.verificationTextField.text == "office" {
//                user["userType"] = "office"
//            } else if self.verificationTextField.text == "giver" {
//                user["userType"] = "giver"
//            } else if self.verificationTextField.text == "cathy" {
//                user["userType"] = "cathy"
//            } else {
//                setAlertControllerMessage("Incorrect verification code")
//                ready = false
//            }
//        }
//        
//        if ready == true {
//            
//            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
//            activityIndicator.hidden = false
//            activityIndicator.startAnimating()
//            
//            user.signUpInBackgroundWithBlock {
//                (succeeded: Bool, error: NSError?) -> Void in
//                if let error = error {
//                    
//                    var errorString = error.userInfo["error"] as! NSString
//                    if errorString == "invalid email address" {
//                        errorString = "Invalid email address"
//                    } else if errorString == "username \(self.emailTextField.text!) already taken" {
//                        errorString = "The email \(self.emailTextField.text!) is already taken"
//                    }
//                    self.setAlertControllerMessage("\(errorString)")
//                    
//                } else {
//
//                    if self.verificationTextField.text == "office" {
//                        self.performSegueWithIdentifier("signUpToOffice", sender: nil)
//                    } else if self.verificationTextField.text == "giver" {
//                        
//                        let giverList = PFObject(className:"GiverList")
//                        giverList["giverId"] = PFUser.currentUser()?.objectId
//                        giverList["giverName"] = self.firstNameTextField.text! + " " + self.lastNameTextField.text!
//                        giverList["giverEmail"] = self.emailTextField.text!
//                        giverList["alreadyAddedByOffice"] = false
//                        giverList.saveInBackgroundWithBlock {
//                            (success: Bool, error: NSError?) -> Void in
//                            if (success) {
//
//                            } else {
//                                print(error?.description)
//                                // There was a problem, check error.description
//                            }
//                        }
//                        
//                        self.performSegueWithIdentifier("signUpToGiver", sender: nil)
//                    } else if self.verificationTextField.text == "cathy" {
//                        
//                        let cathyList = PFObject(className: "CathyList")
//                        cathyList["cathyName"] = self.firstNameTextField.text! + " " + self.lastNameTextField.text!
//                        cathyList["cathyId"] = PFUser.currentUser()?.objectId
//                        cathyList["cathyEmail"] = self.emailTextField.text!
//                        cathyList["alreadyAddedByOffice"] = false
//                        cathyList.saveInBackgroundWithBlock {
//                            (success: Bool, error: NSError?) -> Void in
//                            if (success) {
//                                
//                            } else {
//                                print(error?.description)
//                                // There was a problem, check error.description
//                            }
//                        }
//
//                        self.performSegueWithIdentifier("signUpToCathy", sender: nil)
//                    }
//                    
//                }
//                
//                UIApplication.sharedApplication().endIgnoringInteractionEvents()
//                self.activityIndicator.hidden = true
//                
//            }
//        }
//    }
//    
//    func setAlertControllerMessage(message: String) {
//        let alertController = UIAlertController(title: "", message: "\(message)", preferredStyle: UIAlertControllerStyle.Alert)
//        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
//        alertController.addAction(defaultAction)
//        presentViewController(alertController, animated: true, completion: nil)
//    }
    

    
    
    


}
