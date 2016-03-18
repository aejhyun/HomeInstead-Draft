//
//  OfficeAddClientAndCathyViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 3/14/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class OfficeAddClientAndCathyViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    var drewTextFieldWithOnlyBottomLine: Bool = false
    var numbers = [1, 2, 3, 4, 5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setScrollView()
        self.addLeftPaddingToTextField(self.firstNameTextField)
        self.addLeftPaddingToTextField(self.lastNameTextField)
        
    }
    
    override func viewDidLayoutSubviews() {
        
        //The reason for self.drewTextFieldWithOnlyBottomLine Bool check is because the "viewDidLayoutSubviews()" is being called twice. The reason for this, I hypothesize is because these UITextField(s) are laid "on top" of the UIScrollView, which is laid "on top" of a UIView. So this function  is called when the UIView loads and then another time when UIScrollView loads.
        if self.drewTextFieldWithOnlyBottomLine {
            self.drawTextFieldWithOnlyBottomLine(self.firstNameTextField)
            self.drawTextFieldWithOnlyBottomLine(self.lastNameTextField)
        }
        self.drewTextFieldWithOnlyBottomLine = true
        
        
    }
    
    
    func drawTextFieldWithOnlyBottomLine(textField: UITextField!) {
      
        let border = CALayer()
        let width = CGFloat(0.8)
        border.borderColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width: textField.frame.size.width, height: width)
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
        
    }
    
    func addLeftPaddingToTextField(textField: UITextField!) {
        
        let paddingView = UIView(frame: CGRect(x: 0.0, y: 10.0, width: 10.0, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .Always
        
    }
    
    func setScrollView() {
        
        self.scrollView.contentSize.width = self.view.bounds.width
        self.scrollView.contentSize.height = self.view.bounds.height
        self.automaticallyAdjustsScrollViewInsets = false
        
    }
    
    @IBAction func buttonTapped(sender: AnyObject) {
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = "hello"
        return cell

        
    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
