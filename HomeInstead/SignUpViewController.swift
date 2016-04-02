//
//  SignUpViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 12/10/15.
//  Copyright © 2015 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
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
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeTextField: UITextField?
    
    var numberOfTimesViewLaidOutSubviews: Int = 0
    
    func setImageView() {
        
        self.imageView.layer.borderWidth = 1
        self.imageView.layer.masksToBounds = false
        self.imageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.imageView.layer.cornerRadius = self.imageViewHeightLayoutConstraint.constant / 2
        self.imageView.clipsToBounds = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addPhotoButton.titleLabel?.textAlignment = .Center
        self.editButton.hidden = true
        self.firstNameTextField.becomeFirstResponder()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)

    }
    
    override func viewDidLayoutSubviews() {
        
        if self.numberOfTimesViewLaidOutSubviews == 1 {
            //The imageView set up is inside self.numberOfTimesViewLaidOutSubviews == 1 check because the code below will be called more than once. And the imageView set up is not in viewDidLoad() because, self.imageView.frame returned was the incorrect value. It returns the correct self.imageView.frame value either in the viewDidLayoutSubviews and viewWillAppear functions. But in the viewWillAppear function causes the image to show up visibly late.
            
            self.setImageView()
        }
        self.numberOfTimesViewLaidOutSubviews++

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
//Image functions start here.
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageView.image = selectedImage
        self.imageView.layer.borderWidth = 0
        self.addPhotoButton.hidden = true
        self.editButton.hidden = false
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func addPhotoButtonTapped(sender: AnyObject) {
        let alertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        var alertAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .Default) { (alertAction: UIAlertAction) -> Void in
            
        }
        alertController.addAction(alertAction)
        
        alertAction = UIAlertAction(title: "Choose Photo", style: .Default) { (alertAction: UIAlertAction) -> Void in
            
            let imagePickerController: UIImagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .PhotoLibrary
            imagePickerController.delegate = self
            
            self.presentViewController(imagePickerController, animated: true, completion: nil)
            
        }
        alertController.addAction(alertAction)
        
        alertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(alertAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func editButtonTapped(sender: AnyObject) {
        
        let alertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        var alertAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .Default) { (alertAction: UIAlertAction) -> Void in
            
        }
        alertController.addAction(alertAction)
        
        alertAction = UIAlertAction(title: "Choose Photo", style: .Default) { (alertAction: UIAlertAction) -> Void in
            let imagePickerController: UIImagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .PhotoLibrary
            imagePickerController.delegate = self
            
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        
        alertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(alertAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

//Image functions end here.
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    
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
