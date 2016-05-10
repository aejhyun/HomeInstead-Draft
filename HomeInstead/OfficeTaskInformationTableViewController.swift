//
//  OfficeTaskInformationTableViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 5/9/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class OfficeTaskInformationTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 140
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationItem.title = "Task List"
        self.attemptGettingTaskInformation { (connectionSuccessful) -> Void in
            self.tableView.reloadData()
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
        cell.startedTimeTextField.text = self.startedTime
        cell.finishedTimeTextField.text = self.finishedTime
        cell.addressTextField.text = self.address
        cell.careGiverNameLabel.text = self.careGiverName
        cell.clientNameLabel.text = self.clientName
        
        return cell
    }
    
    func otherRows(indexPath: NSIndexPath) -> OfficeTaskInformationTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellOne", forIndexPath: indexPath) as! OfficeTaskInformationTableViewCell
        let indexPathRow = indexPath.row - 1
        
        cell.setCell()
        
        cell.taskCommentTextView.text = self.taskComments[indexPathRow]
        cell.taskDescriptionTextField.text = self.taskDescriptions[indexPathRow]
        cell.timeTaskCompletedTextField.text = self.timeTasksCompleted[indexPathRow]
        
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
