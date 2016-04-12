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
    @IBOutlet weak var noPhotoLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emergencyPhoneNumberLabel: UILabel!
    
    @IBOutlet weak var streetOneLabel: UILabel!
    @IBOutlet weak var streetTwoLabel: UILabel!
    @IBOutlet weak var streetThreeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var provinceLabel: UILabel!
    @IBOutlet weak var postalCodeLabel: UILabel!
    
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var emergencyButton: UIButton!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var phoneCallButton: UIButton!
    @IBOutlet weak var emergencyCallButton: UIButton!
    
    @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var user: [String: NSObject?] = [String: NSObject?]()
    var image: UIImage?
    
    var name: String!
    var phoneNumber: String!
    var emergencyPhoneNumber: String!
    var streetOne: String!
    var streetTwo: String!
    var streetThree: String!
    var city: String!
    var postalCode: String!
    var province: String!
    var notes: String!
    
    func setImageView() {
        
        //The reason for self.imageViewHeightLayoutConstraint is because the imageView's correct height only became available in viewWillDidLoad(). But if I put the setImageView() inside viewWillDidLoad(), you can see the imageView circle being drawn.
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
            self.noPhotoLabel.textAlignment = .Center
        }
        
    }
    
    func unpackUserInformation() {
        
        self.name = self.user["name"]! as? String
        self.phoneNumber = self.user["phoneNumber"]! as? String
        self.emergencyPhoneNumber = self.user["emergencyPhoneNumber"]! as? String
        self.streetOne = self.user["streetOne"]! as? String
        self.streetTwo = self.user["streetTwo"]! as? String
        self.streetThree = self.user["streetThree"] as? String
        self.city = self.user["city"]! as? String
        self.postalCode = self.user["postalCode"]! as? String
        self.province = self.user["province"]! as? String
        self.notes = self.user["notes"]! as? String
        
    }
    
    func setUserInformation() {
        
        if self.name != "" {
            self.nameLabel.text = self.name
        } else {
            self.nameLabel.text = ""
        }
        
        if self.phoneNumber != "" {
            self.phoneButton.enabled = true
            self.phoneCallButton.enabled = true
            self.phoneNumberLabel.text = self.phoneNumber
        } else {
            self.phoneButton.enabled = false
            self.phoneCallButton.enabled = false
            self.phoneNumberLabel.text = "None"
        }
        
        if self.emergencyPhoneNumber != "" {
            self.emergencyButton.enabled = true
            self.emergencyCallButton.enabled = true
            self.emergencyPhoneNumberLabel.text = self.emergencyPhoneNumber
        } else {
            self.emergencyButton.enabled = false
            self.emergencyCallButton.enabled = false
            self.emergencyPhoneNumberLabel.text = " "
        }
        
        if self.streetOne == "" && self.streetTwo == "" && self.streetThree == "" && self.city == "" && self.province == "" && self.postalCode == "" {
            self.addressButton.enabled = false
        } else {
            
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
            
            if self.city == "" {
                self.cityLabel.text = ""
            } else {
                self.cityLabel.text = self.city
            }
            
            if self.province == "" {
                self.provinceLabel.text = ""
            } else {
                self.provinceLabel.text = self.province
            }
            
            if self.postalCode == "" {
                self.postalCodeLabel.text = ""
            } else {
                self.postalCodeLabel.text = self.postalCode
            }

            self.addressButton.enabled = true
            
        }
        
        
        
        
//        if self.street == "" && self.city == "" && self.postalCode == "" && self.province == "" {
//            self.streetCityLabel.text = " "
//            self.streetCityLabelBottomSpaceLayoutConstraint.constant = 0
//        }
//        
//        if self.street == "" || self.city == "" {
//            if self.street == "" && self.city == "" {
//                self.streetCityLabelTopSpaceLayoutConstraint.constant = 0
//            } else {
//                if self.street == "" {
//                    self.streetCityLabel.text = self.street
//                } else {
//                    self.streetCityLabel.text = self.city
//                }
//            }
//        } else if self.street != "" && self.city != "" {
//            self.streetCityLabel.text = "\(self.street)" + ", " + "\(self.city)"
//        }
//        
//        if self.postalCode == "" || self.province == "" {
//            if self.postalCode == "" && self.province == "" {
//                self.streetCityLabelBottomSpaceLayoutConstraint.constant = 0
//            } else {
//                if self.street == "" {
//                    self.postalCodeProvinceLabel.text = self.postalCode
//                } else {
//                    self.postalCodeProvinceLabel.text = self.province
//                }
//            }
//        } else if self.postalCode != "" && self.province != "" {
//            self.postalCodeProvinceLabel.text = "\(self.postalCode)" + " " + "\(self.province)"
//        }
        
        self.textView.text = self.notes
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.unpackUserInformation()
        self.setUserInformation()
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = "User Profile"
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setImageView()
    }
}
