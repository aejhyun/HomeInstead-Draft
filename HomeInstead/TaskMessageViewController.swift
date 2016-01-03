//
//  TaskMessageViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 12/28/15.
//  Copyright © 2015 Jae Hyun Kim. All rights reserved.
//  

import UIKit

class TaskMessageViewController: UIViewController {

    
    @IBOutlet weak var messageTextView: UITextView!
    var message = [String](count: 30, repeatedValue: "")
    var messageButtonRowSelected: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("picture button row selected in TaskMessageViewController \(messageButtonRowSelected)")
        messageTextView.becomeFirstResponder()
        messageTextView.layer.cornerRadius = 10
        messageTextView.text = message[messageButtonRowSelected]
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.view.endEditing(true);

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {

    }

}
