//
//  ChecListViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 12/17/15.
//  Copyright © 2015 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse
import CoreData

class TaskListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIBarPositioningDelegate, CLLocationManagerDelegate {

    //Variable to hold the value passed to the next view controller. It's destination is to the CathyListTableViewController.
    var passClientName: String!
    var cathyIds = [String!]() //Queried with respect to the PFUser.currentUser() and used in sendButtonTapped function.
    var cathyNames = [String!]()
    var navigationBarLine: UIView = UIView() //Used to remove the hair line under the navigation bar.
    var expandCellIndexPathSelected: NSIndexPath? = nil
    //When the user taps a cell, it expands and saves the index and keeps it open even if the user chooses another section in the segment.
    var expandCellIndexPathStandardHolder: NSIndexPath? = nil
    var expandCellRowSelectedSpecializedHolder: NSIndexPath? = nil
    
    var messageRowSelected: Int = 0
    var sendButtonRowSelected: Int = 0
    
    var sendButtonTapped: Bool = false
    var startButtonEnabled: Bool = false
    
    
    //when you change the value for the two arrays below, make sure you change the size of it under taskMessageViewController as well.
    var segmentSelected: Int = 0
    var standardTaskMessages = [String](count: 30, repeatedValue: "")
    var specializedTaskMessages = [String](count: 30, repeatedValue: "")
    var message: String = ""
    
    var passedMessage: String = ""
    
    let cLLocationManager: CLLocationManager = CLLocationManager()
    var address: String = ""
    
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var taskListTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var startButtonActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var doneButtonActivityIndicator: UIActivityIndicatorView!
    
    var standardTasks = ["Go on a walk", "Give a bath", "Dance", "Give a message", "Practice language", "Excersice", "Go shopping", "Go out to the park", "Look at a flower", "Read a book", "Play piano", "Make a new friend", "Wash clothes", "Paint nails", "Paint"]
    let standardTasksHolder = ["Go on a walk", "Give a bath", "Dance", "Give a message", "Practice language", "Excersice", "Go shopping", "Go out to the park", "Look at a flower", "Read a book", "Play piano", "Make a new friend", "Wash clothes", "Paint nails", "Paint"]
    var specializedTasks = ["Go on a walk", "Stretch", "Cook food", "Dance", "Organize dongxi"]
    let specializedTasksHolder = ["Go on a walk", "Stretch", "Cook food", "Dance", "Organize dongxi"]
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButtonEnabled = true
        taskListTableView.reloadData()
        
        for parent in self.navigationController!.navigationBar.subviews {
            for childView in parent.subviews {
                if childView is UIImageView && childView.bounds.size.width == self.navigationController!.navigationBar.frame.size.width {
                    navigationBarLine = childView
                }
            }
        }
        
        cLLocationManager.delegate = self
        cLLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        cLLocationManager.requestWhenInUseAuthorization()
        cLLocationManager.startUpdatingLocation()
        
        doneButton.enabled = false
        startButton.enabled = false
        
        doneButtonActivityIndicator.hidden = true
        startButtonActivityIndicator.hidden = false
        startButtonActivityIndicator.startAnimating()
        
        let query = PFQuery(className:"CathyList")
        query.whereKey("giverId", equalTo: (PFUser.currentUser()?.objectId)!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                print("Successfully retrieved \(objects!.count) scores.")
                if let objects = objects {
                    for object in objects {
                        //Narrow search specific to the giver's client's cathys
                        if self.passClientName == object.objectForKey("clientName") as! String {
                            self.cathyIds.append(object.objectForKey("cathyId") as! String)
                            self.cathyNames.append(object.objectForKey("cathyName") as! String)
                        }
                    }
                    print("CathyIds retrived for tasklist \(self.cathyIds)")
                    print("CathyNames retrived for tasklist \(self.cathyNames)")
                    self.startButton.enabled = true
                    self.startButtonActivityIndicator.hidden = true
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {

        navigationBarLine.hidden = true
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        navigationBarLine.hidden = false
        
        
    }

    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            expandCellIndexPathSelected = expandCellIndexPathStandardHolder
            segmentSelected = 0
            taskListTableView.reloadData()
        case 1:
            expandCellIndexPathSelected = expandCellRowSelectedSpecializedHolder
            segmentSelected = 1
            taskListTableView.reloadData()
        default:
            break;
        }
        
    }
    
    func getGiverName() -> String {
        
        var giverName = PFUser.currentUser()?.objectForKey("firstName") as! String
        giverName += " "
        giverName += PFUser.currentUser()?.objectForKey("lastName") as! String
        return giverName
        
    }
    
