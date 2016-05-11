//
//  CareGiverTaskListViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 5/5/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

class CareGiverTaskListViewController: UIViewController, UIBarPositioningDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, CLLocationManagerDelegate {
    
    var navigationBarLine: UIView = UIView()
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var startButton: UIBarButtonItem!
    @IBOutlet weak var finishButton: UIBarButtonItem!
    
    var addPhotoButtonTappedIndexPath: NSIndexPath? = nil
    var editButtonTappedIndexPath: NSIndexPath? = nil
    
    var expandButtonTappedIndexPath: NSIndexPath? = nil
    var standardExpandButtonTappedIndexPath: NSIndexPath? = nil
    var specializedExpandButtonTappedIndexPath: NSIndexPath? = nil
    
    var textViewIndexPath: NSIndexPath? = nil
    var standardTextViewIndexPath: NSIndexPath? = nil
    var specializedTextViewIndexPath: NSIndexPath? = nil
    
    var doneButtonEnabledRows: [Bool] = [Bool]()
    var standardDoneButtonEnabledRows: [Bool] = [Bool]()
    var specializedDoneButtonEnabledRows: [Bool] = [Bool]()
    
    var standardOptionButtonEnabledRows: [Bool] = [Bool]()
    var specializedOptionButtonEnabledRows: [Bool] = [Bool]()
    
    var tasks: [String] = [String]()
    var standardTasks = ["Go on a walk", "Give a bath", "Dance", "Give a message", "Practice language", "Excersice", "Go shopping", "Go out to the park", "Look at a flower", "Read a book", "Play piano", "Make a new friend", "Wash clothes", "Paint nails", "Paint"]
    var specializedTasks = ["Eat some food", "Watch TV", "Ride a bike", "Dance", "Give a message", "Practice language", "Excersice", "Go shopping", "Go out to the park", "Look at a flower", "Read a book", "Play piano", "Make a new friend", "Wash clothes", "Paint nails", "Paint"]
    
    var comments: [String] = [String]()
    var standardComments: [String] = [String]()
    var specializedComments: [String] = [String]()
    
    var images: [UIImage?] = [UIImage?]()
    var standardImages: [UIImage?] = [UIImage?]()
    var specializedImages: [UIImage?] = [UIImage?]()
    
    var selectedTaskType: TaskType!
    
    var setComments: Bool = true
    var deletePhotoButtonTapped: Bool = false
    var tasksStarted: Bool = false

    var locationManager: CLLocationManager = CLLocationManager()
    
    var clientName: String = ""
    var careGiverName: String = ""
    var clientObjectId: String = ""
    var careGiverObjectId: String = ""
    var cathyUserIds: [String] = [String]()
    var officeUserIds: [String] = [String]()
    var startTime: String = ""
    var date: String = ""
    var startAddress: String = ""
    var commentsToBeUploaded: [String] = [String]()
    var imagesToBeUploaded: [UIImage?] = [UIImage?]()
    var taskDescriptionsToBeUploaded: [String] = [String]()
    var timesTasksCompleted: [String] = [String]()
    var finishTime: String = ""
    var finishAddress: String = ""
    
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
    
    
    func setReadOnlyVariablesForTaskType(taskType: TaskType) {
        
        if self.selectedTaskType == TaskType.standard {
            self.tasks = self.standardTasks
            self.images = self.standardImages
            self.comments = self.standardComments
            self.doneButtonEnabledRows = self.standardDoneButtonEnabledRows
            self.expandButtonTappedIndexPath = self.standardExpandButtonTappedIndexPath
            self.textViewIndexPath = self.standardTextViewIndexPath
        } else if self.selectedTaskType == TaskType.specialized {
            self.tasks = self.specializedTasks
            self.images = self.specializedImages
            self.comments = self.specializedComments
            self.doneButtonEnabledRows = self.specializedDoneButtonEnabledRows
            self.expandButtonTappedIndexPath = self.specializedExpandButtonTappedIndexPath
            self.textViewIndexPath = self.specializedTextViewIndexPath
        }
        
    }

//Keyboard functions start here.
    
    func keyboardDidShow(notification: NSNotification) {
        
        self.setReadOnlyVariablesForTaskType(self.selectedTaskType)
        let info:NSDictionary = notification.userInfo!
        let kbSize:CGSize = (info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue.size)!
        let contentInsets:UIEdgeInsets = UIEdgeInsetsMake(0.0,0.0,kbSize.height,0.0)
        self.tableView.contentInset = contentInsets
        self.tableView.scrollToRowAtIndexPath(self.textViewIndexPath!, atScrollPosition: .Top, animated: true)
        self.tableView.scrollIndicatorInsets = contentInsets
        
    }
    
