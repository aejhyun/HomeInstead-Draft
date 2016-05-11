//
//  OfficeTaskInformationTableViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 5/9/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class OfficeTaskInformationTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    var taskInformationObjectId: String = ""
    var addPhotoButtonTappedIndexPath: NSIndexPath? = nil
    var editButtonTappedIndexPath: NSIndexPath? = nil
    
    var deletePhotoButtonTapped: Bool = false
    
    var date: String = ""
    var startedTime: String = ""
    var finishedTime: String = ""
    var address: String = ""
    var clientName: String = ""
    var careGiverName: String = ""
    
    var taskDescriptions: [String] = [String]()
    var timeTasksCompleted: [String] = [String]()
    var taskComments: [String] = [String]()

    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func attemptGettingTaskInformation(completion: (connectionSuccessful: Bool) -> Void) {

        let query = PFQuery(className: "TaskInformation")
        query.fromLocalDatastore()
        query.getObjectInBackgroundWithId(self.taskInformationObjectId) {
            (objects: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
                completion(connectionSuccessful: false)
            } else if let object = objects {
                self.date = object.objectForKey("date") as! String
                self.startedTime = object.objectForKey("startedTime") as! String
                self.finishedTime = object.objectForKey("finishedTime") as! String
                self.address = object.objectForKey("address") as! String
                self.clientName = object.objectForKey("clientName") as! String
                self.careGiverName = object.objectForKey("careGiverName") as! String
                self.taskDescriptions = object.objectForKey("taskDescriptions") as! [String]
                self.timeTasksCompleted = object.objectForKey("timeTasksCompleted") as! [String]
                self.taskComments = object.objectForKey("taskComments") as! [String]
                completion(connectionSuccessful: true)
            }
        }
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        //self.standardImages[(self.addPhotoButtonTappedIndexPath?.row)!] = selectedImage
       
        
        
        self.tableView.beginUpdates()
        self.tableView.reloadRowsAtIndexPaths([self.addPhotoButtonTappedIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
        self.tableView.endUpdates()
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func editButtonTapped(sender: AnyObject) {
        
        let editPhotoButton = sender as! UIButton
        let superView = editPhotoButton.superview!
        let officeTaskInformationTableViewCell = superView.superview as! OfficeTaskInformationTableViewCell
        let indexPath = self.tableView.indexPathForCell(officeTaskInformationTableViewCell)
        self.editButtonTappedIndexPath = indexPath
        
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
            
            self.deletePhotoButtonTapped = true
            
            
            //self.standardImages[(self.editButtonTappedIndexPath?.row)!] = nil
            
            self.tableView.beginUpdates()
            self.tableView.reloadRowsAtIndexPaths([self.editButtonTappedIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
            self.tableView.endUpdates()
            
        }
        alertController.addAction(alertAction)
        
        alertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(alertAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func addPhotoButtonTapped(sender: AnyObject) {
        
        let addPhotoButton = sender as! UIButton
        let superView = addPhotoButton.superview!
        let officeTaskInformationTableViewCell = superView.superview as! OfficeTaskInformationTableViewCell
        let indexPath = self.tableView.indexPathForCell(officeTaskInformationTableViewCell)
        self.addPhotoButtonTappedIndexPath = indexPath
        
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
    
    
    func textViewDidChange(textView: UITextView) {
        self.taskComments[textView.tag] = textView.text
    }
    
    func taskDescriptionTextFieldDidChange(textField: UITextField) {
        self.taskDescriptions[textField.tag] = textField.text!
    }
    
    func timeTaskCompletedTextFieldDidChange(textField: UITextField) {
        self.timeTasksCompleted[textField.tag] = textField.text!
    }
    
    func firstRowTextFieldDidChange(textField: UITextField) {
        
        switch textField.tag {
        case 0:
            self.date = textField.text!
        case 1:
            self.startedTime = textField.text!
        case 2:
            self.finishedTime = textField.text!
        case 3:
            self.address = textField.text!
        default:
            break
        }
        
    }
    
    func getCurrentDateAndTime() -> String {
    
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        let dateInFormat = dateFormatter.stringFromDate(NSDate())
        dateFormatter.dateFormat = "h:mm a"
        let timeInFormat = dateFormatter.stringFromDate(NSDate())
        
        let dateAndTimeInFormat = "On \(dateInFormat) at \(timeInFormat)"
        return dateAndTimeInFormat
        
    }
    
    func attemptUpdatingTaskInformation(completion: (updateSuccessful: Bool) -> Void) {
        
        let query = PFQuery(className: "TaskInformation")
        query.getObjectInBackgroundWithId(self.taskInformationObjectId) {
            (objects: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
                completion(updateSuccessful: false)
            } else if let object = objects {
                
                object["date"] = self.date
                object["startedTime"] = self.startedTime
                object["finishedTime"] = self.finishedTime
                object["address"] = self.address
                object["taskComments"] = self.taskComments
                object["taskDescriptions"] = self.taskDescriptions
                object["timeTasksCompleted"] = self.timeTasksCompleted
                object["lastSavedTime"] = self.getCurrentDateAndTime()
                object.pinInBackground()
                object.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        completion(updateSuccessful: true)
                    } else {
                        print(error?.description)
                        completion(updateSuccessful: false)
                    }
                }
                
            }
        }

    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        
        self.attemptUpdatingTaskInformation { (updateSuccessful) -> Void in
            if updateSuccessful {
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 140
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationItem.title = "Task List"
        self.attemptGettingTaskInformation { (connectionSuccessful) -> Void in
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.taskDescriptions.count + 1
    }

    func firstRow(indexPath: NSIndexPath) -> OfficeTaskInformationFirstRowTableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellZero", forIndexPath: indexPath) as! OfficeTaskInformationFirstRowTableViewCell
        cell.dateTextField.text = self.date
        cell.dateTextField.addTarget(self, action: "firstRowTextFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        cell.dateTextField.tag = 0
        
        cell.startedTimeTextField.text = self.startedTime
        cell.startedTimeTextField.addTarget(self, action: "firstRowTextFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        cell.startedTimeTextField.tag = 1

        cell.finishedTimeTextField.text = self.finishedTime
        cell.finishedTimeTextField.addTarget(self, action: "firstRowTextFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        cell.finishedTimeTextField.tag = 2
        
        cell.addressTextField.text = self.address
        cell.addressTextField.addTarget(self, action: "firstRowTextFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        cell.addressTextField.tag = 3
        
        cell.careGiverNameLabel.text = self.careGiverName
        cell.clientNameLabel.text = self.clientName
        
        return cell
    }
    
    func otherRows(indexPath: NSIndexPath) -> OfficeTaskInformationTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellOne", forIndexPath: indexPath) as! OfficeTaskInformationTableViewCell
        let indexPathRow = indexPath.row - 1
        
        cell.setCell()
        
        cell.taskCommentTextView.text = self.taskComments[indexPathRow]
        cell.taskCommentTextView.tag = indexPathRow
        
        cell.taskDescriptionTextField.text = self.taskDescriptions[indexPathRow]
        cell.taskDescriptionTextField.tag = indexPathRow
        cell.taskDescriptionTextField.addTarget(self, action: "taskDescriptionTextFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
            
        cell.timeTaskCompletedTextField.text = self.timeTasksCompleted[indexPathRow]
        cell.timeTaskCompletedTextField.tag = indexPathRow
        cell.timeTaskCompletedTextField.addTarget(self, action: "timeTaskCompletedTextFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        if self.deletePhotoButtonTapped == true {
            cell.deleteImageWithAnimation()
            self.deletePhotoButtonTapped = false
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            return self.firstRow(indexPath)
        } else {
            return self.otherRows(indexPath)
        }
        

    }
    


}