    func getDate() -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        let dateInFormat = dateFormatter.stringFromDate(NSDate())
        return dateInFormat
        
    }
    
    func getTime() -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let timeInFormat = dateFormatter.stringFromDate(NSDate())
        return timeInFormat
        
    }
    
    //The location manger is declared in did load function, along with other
    func getAddress(completion: (address: String) -> Void) {
        
        
        if CLLocationManager.locationServicesEnabled() {
            
            
            var location = cLLocationManager.location
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
                            if let street = placemark.addressDictionary!["Thoroughfare"] as? String {
                                address = street
                            }
                            if let city = placemark.addressDictionary!["City"] as? String {
                                address += ", " + city
                            }
                            if let zipCode = placemark.addressDictionary!["ZIP"] as? String {
                                address += " " + zipCode
                            }
                            print(address)
                            completion(address: address)
                        } else {
                            print(error)
                        }
                    }
                    

                } else {
                    print("Longitude is nil")
                    completion(address: "Could not find an address")
                }
                
                
            } else {
                print("Latitude and longitude is nil")
                completion(address: "Could not find an address")
            }

            
        } else {
            print("location services are not enabled")
            completion(address: "Could not find an address")
        }
        
        
    }
    
    //The variables in this function that are not local to the function are cathyId, cathyName, giverId, passClientName. I'm sorry this function is so disgusting. The content of this function will be called three time. So will it's completion.
    func saveTaskInformationToParse(giverName: String, task: String, date: String, time: String, address: String, completion: (savedTaskInformation: Bool) -> Void) {
        
        for index in 0...(self.cathyIds.count - 1) {
            
            let taskInformation = PFObject(className:"TaskInformation")
            taskInformation["cathyId"] = self.cathyIds[index]
            taskInformation["cathyName"] = self.cathyNames[index]
            taskInformation["giverId"] = PFUser.currentUser()?.objectId
            taskInformation["giverName"] = giverName
            taskInformation["clientName"] = self.passClientName
            taskInformation["task"] = task
            taskInformation["date"] = self.getDate()
            taskInformation["time"] = self.getTime()
            taskInformation["address"] = address
            switch segmentSelected {
            case 0:
                taskInformation["message"] = standardTaskMessages[sendButtonRowSelected]
                print(standardTaskMessages[sendButtonRowSelected])
            case 1:
                taskInformation["message"] = specializedTaskMessages[sendButtonRowSelected]
                print(specializedTaskMessages[sendButtonRowSelected])
            default:
                break
            }
            
            taskInformation.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    completion(savedTaskInformation: true)
                    print("The object has been saved.")
                } else {
                    completion(savedTaskInformation: false)
                    print("There was a problem, check error.description")
                }
            }
            
        }
        
    }
    
    @IBAction func startButtonTapped(sender: AnyObject) {
        
        let date = getDate()
        let time = getTime()
        let giverName = getGiverName()
        
        startButtonActivityIndicator.hidden = false
        startButtonActivityIndicator.startAnimating()
        self.navigationItem.hidesBackButton = true
        startButton.enabled = false
        
        var flag = true
        getAddress() { (address) -> Void in
            self.saveTaskInformationToParse(giverName, task: "Began Tasks", date: date, time: time, address: address, completion: { (savedTaskInformation) -> Void in
                
                if flag {
                    self.startButtonActivityIndicator.hidden = true
                    self.startButton.enabled = false
                    self.doneButton.enabled = true
                    self.startButtonEnabled = true
                    self.taskListTableView.reloadData()
                    flag = false
                }
                
            })
        }
        
    }

    @IBAction func doneButtonTapped(sender: AnyObject) {
        
        doneButtonActivityIndicator.hidden = false
        doneButtonActivityIndicator.startAnimating()
        
        let date = getDate()
        let time = getTime()
        let giverName = getGiverName()
        
        var flag = true
        getAddress() { (address) -> Void in
            self.saveTaskInformationToParse(giverName, task: "Finished Tasks", date: date, time: time, address: address, completion: { (savedTaskInformation) -> Void in
                
                if flag == true {
                    self.doneButtonActivityIndicator.hidden = true
                    self.startButton.enabled = true
                    flag = false
                }
                
            })
        }
        
        self.navigationItem.hidesBackButton = false
        doneButton.enabled = false
        startButtonEnabled = false
        standardTasks = standardTasksHolder
        specializedTasks = specializedTasksHolder
        expandCellIndexPathSelected = nil
        standardTaskMessages = [String](count: 30, repeatedValue: "")
        specializedTaskMessages = [String](count: 30, repeatedValue: "")
        taskListTableView.reloadData()
        
    }

    
    @IBAction func messageButtonTapped(sender: AnyObject) {
        
        let messageButton = sender as! UIButton
        let superView = messageButton.superview!
        let taskListTableViewCell = superView.superview as! TaskListTableViewCell
        let indexPath = taskListTableView.indexPathForCell(taskListTableViewCell)
        messageRowSelected = indexPath!.row
        
    }
    
    func moveDownElements (stringArray: [String], index: Int) -> [String] {
        var tempArray = [String](count: stringArray.count, repeatedValue: "")
        
        var j = 0;
        for var i = 0; i < stringArray.count; ++i {
            if(i != index) {
                tempArray[j] = stringArray[i]
                j++
            }
        }
        return tempArray
    }
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        
        let sendButton = sender as! UIButton
        let superView = sendButton.superview!
        let taskListTableViewCell = superView.superview as! TaskListTableViewCell
        let indexPath = taskListTableView.indexPathForCell(taskListTableViewCell)
        sendButtonRowSelected = (indexPath?.row)!
        sendButtonTapped = true
        segmentedControl.enabled = false
        
        var task: String!
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            task = standardTasks[indexPath!.row]
            taskListTableView.reloadData()
        case 1:
            task = specializedTasks[indexPath!.row]
            taskListTableView.reloadData()
        default:
            break
        }
        
        let date = getDate()
        let time = getTime()
        let giverName = getGiverName()
        
        
        //saveTaskInformationToParse will run three timese here. That's why I have a check here with the if statement so that the removeAtIndex function won't be called three times. 
        var flag = true
        getAddress() { (address) -> Void in
            self.saveTaskInformationToParse(giverName, task: task, date: date, time: time, address: address, completion: { (savedTaskInformation) -> Void in
                
                if flag {
                    self.segmentedControl.enabled = true
                    if savedTaskInformation == true {
                        
                        switch self.segmentedControl.selectedSegmentIndex {
                        case 0:
                            self.standardTasks.removeAtIndex(indexPath!.row)
                            self.sendButtonTapped = false
                        case 1:
                            self.specializedTasks.removeAtIndex(indexPath!.row)
                            self.sendButtonTapped = false
                        default:
                            break
                        }
                        
                        if self.sendButtonRowSelected == self.expandCellIndexPathSelected?.row {
                            self.expandCellIndexPathSelected = nil
                        } else {
                            if self.sendButtonRowSelected < self.expandCellIndexPathSelected?.row {
                                self.expandCellIndexPathSelected = NSIndexPath(forItem: self.expandCellIndexPathSelected!.row - 1, inSection: 0)
                            }
                        }
                        
                        switch self.segmentSelected {
                        case 0:
                            self.standardTaskMessages = self.moveDownElements(self.standardTaskMessages, index: self.sendButtonRowSelected)
                        case 1:
                            self.specializedTaskMessages = self.moveDownElements(self.specializedTaskMessages, index: self.sendButtonRowSelected)
                        default:
                            break
                        }
                        
                        self.taskListTableView.reloadData()
                        flag = false
                        
                    }
                }
                
            })
        }
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return standardTasks.count
        case 1:
            return specializedTasks.count
        default:
            break
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TaskListTableViewCell

        if startButtonEnabled == true {
            cell.sendButton.enabled = true
            cell.messageButton.enabled = true
        } else {
            cell.sendButton.enabled = false
            cell.messageButton.enabled = false
        }

        if sendButtonTapped == true {
            cell.sendButton.enabled = false
            cell.messageButton.enabled = false 
        }
        
        if sendButtonTapped == true && sendButtonRowSelected == indexPath.row {
            cell.activityIndicator.hidden = false
            cell.activityIndicator.startAnimating()
        } else {
            cell.activityIndicator.hidden = true
        }
        
        var task: String!
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            task = standardTasks[indexPath.row]
        case 1:
            task = specializedTasks[indexPath.row]
        default:
            break
        }
        
        cell.taskLabel!.text = task
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        switch expandCellIndexPathSelected {
        case nil:
            expandCellIndexPathSelected = indexPath
        default:
            if expandCellIndexPathSelected! == indexPath {
                expandCellIndexPathSelected = nil
            } else {
                expandCellIndexPathSelected = indexPath
            }
        }
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            expandCellIndexPathStandardHolder = expandCellIndexPathSelected
        case 1:
            expandCellRowSelectedSpecializedHolder = expandCellIndexPathSelected
        default:
            break
        }
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let normalHeight: CGFloat = 44.0
        let expandedHeight: CGFloat = 60.0
        let indexPath = indexPath
        if expandCellIndexPathSelected != nil {
            if indexPath == expandCellIndexPathSelected! {
                return expandedHeight
            } else {
                return normalHeight
            }
        } else {
            return normalHeight
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "giverTaskListToCathyList" {
            
            let giverCathyListTableViewController = segue.destinationViewController as! GiverCathyListTableViewController
            
            giverCathyListTableViewController.passedClientName = passClientName
            
        } else if segue.identifier == "taskListToTaskMessage" {
            
            let taskMessageViewController = segue.destinationViewController as! TaskMessageViewController
            
            switch segmentSelected {
            case 0:
                taskMessageViewController.message[messageRowSelected] = standardTaskMessages[messageRowSelected]
            case 1:
                taskMessageViewController.message[messageRowSelected] = specializedTaskMessages[messageRowSelected]
            default:
                break
            }
            taskMessageViewController.messageRowSelected = messageRowSelected
        }
        
    }
    
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {
    
        if let taskMessageViewController = segue.sourceViewController as? TaskMessageViewController {
            passedMessage = taskMessageViewController.messageTextView.text
            messageRowSelected = taskMessageViewController.messageRowSelected
        }
        
        switch segmentSelected {
        case 0:
            standardTaskMessages[messageRowSelected] = passedMessage
        case 1:
            specializedTaskMessages[messageRowSelected] = passedMessage
        default:
            break
        }
    
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
