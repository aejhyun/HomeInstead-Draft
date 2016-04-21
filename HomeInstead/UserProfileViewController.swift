//
//  UserProfileViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 4/11/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var emailLabel: UILabel!
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

    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var emergencyButton: UIButton!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var phoneCallButton: UIButton!
    @IBOutlet weak var emergencyCallButton: UIButton!
    
    @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var selectedUserType: UserType!
    var user: [String: String] = [String: String]()
    
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
    
    func unpackUserInformation() {
        
        self.name = self.user["name"]
        if self.selectedUserType == UserType.client {
            self.email = self.user["objectId"]
        } else {
            self.email = self.user["email"]
        }
        self.phoneNumber = self.user["phoneNumber"]
        self.emergencyPhoneNumber = self.user["emergencyPhoneNumber"]
        self.province = self.user["province"]
        self.city = self.user["city"]
        self.district = self.user["district"]
        self.streetOne = self.user["streetOne"]
        self.streetTwo = self.user["streetTwo"]
        self.streetThree = self.user["streetThree"]
        self.postalCode = self.user["postalCode"]
        self.notes = self.user["notes"]
        
    }
    
    func setImageView() {

        self.imageView.layer.masksToBounds = false
        self.imageView.clipsToBounds = true
        self.imageView.layer.cornerRadius = self.imageViewHeightLayoutConstraint.constant / 2
        
    }
    
    func setUserInformation() {
        self.setImageView()
        
        if let image = self.user["image"] {
            self.image = image as? UIImage
            self.imageView.image = self.image
            self.noPhotoLabel.hidden = true
            self.imageView.layer.borderWidth = 0.0
        } else {
            self.imageView.layer.borderWidth = 1.0
            self.imageView.layer.borderColor = UIColor.lightGrayColor().CGColor
            self.imageView.image = nil
            self.noPhotoLabel.hidden = false
        }
        
        if self.name != "" {
            self.nameLabel.text = self.name
        } else {
            self.nameLabel.text = ""
        }
        
        if self.email != "" {
            self.emailLabel.text = self.email
        } else {
            self.emailLabel.text = ""
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = "User Profile"
        self.noPhotoLabel.textAlignment = .Center
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.setImageView()
        self.unpackUserInformation()
        self.setUserInformation()

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let navigationController = segue.destinationViewController as? UINavigationController {
            if let officeEditUserProfileViewController = navigationController.topViewController as? OfficeEditUserProfileViewController {
                
                officeEditUserProfileViewController.user = self.user

            } else {
                print("officeAddUserTableViewController returned nil")
            }
        } else {
            print("navigationController returned nil")
        }
        
    }
    
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {
        
        if let officeEditUserProfileViewController = segue.sourceViewController as? OfficeEditUserProfileViewController {
            self.user = officeEditUserProfileViewController.user
            
        }
        
    }

    

    
    
    
    
    
    
    
}
