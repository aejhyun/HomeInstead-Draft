//
//  SignUpSignInViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 4/7/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class SignUpSignInViewController: UIViewController {

    @IBOutlet weak var officeButton: UIButton!
    @IBOutlet weak var careGiverButton: UIButton!
    @IBOutlet weak var cathyButton: UIButton!
    
    var showSignUpAccountOptions: Bool = false
    var userTypeSelected: UserType!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.officeButton.hidden = true
        self.careGiverButton.hidden = true
        self.cathyButton.hidden = true
        self.officeButton.alpha = 0.0
        self.careGiverButton.alpha = 0.0
        self.cathyButton.alpha = 0.0
        
    }

    @IBAction func signUpButtonTapped(sender: AnyObject) {
        
        if self.showSignUpAccountOptions == false {
            
            self.officeButton.hidden = false
            self.careGiverButton.hidden = false
            self.cathyButton.hidden = false
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.officeButton.alpha = 1.0
            })
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.cathyButton.alpha = 1.0
            })
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.careGiverButton.alpha = 1.0
            })
            
            self.showSignUpAccountOptions = true
            
        } else {
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.officeButton.alpha = 0.0
                }, completion: { (completed: Bool) -> Void in
                    self.officeButton.hidden = true
            })
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.careGiverButton.alpha = 0.0
                }, completion: { (completed: Bool) -> Void in
                    self.careGiverButton.hidden = true
            })
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.cathyButton.alpha = 0.0
                }, completion: { (completed: Bool) -> Void in
                    self.cathyButton.hidden = true
            })
            
            self.showSignUpAccountOptions = false
            
        }
        
    }
    
    @IBAction func officeButtonTapped(sender: AnyObject) {
        self.userTypeSelected = UserType.office
    }
    
    @IBAction func careGiverButtonTapped(sender: AnyObject) {
        self.userTypeSelected = UserType.careGiver
    }
    
    @IBAction func cathyButtonTapped(sender: AnyObject) {
        self.userTypeSelected = UserType.cathy
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let navigationController = segue.destinationViewController as? UINavigationController {
            if let signUpViewController = navigationController.topViewController as? SignUpViewController {
                
                signUpViewController.userTypeSelected = self.userTypeSelected
                
            } else {
                print("signUpViewController returned nil")
            }
        } else {
            print("navigationController returned nil")
        }
        
    }

    



}
