//
//  OfficeEditUserProfileViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 4/12/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class OfficeEditUserProfileViewController: SignUpViewController {
    
    @IBOutlet weak var notesTextView: UITextView!
    var gestureRecognizer: UIGestureRecognizer!
    var activeTextView: UITextView!
    
    var userInformation: PFObject!
    
    var image: UIImage?
    var name: String!
    var phoneNumber: String!
    var emergencyPhoneNumber: String!
    var province: String!
    var city: String!
    var district: String!
    var streetOne: String!
    var streetTwo: String!
    var streetThree: String!
    var postalCode: String!
    var notes: String!
    var userObjectId: String!
    
    func unpackUserInformation() {
        
        self.image = nil
        self.name = userInformation["name"] as! String
        self.phoneNumber = userInformation["phoneNumber"] as! String
        self.emergencyPhoneNumber = userInformation["emergencyPhoneNumber"] as! String
        self.province = userInformation["province"] as! String
        self.city = userInformation["city"] as! String
        self.district = userInformation["district"] as! String
        self.streetOne = userInformation["streetOne"] as! String
        self.streetTwo = userInformation["streetTwo"] as! String
        self.streetThree = userInformation["streetThree"] as! String
        self.postalCode = userInformation["postalCode"] as! String
        self.notes = userInformation["notes"] as! String

    }
    
    func setUserInformation() {

        self.imageView.image = self.image
        self.nameTextField.text = self.name
        self.phoneNumberTextField.text = self.phoneNumber
        self.emergencyPhoneNumberTextField.text = self.emergencyPhoneNumber
        self.provinceTextField.text = self.province
        self.cityTextField.text = self.city
        self.districtTextField.text = self.district
        self.streetOneTextField.text = self.streetOne
        self.streetTwoTextField.text = self.streetTwo
        self.streetThreeTextField.text = self.streetThree
        self.postalCodeTextField.text = self.postalCode
        self.notesTextView.text = self.notes
        
    }
    
    override func setNavigationBarTitle() {
        
        if self.selectedUserType == UserType.client {
            self.navigationItem.title = "Client User"
        } else if self.selectedUserType == UserType.cathy {
            self.navigationItem.title = "Cathy User"
        } else if self.selectedUserType == UserType.careGiver {
            self.navigationItem.title = "CareGiver User"
        }
        
    }
    
    override func viewDidLoad() {

        self.unpackUserInformation()
        self.setUserInformation()
        self.setNavigationBarTitle()

        self.addPhotoButton.titleLabel?.textAlignment = .Center
        self.editButton.hidden = true
        self.nameTextField.becomeFirstResponder()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.gestureRecognizer = UITapGestureRecognizer(target: self, action: "textViewTapped:")
        self.notesTextView.addGestureRecognizer(gestureRecognizer)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)

        
    }
    
    override func setImageView() {
        
        self.imageView.alpha = 0.0
        self.imageView.layer.borderWidth = 0
        self.imageView.layer.masksToBounds = false
        self.imageView.layer.cornerRadius = self.imageViewHeightLayoutConstraint.constant / 2
        self.imageView.clipsToBounds = true
        
        if self.image != nil {
            self.imageView.alpha = 1.0
        }
        
    }
    
    override func setBorderImageView() {
        
        self.borderImageView.image = nil
        self.borderImageView.alpha = 1.0
        self.borderImageView.layer.borderWidth = 1
        self.borderImageView.layer.masksToBounds = false
        self.borderImageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.borderImageView.layer.cornerRadius = self.imageViewHeightLayoutConstraint.constant / 2
        self.borderImageView.clipsToBounds = true
        
        if self.image != nil {
            self.borderImageView.alpha = 0.0
        }
        
    }
    
    func setImageButtons() {
        
        if self.image != nil {
            self.addPhotoButton.alpha = 0.0
            self.addPhotoButton.hidden = true
            self.editButton.alpha = 1.0
            self.editButton.hidden   = false
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        
        if self.numberOfTimesViewLaidOutSubviews == 1 {
            //The imageView set up is inside self.numberOfTimesViewLaidOutSubviews == 1 check because the code below will be called more than once. And the imageView set up is not in viewDidLoad() because, self.imageView.frame returned was the incorrect value. It returns the correct self.imageView.frame value either in the viewDidLayoutSubviews and viewWillAppear functions. But in the viewWillAppear function causes the image to show up visibly late.
            
            self.setImageView()
            self.setBorderImageView()
            self.setImageButtons()
        }
        self.numberOfTimesViewLaidOutSubviews++
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.notesTextView.resignFirstResponder()
    }
    
    func textViewTapped(gestureRecognizer: UIGestureRecognizer) {
        self.notesTextView.becomeFirstResponder()
        self.activeTextView = self.notesTextView
        self.activeTextField = nil
    }
    
    func setScrollViewWhenKeyBoardDidShow(keyboardSize: CGRect) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        var aRect = self.view.frame
        aRect.size.height -= keyboardSize.size.height
        
    }
    
    override func keyboardDidShow(notification: NSNotification) {
        
        if let activeTextField = self.activeTextField, keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            self.setScrollViewWhenKeyBoardDidShow(keyboardSize)
            self.scrollView.scrollRectToVisible(activeTextField.frame, animated: true)
            
        } else if let activeTextView = self.activeTextView, keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
 
            self.setScrollViewWhenKeyBoardDidShow(keyboardSize)
            self.scrollView.scrollRectToVisible(activeTextView.frame, animated: true)
            
        }
        
    }
    
    func attemptUpdatingUserInformationToCloudWithClassName(className: String, completion: (updateSuccessful: Bool) -> Void) {
        
        let imageFile: PFFile? = self.getImageFile()
        
        let query = PFQuery(className: className)
        query.getObjectInBackgroundWithId(self.userObjectId) {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
                completion(updateSuccessful: false)
            } else if let object = object {
                
                object["name"] = self.nameTextField.text
                object["province"] = self.provinceTextField.text
                object["city"] = self.cityTextField.text
                object["district"] = self.districtTextField.text
                object["streetOne"] = self.streetOneTextField.text
                object["streetTwo"] = self.streetTwoTextField.text
                object["streetThree"] = self.streetThreeTextField.text
                object["postalCode"] = self.postalCodeTextField.text
                object["phoneNumber"] = self.phoneNumberTextField.text
                object["emergencyPhoneNumber"] = self.emergencyPhoneNumberTextField.text
                object["notes"] = self.notesTextView.text
                if imageFile != nil {
                    object["imageFile"] = imageFile
                }
                object.pinInBackground()
                object.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                    if let error = error {
                        print(error)
                        self.presentAlertControllerWithMessage("There was an error updating the user's information")
                        completion(updateSuccessful: false)
                    } else {
                        completion(updateSuccessful: true)
                        print("Successfully updated \(self.nameTextField.text!)'s information to the cloud under the class name \"\(className)\".")
                    }
                })
                
            }
        }
        
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
    self.attemptUpdatingUserInformationToCloudWithClassName(ClassNameForCloud().getClassName(self.selectedUserType)!) { (uploadSuccessful) -> Void in
            if uploadSuccessful {
                self.performSegueWithIdentifier("officeEditUserProfileToUserProfile", sender: nil)
            }
        }
    }
    
    
    
    


}
