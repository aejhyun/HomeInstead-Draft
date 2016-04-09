//
//  ClientSignUpViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 4/3/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class ClientSignUpViewController: SignUpViewController {
    
    var cathyUserInformation: [String: NSObject] = [String: NSObject]()
    
    override func setDefaultTextFieldValues() {
        
        self.firstNameTextField.text = "Meong"
        self.lastNameTextField.text = "Choi"
        self.provinceTextField.text = "Hubei Province"
        self.cityTextField.text = "Hanyang"
        self.streetTextField.text = "31342 Washing St."
        self.postalCodeTextField.text = "94542"
        self.phoneNumberTextField.text = "9535136902"
        self.emergencyPhoneNumberTextField.text = "4312047283"
        
    }
    
    override func viewDidLoad() {
        
        self.setDefaultTextFieldValues()
        
        self.addPhotoButton.titleLabel?.textAlignment = .Center
        self.editButton.hidden = true
        self.firstNameTextField.becomeFirstResponder()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.title = "Client Sign Up"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
        
        print(self.cathyUserInformation)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.view.endEditing(true);
    }   
    
//Other functions start here.

    override func allRequiredFieldsAreNotEmpty() -> Bool {
        
        if self.firstNameTextField.text == "" {
            self.presentAlertControllerWithMessage("Please enter your first name")
        } else if self.lastNameTextField.text == "" {
            self.presentAlertControllerWithMessage("Please enter your last name")
        } else {
            return true
        }
        return false
        
    }
    
    override func uploadUserInformationToCloud(completion: (uploadSuccessful: Bool) -> Void) {
        
        let user = PFUser()
        user["firstName"] = self.cathyUserInformation["firstName"]
        user["lastName"] = self.cathyUserInformation["lastName"]
        user["userType"] = self.userTypeSelected.rawValue
        user.email = self.cathyUserInformation["email"] as? String
        user.password = self.cathyUserInformation["password"] as? String
        user.username = self.cathyUserInformation["email"] as? String
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                self.presentAlertControllerWithMessage("\(self.emailErrorMessage(error))")
                completion(uploadSuccessful: false)
            } else {
                completion(uploadSuccessful: true)
            }
        }
        
    }
    
    override func uploadUserInformationToCloudWithClassName(className: String, completion: (uploadSuccessful: Bool) -> Void) {
        
        let fullName: String = self.firstNameTextField.text! + " " + self.lastNameTextField.text!
        let imageFile: NSData? = self.getImageFile()
        
        let object = PFObject(className: className)
        object["name"] = fullName
        object["id"] = PFUser.currentUser()?.objectId
        object["email"] = self.emailTextField.text!
        object["province"] = self.provinceTextField.text
        object["city"] = self.cityTextField.text
        object["street"] = self.streetTextField.text
        object["postalCode"] = self.postalCodeTextField.text
        object["phoneNumber"] = self.phoneNumberTextField.text
        object["emergencyPhoneNumber"] = self.emergencyPhoneNumberTextField.text
        if imageFile != nil {
            object["imageFile"] = imageFile
        }
        
        object.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Successfully uploaded \(self.firstNameTextField.text!)'s information to cloud under the class name \"\(className)\".")
                completion(uploadSuccessful: true)
            } else {
                self.presentAlertControllerWithMessage("\(error?.description)")
                print(error?.description)
                completion(uploadSuccessful: false)
            }
        }
        
    }
    
//Other functions end here.
//Button functions start here.
    
    @IBAction func previousButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func nextButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func addAnotherClientButtonTapped(sender: AnyObject) {
        
        if self.allRequiredFieldsAreNotEmpty() {
            self.setImageView()
            self.editButton.hidden = true
            self.addPhotoButton.hidden = false
            self.firstNameTextField.text = ""
            self.lastNameTextField.text = ""
            self.provinceTextField.text = ""
            self.cityTextField.text = ""
            self.streetTextField.text = ""
            self.postalCodeTextField.text = ""
            self.phoneNumberTextField.text = ""
            self.emergencyPhoneNumberTextField.text = ""
        }
        
    }
   
    @IBAction override func signUpButtonTapped(sender: AnyObject) {
        if self.allRequiredFieldsAreNotEmpty() {
            self.uploadUserInformationToCloud({ (uploadSuccessful) -> Void in
                print("segue")
            })
        }
    }
    
//Button functions end here.
    
}






















