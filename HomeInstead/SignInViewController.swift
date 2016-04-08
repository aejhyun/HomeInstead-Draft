//
//  SignInViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 4/7/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func signInButtonTapped(sender: AnyObject) {
        
        
    }
}
