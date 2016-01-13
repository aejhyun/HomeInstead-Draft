//
//  CathyTaskLogMessageViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 1/13/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class CathyTaskLogMessageViewController: UIViewController {

    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var messageTextView: UITextView!
    var passedMessage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextView.layer.cornerRadius = 10
        messageTextView.editable = false
        messageTextView.text = passedMessage

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
