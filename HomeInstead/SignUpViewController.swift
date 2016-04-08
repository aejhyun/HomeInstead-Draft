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
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var verificationCodeTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emergencyPhoneNumberTextField: UITextField!
    
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    var numberOfTimesViewLaidOutSubviews: Int = 0
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var clientSignUpButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeTextField: UITextField?
    var accountTypeSelected: AccountType!
    
    func setDefaultTextFieldValues() {
        
        self.firstNameTextField.text = "Jae"
        self.lastNameTextField.text = "Kim"
        self.emailTextField.text = "test6@gmail.com"
        self.passwordTextField.text = "password"
        self.confirmPasswordTextField.text = "password"
        self.verificationCodeTextField.text = "office"
        self.provinceTextField.text = "湖北"
        self.cityTextField.text = "武汉"
        self.streetTextField.text = "19300 Nassau St."
        self.postalCodeTextField.text = "92508"
        self.phoneNumberTextField.text = "9518077192"
        self.emergencyPhoneNumberTextField.text = "4350937283"
        
    }
    
    func setImageView() {
        
        self.imageView.image = nil
        self.imageView.layer.borderWidth = 1
        self.imageView.layer.masksToBounds = false
        self.imageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.imageView.layer.cornerRadius = self.imageViewHeightLayoutConstraint.constant / 2
        self.imageView.clipsToBounds = true
        
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
        
        if self.allRequiredFieldsAreNotEmpty() && self.passwordConfirmed() && self.isValidVerificationCode() {
            self.performSegueWithIdentifier("signUpToClientSignUp", sender: nil)
        }
        
    }
    
    @IBAction func signUpButtonTapped(sender: AnyObject) {
        
        if self.allRequiredFieldsAreNotEmpty() && self.passwordConfirmed() && self.isValidVerificationCode() {
            self.uploadUserInformationToCloud({ (uploadSuccessful) -> Void in
                if uploadSuccessful {
                    
                    if self.accountTypeSelected == AccountType.Office {
                        self.uploadUserInformationToCloudWithClassName("OfficeUser", completion: { (uploadSuccessful) -> Void in
                            print("segue1")
                        })
                    } else if self.accountTypeSelected == AccountType.CareGiver {
                        self.uploadUserInformationToCloudWithClassName("CareGiverUser", completion: { (uploadSuccessful) -> Void in
                            print("segue2")
                        })
                    }
                    
                } else {
                    print("Upload was not successful")
                }
            })
        }

    }
    
//SignUp functions end here.
//Other functions start here.
    
    func uploadUserInformationToCloud(completion: (uploadSuccessful: Bool) -> Void) {
        
        let user = PFUser()
        user["firstName"] = self.firstNameTextField.text
        user["lastName"] = self.lastNameTextField.text
        user["accountType"] = self.accountTypeSelected.rawValue
        user.email = self.emailTextField.text
        user.password = self.passwordTextField.text
        user.username = self.emailTextField.text
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                self.setAlertController("\(self.emailErrorMessage(error))")
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
    
    func returnCathyUserInformationInDictionary() -> Dictionary <String, NSObject> {
        
        let fullName: String = self.firstNameTextField.text! + " " + self.lastNameTextField.text!
        let imageFile: NSData? = self.getImageFile()
        
        var cathyUserInformation = [String: NSObject]()
        cathyUserInformation["id"] = PFUser.currentUser()?.objectId
        cathyUserInformation["name"] = fullName
        cathyUserInformation["email"] = self.emailTextField.text
        cathyUserInformation["province"] = self.provinceTextField.text
        cathyUserInformation["city"] = self.cityTextField.text
        cathyUserInformation["street"] = self.streetTextField.text
        cathyUserInformation["postalCode"] = self.postalCodeTextField.text
        cathyUserInformation["phoneNumber"] = self.phoneNumberTextField.text
        cathyUserInformation["emergencyPhoneNumber"] = self.emergencyPhoneNumberTextField.text
        cathyUserInformation["imageFile"] = imageFile
        cathyUserInformation["alreadyAddedByOfficeUser"] = false
        
        return cathyUserInformation
        
    }
    
    func uploadUserInformationToCloudWithClassName(className: String, completion: (uploadSuccessful: Bool) -> Void) {
        
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
                self.setAlertController("\(error?.description)")
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
        
        if self.firstNameTextField.text == "" {
            self.setAlertController("Please enter your first name")
        } else if self.lastNameTextField.text == "" {
            self.setAlertController("Please enter your last name")
        } else if self.emailTextField.text == "" {
            self.setAlertController("Please enter your email")
        } else if self.passwordTextField.text == "" {
            self.setAlertController("Please enter your password")
        } else if self.confirmPasswordTextField.text == "" {
            self.setAlertController("Please enter your confirmation password")
        } else if self.verificationCodeTextField.text == "" {
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
    
    func passwordConfirmed() -> Bool {
        if self.passwordTextField.text != self.confirmPasswordTextField.text {
            self.setAlertController("Passwords do not match.")
            return false
        }
        return true
    }
    
    func isValidVerificationCode() -> Bool {
        
        let verificationCode = VerificationCode()
        
        if self.accountTypeSelected == AccountType.Office {
            if self.verificationCodeTextField.text == verificationCode.office {
                return true
            }
        } else if self.accountTypeSelected == AccountType.CareGiver {
            if self.verificationCodeTextField.text == verificationCode.careGiver {
                return true
            }
        } else if self.accountTypeSelected == AccountType.Cathy {
            if self.verificationCodeTextField.text == verificationCode.cathy {
                return true
            }
        }
        self.setAlertController("Incorrect verification code")
        return false
        
    }
    
    func setAlertController(message: String) {
        
        let alertController = UIAlertController(title: "", message: "\(message)", preferredStyle: UIAlertControllerStyle.Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
//Other functions end here.
//Segue functions start here.
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "signUpToClientSignUp" {
            if let clientSignUpViewController = segue.destinationViewController as? ClientSignUpViewController {
            
                let cathyUserInformation: [String: NSObject] = self.returnCathyUserInformationInDictionary()
                clientSignUpViewController.cathyUserInformation = cathyUserInformation
                
            } else {
                print("clientSignUpViewController returned nil")
            }
        }
        
    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//Segue functions end here.
    
    


}
