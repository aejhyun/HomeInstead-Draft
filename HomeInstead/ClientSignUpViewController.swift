//
//  ClientSignUpViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 4/3/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class ClientSignUpViewController: SignUpViewController {

    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
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
        
        print(cathyUserInformation)
        
        self.setDefaultTextFieldValues()
        
        self.previousButton.hidden = true
        self.previousButton.alpha = 0.0
        self.nextButton.hidden = true
        self.nextButton.alpha = 0.0
        
        self.addPhotoButton.titleLabel?.textAlignment = .Center
        self.editButton.hidden = true
        self.firstNameTextField.becomeFirstResponder()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationItem.title = "Client Sign Up"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
        
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
            self.setAlertController("Please enter your first name")
        } else if self.lastNameTextField.text == "" {
            self.setAlertController("Please enter your last name")
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
            print("success")
        }
    }
    
//Button functions end here.
    
}






















