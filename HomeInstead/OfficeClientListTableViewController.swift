//
//  OfficeClientListTableViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 12/27/15.
//  Copyright © 2015 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class OfficeClientListTableViewController: UITableViewController {
    
    var passedGiverName: String = ""
    var passedGiverId: String = ""
    var passedGiverEmail: String = ""
    var clientNames = [String!]()
    var clientNameToBePassed: String = ""
    
    func appAlreadyLaunchedOnce() -> Bool {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.boolForKey("FirstTimeLoadingOfficeClientListOnThisDeviceForUser: \(PFUser.currentUser()!.objectId)") {
            return true
        } else {
            userDefaults.setBool(true, forKey: "FirstTimeLoadingOfficeClientListOnThisDeviceForUser: \(PFUser.currentUser()!.objectId)")
            return false
        
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if appAlreadyLaunchedOnce() {

            let query = PFQuery(className:"ClientList")
            query.fromLocalDatastore()
            query.whereKey("giverId", equalTo: passedGiverId)
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) objects.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            self.clientNames.append(object.objectForKey("clientName") as! String)
                        }
                        self.tableView.reloadData()
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
            
        } else {

            let query = PFQuery(className:"ClientList")
            query.whereKey("giverId", equalTo: passedGiverId)
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) objects.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            self.clientNames.append(object.objectForKey("clientName") as! String)
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
    
    //When uploading the clientList, make sure you have the "clientName", "giverName", and "giverId"

    @IBAction func addClientButtonPressed(sender: AnyObject) {
        
        var nameTextField: UITextField?
        let enterNameAlert = UIAlertController(title: "Add a Client :)", message: "Enter client's name", preferredStyle: UIAlertControllerStyle.Alert)
        enterNameAlert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Full Name"
            nameTextField = textField
        })
        enterNameAlert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
            //Also make sure that the giver doesn't accidentally save the same Givers twice. Do an error check.
            let clientList = PFObject(className:"ClientList")
            clientList["clientName"] = nameTextField!.text
            clientList["giverName"] = self.passedGiverName
            clientList["giverId"] = self.passedGiverId
            clientList["giverEmail"] = self.passedGiverEmail
            clientList["officeName"] = PFUser.currentUser()?.objectForKey("fullName")
            clientList["officeId"] = PFUser.currentUser()?.objectId
            clientList["officeEmail"] = PFUser.currentUser()?.objectForKey("email")
            self.clientNames.append(nameTextField!.text)
            self.tableView.reloadData()
            clientList.pinInBackground()
            clientList.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    
                } else {
                    // There was a problem, check error.description
                }
            }
            
        }))
        
        enterNameAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(enterNameAlert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return clientNames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = clientNames[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!;
        clientNameToBePassed = clientNames[indexPath.row]
        performSegueWithIdentifier("officeClientListToCathyList", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "officeClientListToCathyList") {
            let officeClientListTableViewController = segue.destinationViewController as! OfficeCathyListTableViewController
            officeClientListTableViewController.passedGiverName = passedGiverName
            officeClientListTableViewController.passedGiverId = passedGiverId
            officeClientListTableViewController.passedGiverEmail = passedGiverEmail
            officeClientListTableViewController.passedClientName = clientNameToBePassed
        }
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
