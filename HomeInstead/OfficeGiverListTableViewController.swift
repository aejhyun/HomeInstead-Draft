//
//  OfficeGiverListTableViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 12/24/15.
//  Copyright © 2015 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class OfficeGiverListTableViewController: UITableViewController,  OfficeGiverListTableViewControllerDelegate {
    
    var giverNames = [String]()
    var giverEmails = [String]()
    var giverIds = [String]()
    var giverNameToBePassed: String = ""
    var giverIdToBePassed: String = ""
    var giverEmailToBePassed: String = ""
    var objects = [PFObject]()
    var clientFirstName: String!
    var clientLastName: String!
    var clientNotes: String!
    var clientImage: UIImage?
    var cathyNames: [String] = [String]()
    var cathyEmails: [String] = [String]()
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    func appAlreadyLaunchedOnce() -> Bool {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.boolForKey("FirstTimeLoadingOfficeGiverListOnThisDeviceForUser: \(PFUser.currentUser()!.objectId)") {
            return true
        } else {
            userDefaults.setBool(true, forKey: "FirstTimeLoadingOfficeGiverListOnThisDeviceForUser: \(PFUser.currentUser()!.objectId)")
            return false
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if appAlreadyLaunchedOnce() {
            
            giverNames.removeAll()
            giverIds.removeAll()
            giverEmails.removeAll()
            let query = PFQuery(className:"GiverList")
            query.whereKey("officeId", equalTo: (PFUser.currentUser()?.objectId)!)
            query.fromLocalDatastore()
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) objects.")
                    // Do something with the found objects
                    if let objects = objects {
                        self.objects = objects
                        for object in objects {
                            self.giverNames.append(object.objectForKey("giverName") as! String)
                            self.giverIds.append(object.objectForKey("giverId") as! String)
                            self.giverEmails.append(object.objectForKey("giverEmail") as! String)
                        }
                        self.tableView.reloadData()
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }

        } else {
            
            let query = PFQuery(className:"GiverList")
            query.whereKey("officeId", equalTo: (PFUser.currentUser()?.objectId)!)
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) objects.")
                    // Do something with the found objects
                    if let objects = objects {
                        self.objects = objects
                        for object in objects {
                            self.giverNames.append(object.objectForKey("giverName") as! String)
                            self.giverIds.append(object.objectForKey("giverId") as! String)
                            self.giverEmails.append(object.objectForKey("giverEmail") as! String)
                            object.pinInBackground()
                        }
                        self.tableView.reloadData()
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
            
        }
 
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return giverNames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! OfficeGiverListTableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.giverNameLabel.text = giverNames[indexPath.row]
        cell.giverEmailLabel.text = giverEmails[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow!;
        giverNameToBePassed = giverNames[indexPath.row]
        giverEmailToBePassed = giverEmails[indexPath.row]
        giverIdToBePassed = giverIds[indexPath.row]
        
        performSegueWithIdentifier("officeGiverListToClientList", sender: self)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {

            let giverListQuery = PFQuery(className:"GiverList")
            giverListQuery.getObjectInBackgroundWithId(objects[indexPath.row].objectId!) {
                (giverList: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    print(error?.description)
                } else if let giverList = giverList {
                    giverList["alreadyAddedByOffice"] = false
                    giverList["officeId"] = ""
                    giverList["officeName"] = ""
                    giverList["officeEmail"] = ""
                    giverList.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            print("Successfully updated object containing \(self.objects[indexPath.row].objectForKey("giverName")) for the GiverList Class")
                        } else {
                            print(error?.description)
                        }
                    })
                }
            }
            
            let clientListQuery = PFQuery(className:"ClientList")
            clientListQuery.whereKey("giverId", equalTo: giverIds[indexPath.row])
            clientListQuery.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    print("Successfully retrieved \(objects!.count) objects.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            object.deleteInBackground()
                            object.unpinInBackground()
                        }
                        self.tableView.reloadData()
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
            
            let cathyListQuery = PFQuery(className:"CathyList")
            cathyListQuery.whereKey("giverId", equalTo: giverIds[indexPath.row])
            cathyListQuery.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) objects.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            object["alreadyAddedByOffice"] = false
                            object["giverEmail"] = ""
                            object["giverId"] = ""
                            object["giverName"] = ""
                            object["officeEmail"] = ""
                            object["officeId"] = ""
                            object["officeName"] = ""
                            object["clientName"] = ""
                            object.saveInBackground()
                        }
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
            
            giverNames.removeAtIndex(indexPath.row)
            giverIds.removeAtIndex(indexPath.row)
            giverEmails.removeAtIndex(indexPath.row)
            
            objects[indexPath.row].unpinInBackground()
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "officeGiverListToClientList") {
            let officeClientListTableViewController = segue.destinationViewController as! OfficeClientListTableViewController
            officeClientListTableViewController.passedGiverName = giverNameToBePassed
            officeClientListTableViewController.passedGiverId = giverIdToBePassed
            officeClientListTableViewController.passedGiverEmail = giverEmailToBePassed
        } else if segue.identifier == "officeGiverListToOfficeCreateClientProfile" {

            if let navigationController = segue.destinationViewController as? UINavigationController {
                if let officeCreateClientProfileViewController = navigationController.topViewController as? OfficeCreateClientProfileViewController {
                    officeCreateClientProfileViewController.delegate = self
                } else {
                    print("officeCreateClientProfileViewController is nil")
                }
            } else {
                print("navigationController is nil")
            }
        
        } else if segue.identifier == "officeGiverListToOfficeClientProfile" {
            if let officeClientProfileViewController = segue.destinationViewController as? OfficeClientProfileViewController {
                officeClientProfileViewController.firstName = self.clientFirstName
                officeClientProfileViewController.lastName = self.clientLastName
                officeClientProfileViewController.notes = self.clientNotes
                officeClientProfileViewController.image = self.clientImage
                officeClientProfileViewController.cathyNames = self.cathyNames
                officeClientProfileViewController.cathyEmails = self.cathyEmails
            } else {
                print("officeClientProfileViewController is nil")
            }
        }
    }
    
//OfficeGiverListTableViewControllerDelegate protocol functions
    
    func getClientFirstName(firstName: String) {
        self.clientFirstName = firstName
    }
    
    func getClientLastName(lastName: String) {
        self.clientLastName = lastName
    }

    func getClientNotes(notes: String) {
        self.clientNotes = notes
    }
    
    func getClientImage(image: UIImage?) {
        self.clientImage = image
    }
    
    func getCathyNames(names: [String]) {
        self.cathyNames = names
    }
    
    func getCathyEmails(emails: [String]) {
        self.cathyEmails = emails
    }
    
    func segueToOfficeClientProfileViewController() {
        performSegueWithIdentifier("officeGiverListToOfficeClientProfile", sender: nil)
    }
    
    @IBAction func signOutButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        PFUser.logOut()
    }

}
