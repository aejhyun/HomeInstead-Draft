//
//  OfficeAddClientAndCathyViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 3/14/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class OfficeAddClientViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableViewHeightLayoutConstraint: NSLayoutConstraint!
    
    var cathyNames:[String] = [String]()
    var cathyEmails:[String] = [String]()
    var drewTextFieldWithOnlyBottomLine: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.imageView.image = UIImage(named: "defaultPicture")
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
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
    
    override func viewWillAppear(animated: Bool) {
        
        adjustTableViewHeight()
        
    }
    
    func adjustTableViewHeight() {
        
        //The 44 is the original height of self.tableView.contentSize. If the row height is changed in the XIB, then the 44 should also be changed to whatever number it is changed in the XIB.
        let height:CGFloat = 44 * CGFloat(self.cathyNames.count)
        var frame:CGRect = self.tableView.frame
        frame.size.height = height
        self.tableView.frame = frame
        self.tableViewHeightLayoutConstraint.constant = height

    }
    
    func setScrollView() {
        
        self.scrollView.contentSize.width = self.view.bounds.width
        self.scrollView.contentSize.height = self.view.bounds.height
        self.automaticallyAdjustsScrollViewInsets = false
        
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cathyNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! OfficeAddCathyTableViewCell
              print(self.tableView.rowHeight)
        
        cell.cathyName.text = self.cathyNames[indexPath.row]
        cell.cathyEmail.text = self.cathyEmails[indexPath.row]
        
        return cell

        
    }
    
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {
        
        if let addCathyTableViewController = segue.sourceViewController as? AddCathyTableViewController {
            
            self.cathyNames = addCathyTableViewController.addedCathyNames
            self.cathyEmails = addCathyTableViewController.addedCathyEmails
            self.tableView.reloadData()

        }
        
    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
