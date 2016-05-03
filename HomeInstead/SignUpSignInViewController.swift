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
    var selectedUserType: UserType!
    
    // The function viewDidLoad() gets called when the view gets loaded. And it is called only once during a view's life cycle. In this function, I decided to hide and change the visibility of some buttons.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.officeButton.hidden = true // Hides the buttons.
        self.careGiverButton.hidden = true
        self.cathyButton.hidden = true
        self.officeButton.alpha = 0.0 // Makes the darkness of the color as light as it can get; 1.0 represents the darkest color it can get.
        self.careGiverButton.alpha = 0.0
        self.cathyButton.alpha = 0.0
        
    }
    
    // This functions gets called when I tap the sign up button.
    
    @IBAction func signUpButtonTapped(sender: AnyObject) {
        
        if self.showSignUpAccountOptions == false {
            
            self.officeButton.hidden = false
            self.careGiverButton.hidden = false
            self.cathyButton.hidden = false
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in // This functions makes things fade in and out.
                self.officeButton.alpha = 1.0 // Remember how we set the office button's alpha to 0.0? Well, this function changes it back to 1.0 but with animation. COOL!
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
        self.selectedUserType = UserType.office
        self.performSegueWithIdentifier("signUpSignInToSignUp", sender: nil)
    }
    
    @IBAction func careGiverButtonTapped(sender: AnyObject) {
        self.selectedUserType = UserType.careGiver
        self.performSegueWithIdentifier("signUpSignInToSignUp", sender: nil)
    }
    
    @IBAction func cathyButtonTapped(sender: AnyObject) {
        self.selectedUserType = UserType.cathy
        self.performSegueWithIdentifier("signUpSignInToSignUp", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "signUpSignInToSignUp" {
            
            if let navigationController = segue.destinationViewController as? UINavigationController {
                if let signUpViewController = navigationController.topViewController as? SignUpViewController {
                    
                    signUpViewController.selectedUserType = self.selectedUserType

                } else {
                    print("signUpViewController returned nil")
                }
            } else {
                print("navigationController returned nil")
            }
            
        } else if segue.identifier == "signUpSignInToSignIn" {
            
            if let navigationController = segue.destinationViewController as? UINavigationController {
                if let _ = navigationController.topViewController as? SignInViewController {
                    
                    
                    
                } else {
                    print("signInViewController returned nil")
                }
            } else {
                print("navigationController returned nil")
            }
            
        }
        
    }

    
    
    
    
    
}
