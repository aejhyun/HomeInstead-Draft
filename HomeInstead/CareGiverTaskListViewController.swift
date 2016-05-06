//
//  CareGiverTaskListViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 5/5/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class CareGiverTaskListViewController: UIViewController, UIBarPositioningDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    var navigationBarLine: UIView = UIView()
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var addPhotoButtonTappedIndexPath: NSIndexPath? = nil
    var editButtonTappedIndexPath: NSIndexPath? = nil
    
    var standardExpandButtonTappedIndexPath: NSIndexPath? = nil
    var specializedExpandButtonTappedIndexPath: NSIndexPath? = nil
    
    var standardDoneButtonEnabledRows: [Bool] = [Bool]()
    var specializedDoneButtonEnabledRows: [Bool] = [Bool]()
    
    var standardOptionButtonEnabledRows: [Bool] = [Bool]()
    var specializedOptionButtonEnabledRows: [Bool] = [Bool]()
    
    var standardComments: [String] = [String]()
    var specializedComments: [String] = [String]()
    
    var standardImages: [UIImage?] = [UIImage?]()
    var specializedImages: [UIImage?] = [UIImage?]()
    
    var selectedTaskType: TaskType!
    
    var setComments: Bool = true
    var deletePhotoButtonTapped: Bool = false
    
    
    var tasks: [String] = [String]()
    var standardTasks = ["Go on a walk", "Give a bath", "Dance", "Give a message", "Practice language", "Excersice", "Go shopping", "Go out to the park", "Look at a flower", "Read a book", "Play piano", "Make a new friend", "Wash clothes", "Paint nails", "Paint"]

    var specializedTasks = ["Eat some food", "Watch TV", "Ride a bike", "Dance", "Give a message", "Practice language", "Excersice", "Go shopping", "Go out to the park", "Look at a flower", "Read a book", "Play piano", "Make a new friend", "Wash clothes", "Paint nails", "Paint"]
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    func removeBottomLineFromNavigationBar() {
        
        for parent in self.navigationController!.navigationBar.subviews {
            for childView in parent.subviews {
                if childView is UIImageView && childView.bounds.size.width == self.navigationController!.navigationBar.frame.size.width {
                    self.navigationBarLine = childView
                }
            }
        }
        
    }
    
    func setSegmentedControlWidth() {
        
        let viewWidth: CGFloat = self.view.frame.width
        self.barButtonItem.width = viewWidth - 40.0
    
    }
    
    func setToolbar() {
        
        self.toolbar.layer.borderWidth = 1.0
        self.toolbar.clipsToBounds = true
        self.toolbar.layer.borderColor = UIColor(red: 163.0/255.0, green: 163.0/255.0, blue: 163.0/255.0, alpha: 1.0).CGColor
        
    }
    
    func textViewDidChange(textView: UITextView) {
        
        if self.selectedTaskType == TaskType.standard {
            self.standardComments[self.standardExpandButtonTappedIndexPath!.row] = textView.text
        } else if self.selectedTaskType == TaskType.specialized {
            self.specializedComments[self.standardExpandButtonTappedIndexPath!.row] = textView.text
        }

    }
    
    @IBAction func segmentedControlIndexChanged(sender: UISegmentedControl) {
        
        if self.segmentedControl.selectedSegmentIndex == 0 {
            self.tasks = self.standardTasks
            selectedTaskType = TaskType.standard
        } else if self.segmentedControl.selectedSegmentIndex == 1 {
            self.tasks = self.specializedTasks
            selectedTaskType = TaskType.specialized
        }
        
        self.tableView.reloadData()
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if self.selectedTaskType == TaskType.standard {
            self.standardImages[(self.addPhotoButtonTappedIndexPath?.row)!] = selectedImage
        } else if self.selectedTaskType == TaskType.specialized {
            self.specializedImages[(self.addPhotoButtonTappedIndexPath?.row)!] = selectedImage
        }
        
        self.tableView.beginUpdates()
        self.tableView.reloadRowsAtIndexPaths([self.addPhotoButtonTappedIndexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
        self.tableView.endUpdates()
        

        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func editButtonTapped(sender: AnyObject) {
        
        let editPhotoButton = sender as! UIButton
        let superView = editPhotoButton.superview!
        let careGiverTaskListTableViewCell = superView.superview as! CareGiverTaskListTableViewCell
        let indexPath = self.tableView.indexPathForCell(careGiverTaskListTableViewCell)
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
            
            if self.selectedTaskType == TaskType.standard {
                self.standardImages[(self.editButtonTappedIndexPath?.row)!] = nil
            } else if self.selectedTaskType == TaskType.specialized {
                self.specializedImages[(self.editButtonTappedIndexPath?.row)!] = nil
            }
            
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
        let careGiverTaskListTableViewCell = superView.superview as! CareGiverTaskListTableViewCell
        let indexPath = self.tableView.indexPathForCell(careGiverTaskListTableViewCell)
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
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        
        let doneButton = sender as! UIButton
        let superView = doneButton.superview!
        let careGiverTaskListTableViewCell = superView.superview as! CareGiverTaskListTableViewCell
        let indexPath = self.tableView.indexPathForCell(careGiverTaskListTableViewCell)
        
        if self.selectedTaskType == TaskType.standard {
            self.standardDoneButtonEnabledRows[indexPath!.row] = false
        } else if self.selectedTaskType == TaskType.specialized {
            self.specializedDoneButtonEnabledRows[indexPath!.row] = false
        }
        
//        self.expandButtonTappedIndexPath = nil
        self.tableView.beginUpdates()
        self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
        self.tableView.endUpdates()
        
    }
    
    func setExpandButtonTappedIndexPathForTaskType(taskType: TaskType, indexPath: NSIndexPath) {
        
        if self.selectedTaskType == TaskType.standard {
            
            switch self.standardExpandButtonTappedIndexPath {
            case nil:
                self.standardExpandButtonTappedIndexPath = indexPath
            default:
                if self.standardExpandButtonTappedIndexPath! == indexPath {
                    self.standardExpandButtonTappedIndexPath = nil
                } else {
                    self.standardExpandButtonTappedIndexPath = indexPath
                }
            }
            
        } else if self.selectedTaskType == TaskType.specialized {
            
            switch self.specializedExpandButtonTappedIndexPath {
            case nil:
                self.specializedExpandButtonTappedIndexPath = indexPath
            default:
                if self.specializedExpandButtonTappedIndexPath! == indexPath {
                    self.specializedExpandButtonTappedIndexPath = nil
                } else {
                    self.specializedExpandButtonTappedIndexPath = indexPath
                }
            }
        }
        
    }
    
    @IBAction func expandButtonTapped(sender: AnyObject) {
        
        let expandButton = sender as! UIButton
        let superView = expandButton.superview!
        let careGiverTaskListTableViewCell = superView.superview as! CareGiverTaskListTableViewCell
        let indexPath = self.tableView.indexPathForCell(careGiverTaskListTableViewCell)
   
        self.setExpandButtonTappedIndexPathForTaskType(self.selectedTaskType, indexPath: indexPath!)

        self.tableView.beginUpdates()
        self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
        self.tableView.endUpdates()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSegmentedControlWidth()
        self.setToolbar()
        self.removeBottomLineFromNavigationBar()
        self.navigationItem.title = "Task List"
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
        
        self.standardImages = [UIImage?](count: self.standardTasks.count, repeatedValue: nil)
        self.specializedImages = [UIImage?](count: self.specializedTasks.count, repeatedValue: nil)
        
        self.standardComments = [String](count: self.standardTasks.count, repeatedValue: "")
        self.specializedComments = [String](count: self.specializedTasks.count, repeatedValue: "")
        
        self.standardDoneButtonEnabledRows = [Bool](count: self.standardTasks.count, repeatedValue: true)
        self.specializedDoneButtonEnabledRows = [Bool](count: self.specializedTasks.count, repeatedValue: true)
        
        self.standardOptionButtonEnabledRows = [Bool](count: self.standardTasks.count, repeatedValue: true)
        self.specializedOptionButtonEnabledRows = [Bool](count: self.specializedTasks.count, repeatedValue: true)
        
        self.tasks = self.standardTasks
        self.selectedTaskType = TaskType.standard
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationBarLine.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        self.navigationBarLine.hidden = false
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let originalHeight: CGFloat = 44.0
        let expandedHeight: CGFloat = 135
        let indexPath = indexPath
        
        var expandButtonTappedIndexPath: NSIndexPath? = nil
        
        if self.selectedTaskType == TaskType.standard {
            expandButtonTappedIndexPath = self.standardExpandButtonTappedIndexPath
        } else if self.selectedTaskType == TaskType.specialized {
            expandButtonTappedIndexPath = self.specializedExpandButtonTappedIndexPath
        }
        
        
        if self.selectedTaskType == TaskType.standard {
          
        } else if self.selectedTaskType == TaskType.specialized {
           
        }

        if expandButtonTappedIndexPath != nil {
            if indexPath == expandButtonTappedIndexPath {
                
                return expandedHeight
            } else {
                return originalHeight
            }
        } else {
            return originalHeight
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if self.selectedTaskType == TaskType.standard {
           return self.standardTasks.count
        } else if self.selectedTaskType == TaskType.specialized {
            return self.specializedTasks.count
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var images: [UIImage?] = [UIImage?]()
        var comments: [String] = [String]()
        var doneButtonEnabledRows: [Bool] = [Bool]()
        if self.selectedTaskType == TaskType.standard {
            images = self.standardImages
            comments = self.standardComments
            doneButtonEnabledRows = self.standardDoneButtonEnabledRows
        } else if self.selectedTaskType == TaskType.specialized {
            images = self.specializedImages
            comments = self.specializedComments
            doneButtonEnabledRows = self.specializedDoneButtonEnabledRows
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CareGiverTaskListTableViewCell
        
        if self.deletePhotoButtonTapped == true {
            cell.deleteImageWithAnimation()
            self.deletePhotoButtonTapped = false
        }
        
        if self.standardExpandButtonTappedIndexPath != nil {
            cell.textView.isFirstResponder()
            print("yo")
        } else {

        }

        if doneButtonEnabledRows[indexPath.row] == false {
            cell.doneButton.enabled = false
        } else {
            cell.doneButton.enabled = true
        }
        
        
        cell.textView.text = comments[indexPath.row]
        cell.setCell()
        cell.setTaskImage(images[indexPath.row])
        cell.taskDescriptionLabel.text = self.tasks[indexPath.row]
        
        return cell
    }


}

    
    


