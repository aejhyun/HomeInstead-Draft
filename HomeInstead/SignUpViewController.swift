//
//  SignUpViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 12/10/15.
//  Copyright © 2015 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
// If there is a problem uploading the imageFile to the cloud, then the other fields will also not get uploaded. Fix this problem. 
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var verificationCodeTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var districtTextField: UITextField!
    @IBOutlet weak var streetOneTextField: UITextField!
    @IBOutlet weak var streetTwoTextField: UITextField!
    @IBOutlet weak var streetThreeTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emergencyPhoneNumberTextField: UITextField!
    
    @IBOutlet weak var borderImageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    var numberOfTimesViewLaidOutSubviews: Int = 0
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeTextField: UITextField?
    var selectedUserType: UserType!
    
    func setDefaultTextFieldValues() {
        
        self.nameTextField.text = "Jae Kim"
        self.emailTextField.text = "cathy1@gmail.com"
        self.passwordTextField.text = self.selectedUserType.rawValue
        self.confirmPasswordTextField.text = self.selectedUserType.rawValue
        self.verificationCodeTextField.text = self.selectedUserType.rawValue
        self.provinceTextField.text = "湖北"
        self.cityTextField.text = "武汉"
        self.districtTextField.text = "Gangstah District"
        self.streetOneTextField.text = "19300 Nassau St."
        self.streetTwoTextField.text = ""
        self.streetThreeTextField.text = ""
        self.postalCodeTextField.text = "92508"
        self.phoneNumberTextField.text = "9518077192"
        self.emergencyPhoneNumberTextField.text = "4350937283"
        
    }
    
    func setImageView() {
        
        self.imageView.image = nil
        self.imageView.alpha = 0.0
        self.imageView.layer.borderWidth = 0
        self.imageView.layer.masksToBounds = false
        self.imageView.layer.cornerRadius = self.imageViewHeightLayoutConstraint.constant / 2
        self.imageView.clipsToBounds = true
        
    }
    
    func setBorderImageView() {
        
        self.borderImageView.image = nil
        self.borderImageView.alpha = 1.0
        self.borderImageView.layer.borderWidth = 1
        self.borderImageView.layer.masksToBounds = false
        self.borderImageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.borderImageView.layer.cornerRadius = self.imageViewHeightLayoutConstraint.constant / 2
        self.borderImageView.clipsToBounds = true
        
    }
    
    func setNavigationBarTitle() {
        
        if self.selectedUserType == UserType.cathy {
            self.navigationItem.title = "Cathy Sign Up"
        } else if self.selectedUserType == UserType.careGiver {
            self.navigationItem.title = "CareGiver Sign Up"
        } else if self.selectedUserType == UserType.office {
            self.navigationItem.title = "Office Sign Up"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setDefaultTextFieldValues()
        self.setNavigationBarTitle()
        
        self.addPhotoButton.titleLabel?.textAlignment = .Center
        self.addPhotoButton.alpha = 1.0
        self.editButton.hidden = true
        self.editButton.alpha = 0.0
        
        self.nameTextField.becomeFirstResponder()
        self.automaticallyAdjustsScrollViewInsets = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)

    }
    
    override func viewDidLayoutSubviews() {
        
        if self.numberOfTimesViewLaidOutSubviews == 1 {
            //The imageView set up is inside self.numberOfTimesViewLaidOutSubviews == 1 check because the code below will be called more than once. And the imageView set up is not in viewDidLoad() because, self.imageView.frame returned was the incorrect value. It returns the correct self.imageView.frame value either in the viewDidLayoutSubviews and viewWillAppear functions. But in the viewWillAppear function causes the image to show up visibly late.
            
            self.setImageView()
            self.setBorderImageView()
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
//Image functions start here.
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        print(selectedImage)
        self.imageView.image = selectedImage
        self.imageView.alpha = 1.0
        self.borderImageView.alpha = 0.0
        self.addPhotoButton.hidden = true
        self.addPhotoButton.alpha = 0.0
        self.editButton.hidden = false
        self.editButton.alpha = 1.0
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
        
        alertAction = UIAlertAction(title: "Delete Photo", style: .Default) { (alertAction: UIAlertAction) -> Void in
            
            self.addPhotoButton.hidden = false
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                 self.addPhotoButton.alpha = 1.0
            })
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.editButton.alpha = 0.0
                }, completion: { (Bool) -> Void in
                    self.editButton.hidden = true
            })
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.imageView.alpha = 0.0
                }, completion: { (Bool) -> Void in
                    self.imageView.image = nil
            })
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.borderImageView.alpha = 1.0
            })
            
            
        }
        alertController.addAction(alertAction)
        
        alertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(alertAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
   
//Image functions end here.
//Keyboard functions start here.
    
    func keyboardDidShow(notification: NSNotification) {
        
        if let activeTextField = self.activeTextField, keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
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
    
    @IBAction func signUpButtonTapped(sender: AnyObject) {
        
        if self.allRequiredFieldsAreNotEmpty() && self.passwordConfirmed() && self.isValidVerificationCode() {
            self.attemptUploadUserInformationToCloud({ (uploadSuccessful) -> Void in
                if uploadSuccessful {
                    
                    if let className = ClassNameForCloud().getClassName(self.selectedUserType) {
                        
                        self.attemptUploadUserInformationToCloudWithClassName(className, completion: { (uploadSuccessful) -> Void in
                            if uploadSuccessful {
                                
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                        })
                        
                    }
                    
                } else {
                    self.presentAlertControllerWithMessage("There was an error while trying to sign up")
                }
            })
        }

    }
    
//SignUp functions end here.
//Other functions start here.
    
    func attemptUploadUserInformationToCloud(completion: (uploadSuccessful: Bool) -> Void) {
        
        let user = PFUser()
        user["name"] = self.nameTextField.text
        user["userType"] = self.selectedUserType.rawValue
        user.email = self.emailTextField.text
        user.password = self.passwordTextField.text
        user.username = self.emailTextField.text
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                print(error)
                self.presentAlertControllerWithMessage("\(self.emailErrorMessage(error))")
                completion(uploadSuccessful: false)
            } else {
                completion(uploadSuccessful: true)
            }
        }
        
    }
    
    func emailErrorMessage(error: NSError) -> String {
        
        var errorMessage = error.userInfo["error"] as! NSString
        if errorMessage == "invalid email address" {
            errorMessage = "Invalid email address"
        } else if errorMessage == "username \(self.emailTextField.text!) already taken" {
            errorMessage = "The email \(self.emailTextField.text!) is already taken"
        }
        return errorMessage as String
        
    }
    
    func attemptUploadUserInformationToCloudWithClassName(className: String, completion: (uploadSuccessful: Bool) -> Void) {
        
        let imageFile: NSData? = self.getImageFile()
        
        let object = PFObject(className: className)
        object["name"] = self.nameTextField.text
        object["userId"] = PFUser.currentUser()?.objectId!
        object["userType"] = self.selectedUserType.rawValue
        object["email"] = self.emailTextField.text!
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
        
        if className != ClassNameForCloud().officeUser {
            object["idsOfOfficeUsersWhoAddedThisUser"] = []
            object["clientConnections"] = []
            object["cathyConnections"] = []
            object["careGiverConnections"] = []
        }

        if imageFile != nil {
            object["imageFile"] = imageFile
        }
        
        object.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Successfully uploaded \(self.nameTextField.text!)'s information to the cloud under the class name \"\(className)\".")
                completion(uploadSuccessful: true)
            } else {
                print(error?.description)
                completion(uploadSuccessful: false)
            }
        }
        
    }
    
    func getImageFile() -> NSData? {
        
        var imageFile: NSData? = nil
        
        if self.imageView.image != nil {
            imageFile = UIImageJPEGRepresentation(self.imageView.image!, 1.0)
        } else {
            imageFile = nil
        }
        return imageFile
        
    }
    
    func allRequiredFieldsAreNotEmpty() -> Bool {
        
        if self.nameTextField.text == "" {
            self.presentAlertControllerWithMessage("Please enter your name")
        } else if self.emailTextField.text == "" {
            self.presentAlertControllerWithMessage("Please enter your email")
        } else if self.passwordTextField.text == "" {
            self.presentAlertControllerWithMessage("Please enter your password")
        } else if self.confirmPasswordTextField.text == "" {
            self.presentAlertControllerWithMessage("Please enter your confirmation password")
        } else if self.verificationCodeTextField.text == "" {
            self.presentAlertControllerWithMessage("Please enter your verification code")
        } else if self.provinceTextField.text == "" {
            self.presentAlertControllerWithMessage("Please enter your province")
        } else if self.cityTextField.text == "" {
            self.presentAlertControllerWithMessage("Please enter your city")
        } else if self.districtTextField.text == "" {
            self.presentAlertControllerWithMessage("Please enter your district")
        } else if self.streetOneTextField.text == "" {
            self.presentAlertControllerWithMessage("Please enter your street for street 1")
        } else if self.postalCodeTextField.text == "" {
            self.presentAlertControllerWithMessage("Please enter your postal code")
        } else if self.phoneNumberTextField.text == "" {
            self.presentAlertControllerWithMessage("Please enter your phone number")
        } else {
            return true
        }
        return false
        
    }
    
    func passwordConfirmed() -> Bool {
        if self.passwordTextField.text != self.confirmPasswordTextField.text {
            self.presentAlertControllerWithMessage("Passwords do not match.")
            return false
        }
        return true
    }
    
    func isValidVerificationCode() -> Bool {
        
        let verificationCode = VerificationCode()
        
        if self.selectedUserType == UserType.office {
            if self.verificationCodeTextField.text == verificationCode.office {
                return true
            }
        } else if self.selectedUserType == UserType.careGiver {
            if self.verificationCodeTextField.text == verificationCode.careGiver {
                return true
            }
        } else if self.selectedUserType == UserType.cathy {
            if self.verificationCodeTextField.text == verificationCode.cathy {
                return true
            }
        }
        self.presentAlertControllerWithMessage("Incorrect verification code")
        return false
        
    }
    
    func presentAlertControllerWithMessage(message: String) {
        
        let alertController = UIAlertController(title: "", message: "\(message)", preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
//Other functions end here.
//Segue functions start here.
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        
    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//Segue functions end here.
    
    


}
