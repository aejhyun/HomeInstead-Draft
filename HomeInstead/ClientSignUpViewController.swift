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
        
        self.nameTextField.text = "Meong Choi"
        self.provinceTextField.text = "Hubei Province"
        self.cityTextField.text = "Hanyang"
        self.streetOneTextField.text = "31342 Washing St."
        self.streetTwoTextField.text = ""
        self.streetThreeTextField.text = ""
        self.postalCodeTextField.text = "94542"
        self.phoneNumberTextField.text = "9535136902"
        self.emergencyPhoneNumberTextField.text = "4312047283"
        
    }
    
    override func viewDidLoad() {
        
        self.setDefaultTextFieldValues()
        
        self.addPhotoButton.titleLabel?.textAlignment = .Center
        self.editButton.hidden = true
        self.nameTextField.becomeFirstResponder()
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
        
        if self.nameTextField.text == "" {
            self.presentAlertControllerWithMessage("Please enter your name")
        } else {
            return true
        }
        return false
        
    }
    
    override func uploadUserInformationToCloud(completion: (uploadSuccessful: Bool) -> Void) {
        
        let user = PFUser()
        user["firstName"] = self.cathyUserInformation["firstName"]
        user["lastName"] = self.cathyUserInformation["lastName"]
        user["userType"] = self.selectedUserType.rawValue
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
        
        let imageFile: NSData? = self.getImageFile()
        
        let object = PFObject(className: className)
        object["name"] = self.nameTextField.text
        object["id"] = PFUser.currentUser()?.objectId
        object["email"] = self.emailTextField.text!
        object["province"] = self.provinceTextField.text
        object["city"] = self.cityTextField.text
        object["streetOne"] = self.streetOneTextField.text
        object["streetTwo"] = self.streetTwoTextField.text
        object["streetThree"] = self.streetThreeTextField.text
        object["postalCode"] = self.postalCodeTextField.text
        object["phoneNumber"] = self.phoneNumberTextField.text
        object["emergencyPhoneNumber"] = self.emergencyPhoneNumberTextField.text
        if imageFile != nil {
            object["imageFile"] = imageFile
        }
        
        object.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Successfully uploaded \(self.nameTextField)'s information to cloud under the class name \"\(className)\".")
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






















