//
//  UserProfileViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 4/11/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var noPhotoLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emergencyPhoneNumberLabel: UILabel!
    
    @IBOutlet weak var provinceLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var streetOneLabel: UILabel!
    @IBOutlet weak var streetTwoLabel: UILabel!
    @IBOutlet weak var streetThreeLabel: UILabel!
    @IBOutlet weak var postalCodeLabel: UILabel!

    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var emergencyButton: UIButton!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var phoneCallButton: UIButton!
    @IBOutlet weak var emergencyCallButton: UIButton!
    
    @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var isBeingViewedByOfficeUser: Bool = true
    
    var selectedUserType: UserType!
    var userInformation: PFObject!
    var userObjectId: String = String()
    
    var classNameForCloud: ClassNameForCloud = ClassNameForCloud()
    
    var image: UIImage?
    var email: String!
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
    
    func setUserInformation() {

        
        if self.name != "" {
            self.nameLabel.text = self.name
        } else {
            self.nameLabel.text = ""
        }
        
        if self.email != "" {
            self.userIdLabel.text = self.email
        } else {
            self.userIdLabel.text = ""
        }
        
        if self.phoneNumber != "" {
            self.phoneButton.enabled = true
            self.phoneCallButton.hidden = false
            self.phoneNumberLabel.text = self.phoneNumber
        } else {
            self.phoneButton.enabled = false
            self.phoneCallButton.hidden = true
            self.phoneNumberLabel.text = " "
        }
        
        if self.emergencyPhoneNumber != "" {
            self.emergencyButton.enabled = true
            self.emergencyCallButton.hidden = false
            self.emergencyPhoneNumberLabel.text = self.emergencyPhoneNumber
        } else {
            self.emergencyButton.enabled = false
            self.emergencyCallButton.hidden = true
            self.emergencyPhoneNumberLabel.text = " "
        }
        
        if self.province == "" {
            self.provinceLabel.text = ""
        } else {
            self.provinceLabel.text = self.province
        }
        
        if self.city == "" {
            self.cityLabel.text = ""
        } else {
            self.cityLabel.text = self.city
        }
        
        if self.district == "" {
            self.districtLabel.text = ""
        } else {
            self.districtLabel.text = self.district
        }
        
        if self.streetOne == "" {
            self.streetOneLabel.text = ""
        } else {
            self.streetOneLabel.text = self.streetOne
        }
        
        if self.streetTwo == "" {
            self.streetTwoLabel.text = ""
        } else {
            self.streetTwoLabel.text = self.streetTwo
        }
        
        if self.streetThree == "" {
            self.streetThreeLabel.text = ""
        } else {
            self.streetThreeLabel.text = self.streetThree
        }
        
        if self.postalCode == "" {
            self.postalCodeLabel.text = ""
        } else {
            self.postalCodeLabel.text = self.postalCode
        }
        
        self.addressButton.enabled = true
        
        if self.streetOne == "" && self.streetTwo == "" && self.streetThree == "" && self.city == "" && self.province == "" && self.postalCode == "" {
            self.addressButton.enabled = false
            self.provinceLabel.text = " "
        }

        
        self.textView.text = self.notes
        
    }
    
    func attemptQueryingUserInformationWithUserObjectId(completion: (querySuccessful: Bool, userInformation: PFObject?) -> Void) {
        
        let query = PFQuery(className: classNameForCloud.getClassName(self.selectedUserType)!)
        query.fromLocalDatastore()
        query.getObjectInBackgroundWithId(self.userObjectId) { (userInformation: PFObject?, error: NSError?) -> Void in
            if error == nil {
                userInformation?.pinInBackground()
                completion(querySuccessful: true, userInformation: userInformation)
            } else {
                completion(querySuccessful: false, userInformation: nil)
                print(error)
            }
        }

    }
    
    func unpackUserInformation(userInformation: PFObject) {
        
        self.name = userInformation["name"] as! String
        
        if self.selectedUserType == UserType.client {
            self.email = userInformation.objectId!
        } else {
            self.email = userInformation["email"] as! String
        }
        
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
        
        if let imageFile = userInformation["imageFile"] {
            imageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                if error != nil {
                    print(error)
                } else {
                    self.image = UIImage(data: imageData!)
                    self.setImageView()
                }
            })
        }
  
    }
    
    func setNavigationBarTitle() {
        
        if self.selectedUserType == UserType.client {
            self.navigationItem.title = "Client User"
        } else if self.selectedUserType == UserType.cathy {
            self.navigationItem.title = "Cathy User"
        } else if self.selectedUserType == UserType.careGiver {
            self.navigationItem.title = "CareGiver User"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = "User Profile"
        self.noPhotoLabel.textAlignment = .Center
        self.setNavigationBarTitle()
        
        if self.isBeingViewedByOfficeUser == false {
            self.editButton.tintColor = UIColor.clearColor()
            self.editButton.enabled = false
        }

        
    }
    
    func setImageView() {
        
        self.imageView.layer.masksToBounds = false
        self.imageView.clipsToBounds = true
        self.imageView.layer.cornerRadius = self.imageViewHeightLayoutConstraint.constant / 2
        
        if let image = self.image {
            self.imageView.image = image
            self.noPhotoLabel.hidden = true
            self.imageView.layer.borderWidth = 0.0
        } else {
            self.imageView.layer.borderWidth = 1.0
            self.imageView.layer.borderColor = UIColor.lightGrayColor().CGColor
            self.imageView.image = nil
            self.noPhotoLabel.hidden = false
        }
     
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.attemptQueryingUserInformationWithUserObjectId { (querySuccessful, userInformation) -> Void in
            if querySuccessful {
                self.userInformation = userInformation!
                self.unpackUserInformation(userInformation!)
                self.setUserInformation()
            }
        }
        self.setImageView()

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let navigationController = segue.destinationViewController as? UINavigationController {
            if let officeEditUserProfileViewController = navigationController.topViewController as? OfficeEditUserProfileViewController {
                officeEditUserProfileViewController.selectedUserType = self.selectedUserType
                officeEditUserProfileViewController.userInformation = self.userInformation
                officeEditUserProfileViewController.userObjectId = self.userObjectId

            } else {
                print("officeAddUserTableViewController returned nil")
            }
        } else {
            print("navigationController returned nil")
        }
        
    }
    
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {
        
    }

}