    func keyboardWillBeHidden(notification: NSNotification) {
        
        let contentInsets = UIEdgeInsetsZero
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
        
    }
    
//Keyboard functions end here.
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }

    func textViewDidChange(textView: UITextView) {

        if self.selectedTaskType == TaskType.standard {
            self.standardComments[self.standardExpandButtonTappedIndexPath!.row] = textView.text
        } else if self.selectedTaskType == TaskType.specialized {
            self.specializedComments[self.specializedExpandButtonTappedIndexPath!.row] = textView.text
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
        
        self.setReadOnlyVariablesForTaskType(self.selectedTaskType)
        
        self.commentsToBeUploaded.append(self.comments[indexPath!.row])
        self.imagesToBeUploaded.append(self.images[indexPath!.row])
        self.taskDescriptionsToBeUploaded.append(self.tasks[indexPath!.row])
        self.timesTasksCompleted.append(self.getCurrentTime())
        
    }
    
    func attemptGettingCurrentAddress(completion: (gotAddressSuccessfully: Bool, address: String?) -> Void) {
        
        if CLLocationManager.locationServicesEnabled() {
      
            var location = self.locationManager.location
            let latitude = location?.coordinate.latitude
            let longitude = location?.coordinate.longitude
            let cLGeocoder = CLGeocoder()
            var placemark: CLPlacemark!
            var address: String = ""
            
            if let latitude = latitude {
                if let longitude = longitude {
                    location = CLLocation(latitude: latitude, longitude: longitude)
                    
                    cLGeocoder.reverseGeocodeLocation(location!) { (placemarks, error) -> Void in
                        if error == nil {
                            
                            placemark = placemarks![0]
                   
                            if let subThoroughFare = placemark.addressDictionary!["SubThoroughfare"] as? String {
                                address = subThoroughFare + " "
                            }
                            if let thoroughFare = placemark.addressDictionary!["Thoroughfare"] as? String {
                                address += thoroughFare
                            }
                            if let state = placemark.addressDictionary!["State"] as? String {
                                address += ", " + state
                            }
                            if let city = placemark.addressDictionary!["City"] as? String {
                                address += ", " + city
                            }
                            if let zipCode = placemark.addressDictionary!["ZIP"] as? String {
                                address += " " + zipCode
                            }
                            completion(gotAddressSuccessfully: true, address: address)
                            
                        } else {
                            print("\(error)")
                            completion(gotAddressSuccessfully: false, address: nil)
                            return
                        }
                    }

                } else {
                    print("Longitude is nil")
                    completion(gotAddressSuccessfully: false, address: nil)
                }
                
                
            } else {
                print("Latitude and longitude is nil")
                completion(gotAddressSuccessfully: false, address: nil)
            }
            
            
        } else {
            print("location services are not enabled")
            completion(gotAddressSuccessfully: false, address: nil)
        }
        
    }
    
    func getCurrentDate() -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        let dateInFormat = dateFormatter.stringFromDate(NSDate())
        return dateInFormat
        
    }
    
    func getCurrentTime() -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let timeInFormat = dateFormatter.stringFromDate(NSDate())
        return timeInFormat
        
    }
    
    @IBAction func startButtonTapped(sender: AnyObject) {
   
        self.finishButton.enabled = true
        self.startButton.enabled = false
        self.tasksStarted = true
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        self.attemptGettingCurrentAddress({ (gotAddressSuccessfully, address) -> Void in
            if gotAddressSuccessfully {
                self.startAddress = address!
                print(address)
            } else {
                self.startAddress = "Could not find address."
            }
        })
        self.startTime = self.getCurrentTime()
        self.date = self.getCurrentDate()
        
        self.tableView.reloadData()
    }
    
    func getImageFiles() -> [PFFile] {
        
        var data: NSData? = nil
        
        data = UIImageJPEGRepresentation(UIImage(named: "defaultPicture")!, 0.0)
        var imageFile: [PFFile] = [PFFile(data: data!)!]

        for image in self.imagesToBeUploaded {
            if image != nil {
                data = UIImageJPEGRepresentation(image!, 0.5)
                imageFile.append(PFFile(data: data!)!)
            } else {
                data = UIImageJPEGRepresentation(UIImage(named: "defaultPicture")!, 0.0)
                imageFile.append(PFFile(data: data!)!)
            }
            //print(imageFile)
        }
        return imageFile
       
    }
    
    func attemptUploadingTaskInformationToCloud(completion: (uploadSuccessful: Bool) -> Void) {
        
        let object = PFObject(className: "TaskInformation")
        object["clientName"] = self.clientName
        object["careGiverName"] = self.careGiverName
        object["cathyUserIds"] = self.cathyUserIds
        object["officeUserIds"] = self.officeUserIds
        object["careGiverObjectId"] = self.careGiverObjectId
        object["clientObjectId"] = self.clientObjectId
        object["address"] = self.startAddress
        object["date"] = self.date
        object["startedTime"] = self.startTime
        object["taskDescriptions"] = self.taskDescriptionsToBeUploaded
        object["timeTasksCompleted"] = self.timesTasksCompleted
        object["taskComments"] = self.commentsToBeUploaded
        object["finishedTime"] = self.finishTime
        object["sentToCathys"] = false
        object["careGiverUserId"] = PFUser.currentUser()?.objectId
        object["lastSavedTime"] = "N/A"
        
        //object["imageFiles"] = self.getImageFiles()
        
        object.pinInBackground()
        object.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                completion(uploadSuccessful: true)
            } else {
                print(error?.description)
                completion(uploadSuccessful: false)
            }
        }
        
        
    }
    
    @IBAction func finishButtonTapped(sender: AnyObject) {
        
        self.finishButton.enabled = false
        self.startButton.enabled = true
        self.tasksStarted = false
        self.navigationItem.setHidesBackButton(false, animated: true)
        
        self.finishTime = self.getCurrentTime()
        
        self.attemptGettingCurrentAddress { (gotAddressSuccessfully, address) -> Void in
            if gotAddressSuccessfully {
                self.finishAddress = address!
            } else {
                self.finishAddress = "Could not find address"
            }
            self.attemptUploadingTaskInformationToCloud { (uploadSuccessful) -> Void in
                print("yes")
            }
        }
        
        
        
        
//        self.standardTasks.removeAll(keepCapacity: true)
//        self.specializedTasks.removeAll(keepCapacity: true)
//        self.standardImages.removeAll(keepCapacity: true)
//        self.specializedImages.removeAll(keepCapacity: true)
//        self.standardComments.removeAll(keepCapacity: true)
//        self.specializedComments.removeAll(keepCapacity: true)
//        self.standardDoneButtonEnabledRows.removeAll(keepCapacity: true)
//        self.specializedDoneButtonEnabledRows.removeAll(keepCapacity: true)
        
        self.tableView.reloadData()
        
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
        
        if self.selectedTaskType == TaskType.standard {
            self.standardTextViewIndexPath = indexPath
        } else if self.selectedTaskType == TaskType.specialized {
            self.specializedTextViewIndexPath = indexPath
        }
        
        self.setExpandButtonTappedIndexPathForTaskType(self.selectedTaskType, indexPath: indexPath!)

        self.view.endEditing(true)
        
        self.tableView.beginUpdates()
        self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
        self.tableView.endUpdates()
    
    }
    
    func setArraySizes() {
        
        self.standardImages = [UIImage?](count: self.standardTasks.count, repeatedValue: nil)
        self.specializedImages = [UIImage?](count: self.specializedTasks.count, repeatedValue: nil)
        
        self.standardComments = [String](count: self.standardTasks.count, repeatedValue: "")
        self.specializedComments = [String](count: self.specializedTasks.count, repeatedValue: "")
        
        self.standardDoneButtonEnabledRows = [Bool](count: self.standardTasks.count, repeatedValue: true)
        self.specializedDoneButtonEnabledRows = [Bool](count: self.specializedTasks.count, repeatedValue: true)
        
        self.standardOptionButtonEnabledRows = [Bool](count: self.standardTasks.count, repeatedValue: true)
        self.specializedOptionButtonEnabledRows = [Bool](count: self.specializedTasks.count, repeatedValue: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSegmentedControlWidth()
        self.setToolbar()
        self.removeBottomLineFromNavigationBar()
        self.setArraySizes()
        self.navigationItem.title = "Task List"
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
        
        self.finishButton.enabled = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)

        self.selectedTaskType = TaskType.standard

        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
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
        
        self.setReadOnlyVariablesForTaskType(self.selectedTaskType)
        
        if self.expandButtonTappedIndexPath != nil {
            if indexPath == self.expandButtonTappedIndexPath {
                
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
        
        self.setReadOnlyVariablesForTaskType(self.selectedTaskType)
        
        return self.tasks.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        self.setReadOnlyVariablesForTaskType(self.selectedTaskType)
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CareGiverTaskListTableViewCell
        
        if self.deletePhotoButtonTapped == true {
            cell.deleteImageWithAnimation()
            self.deletePhotoButtonTapped = false
        }

        if self.doneButtonEnabledRows[indexPath.row] == false {
            cell.doneButton.enabled = false
        } else {
            cell.doneButton.enabled = true
        }
        
        if self.tasksStarted == true {
            cell.doneButton.hidden = false
        } else {
            cell.doneButton.hidden = true
        }
        
        cell.textView.text = self.comments[indexPath.row]
        cell.setCell()
        cell.setTaskImage(images[indexPath.row])
        cell.taskDescriptionLabel.text = self.tasks[indexPath.row]
        
        return cell
    }

}





