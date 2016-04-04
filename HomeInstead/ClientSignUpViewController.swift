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
    
    @IBAction func previousButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func nextButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func addAnotherClientButtonTapped(sender: AnyObject) {
        
    }
   
    @IBAction override func signUpButtonTapped(sender: AnyObject) {
        
    }
    
}






















