//
//  OfficeCreateClientUserViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 4/18/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class OfficeCreateClientUserViewController: OfficeEditUserProfileViewController {

    override func viewDidLoad() {
        
        self.addPhotoButton.titleLabel?.textAlignment = .Center
        self.addPhotoButton.alpha = 1.0
        self.editButton.hidden = true
        self.editButton.alpha = 0.0
        
        self.nameTextField.becomeFirstResponder()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.gestureRecognizer = UITapGestureRecognizer(target: self, action: "textViewTapped:")
        self.notesTextView.addGestureRecognizer(gestureRecognizer)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)

    
    }
    
    func uploadClientUserInformationToCloud(completion: (uploadSuccessful: Bool) -> Void) {
        
        let imageFile: NSData? = self.getImageFile()
        
        let object = PFObject(className: "ClientUser")
        object["name"] = self.nameTextField.text
        object["userType"] = "client"
        object["province"] = self.provinceTextField.text
        object["city"] = self.cityTextField.text
        object["district"] = self.districtTextField.text
        object["streetOne"] = self.streetOneTextField.text
        object["streetTwo"] = self.streetTwoTextField.text
        object["streetThree"] = self.streetThreeTextField.text
        object["postalCode"] = self.postalCodeTextField.text
        object["phoneNumber"] = self.phoneNumberTextField.text
        object["emergencyPhoneNumber"] = self.emergencyPhoneNumberTextField.text
        object["notes"] = ""
        
        if imageFile != nil {
            object["imageFile"] = imageFile
        }
        
        object.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Successfully uploaded \(self.nameTextField.text!)'s information to the cloud under the class name ClientUser.")
                completion(uploadSuccessful: true)
            } else {
                print(error?.description)
                completion(uploadSuccessful: false)
            }
        }
        
    }
    
    @IBAction func createButtonTapped(sender: AnyObject) {
        
        self.uploadClientUserInformationToCloud { (uploadSuccessful) -> Void in
            if uploadSuccessful {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
    }


    



}
