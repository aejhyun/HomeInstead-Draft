//
//  OfficeAddClientAndCathyViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 3/14/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class OfficeAddClientViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewBottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var cathyNames:[String] = [String]()
    var cathyEmails:[String] = [String]()
    var drewTextFieldWithOnlyBottomLine: Bool = false
    var gestureRecognizer: UIGestureRecognizer!
    var numberOfTimesViewLaidOutSubviews: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.editButton.hidden = true
        self.addPhotoButton.titleLabel?.textAlignment = .Center
        
        self.tableView.setEditing(true, animated: true)
        
        self.setScrollView()
        
        self.addLeftPaddingToTextField(self.firstNameTextField)
        self.addLeftPaddingToTextField(self.lastNameTextField)
        
        self.gestureRecognizer = UITapGestureRecognizer(target: self, action: "notesTextViewTapped:")
        self.notesTextView.addGestureRecognizer(gestureRecognizer)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        
        //The reason for self.numberOfTimesViewLaidOutSubviews == 1 check is because the "viewDidLayoutSubviews()" is being called more than once. The reason for this, I hypothesize is because these UITextField(s) are laid "on top" of the UIScrollView, which is laid "on top" of a UIView. So this function  is called when the UIView loads and then another time when UIScrollView loads.
        if self.numberOfTimesViewLaidOutSubviews == 1 {
            
            self.drawTextFieldWithOnlyBottomLine(self.firstNameTextField)
            self.drawTextFieldWithOnlyBottomLine(self.lastNameTextField)
            
            //The imageView set up is also inside self.numberOfTimesViewLaidOutSubviews == 1 check because the code below will be called more than once. And the imageView set up is not in viewDidLoad() because, self.imageView.frame returned was the incorrect value. It returns the correct self.imageView.frame value either in the viewDidLayoutSubviews and viewWillAppear functions. But in the viewWillAppear function causes the image to show up visibly late.
            imageView.layer.borderWidth = 1
            imageView.layer.masksToBounds = false
            imageView.layer.borderColor = UIColor.lightGrayColor().CGColor
            imageView.layer.cornerRadius = self.imageView.frame.height / 2
            imageView.clipsToBounds = true
            print("paidsjfpasijf")
        }
        self.numberOfTimesViewLaidOutSubviews++
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        adjustTableViewHeight()
        
    }
    
//Keyboard functions start here.
    func keyboardDidShow(notification: NSNotification) {
        
        if let activeField = self.notesTextView, keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            if (CGRectContainsPoint(aRect, activeField.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
        
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        
        let contentInsets = UIEdgeInsetsZero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
    }

    func notesTextViewTapped(gestureRecognizer: UIGestureRecognizer) {
        
        self.notesTextView.becomeFirstResponder()
        
    }
//Keyboard functions end here.
    
    func adjustTableViewHeight() {
        
        //The 44 is the original height of self.tableView.contentSize. If the row height is changed in the XIB, then the 44 should also be changed to whatever number it is changed in the XIB.
        let height:CGFloat = 44 * CGFloat(self.cathyNames.count + 1)
        var frame:CGRect = self.tableView.frame
        frame.size.height = height
        self.tableView.frame = frame
        self.tableViewHeightLayoutConstraint.constant = height

    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
  
        self.notesTextView.resignFirstResponder()
    }
    
    func setScrollView() {
        
        self.scrollView.contentSize.width = self.view.bounds.width
        self.scrollView.contentSize.height = self.view.bounds.height
        self.scrollView.keyboardDismissMode = .OnDrag
        self.scrollView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        
    }

//TextField functions tart here.
    
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
    
//TextField functions end here.
//Image functions start here.
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageView.image = selectedImage
        self.imageView.layer.borderWidth = 0
        self.addPhotoButton.hidden = true
        self.editButton.hidden = false
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func addPhotoButtonTapped(sender: AnyObject) {
        let alertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        var alertAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .Default) { (alertAction: UIAlertAction) -> Void in
            
        }
        alertController.addAction(alertAction)
        
        alertAction = UIAlertAction(title: "Choose Photo", style: .Default) { (alertAction: UIAlertAction) -> Void in
            
            let imagePickerController: UIImagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .PhotoLibrary
            imagePickerController.delegate = self
            
            self.presentViewController(imagePickerController, animated: true, completion: nil)
            
        }
        alertController.addAction(alertAction)
        
        alertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(alertAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func editButtonTapped(sender: AnyObject) {
        
        let alertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        var alertAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .Default) { (alertAction: UIAlertAction) -> Void in
            
        }
        alertController.addAction(alertAction)
        
        alertAction = UIAlertAction(title: "Choose Photo", style: .Default) { (alertAction: UIAlertAction) -> Void in
            let imagePickerController: UIImagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .PhotoLibrary
            imagePickerController.delegate = self
            
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        }
        alertController.addAction(alertAction)
        
        alertAction = UIAlertAction(title: "Delete Photo", style: .Default) { (alertAction: UIAlertAction) -> Void in
            self.imageView.image = nil
            self.imageView.layer.borderWidth = 1
            self.addPhotoButton.hidden = false
            self.editButton.hidden = true
        }
        alertController.addAction(alertAction)
        
        alertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(alertAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
//Image functions end here.
//TableView functions start here.
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        if indexPath.row != self.cathyNames.count {
            return UITableViewCellEditingStyle.Delete
        } else {
            return UITableViewCellEditingStyle.Insert
        }
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            // Delete the row from the data source
            self.cathyNames.removeAtIndex(indexPath.row)
            self.cathyEmails.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            self.view.removeGestureRecognizer(self.gestureRecognizer)
            self.performSegueWithIdentifier("AddClientToAddCathy", sender: nil)
        }
        
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.cathyNames.count + 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! OfficeAddCathyTableViewCell
        
        if indexPath.row != self.cathyNames.count {
            cell.cathyNameLabel.text = self.cathyNames[indexPath.row]
            cell.cathyEmailLabel.text = self.cathyEmails[indexPath.row]
            cell.addCathyLabel.text = ""

        } else {
            cell.addCathyLabel.text = "Add a Cathy"
            cell.cathyNameLabel.text = ""
            cell.cathyEmailLabel.text = ""
        }
        return cell
        
    }
    
//TableView functions end here.
//Segue functions start here.
    
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
    
//Segue functions end here.
    
}
