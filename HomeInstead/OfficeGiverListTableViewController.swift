//
//  OfficeGiverListTableViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 12/24/15.
//  Copyright © 2015 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class OfficeGiverListTableViewController: UITableViewController {
    
    var giverNames = [String]()
    var giverIds = [String]()
    var passGiverName: String = ""
    var passGiverId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        let query = PFQuery(className:"GiverList")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) objects.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        self.giverNames.append(object.objectForKey("giverName") as! String)
                        self.giverIds.append(object.objectForKey("giverId") as! String)
                    }
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }

    @IBAction func addGiverButtonPressed(sender: AnyObject) {

        var nameTextField: UITextField?
        let enterNameAlert = UIAlertController(title: "Add a Giver :)", message: "Enter giver's name", preferredStyle: UIAlertControllerStyle.Alert)
        enterNameAlert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Full Name"
            nameTextField = textField
        })
        enterNameAlert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
            if self.giverNames.contains((nameTextField?.text)!) {
                print("Did not add giver because the giver is already in the list")
            } else {
                
                let query = PFQuery(className:"_User")
                query.whereKey("fullName", equalTo: nameTextField!.text!)
                query.findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    
                    if error == nil {
                        if objects!.count != 0 {
                            print("Found the giver with that email account")
                            
                            var giverName: String!
                            var giverId: String!
                            if let objects = objects {
                                for object in objects {
                                    giverName = object.objectForKey("fullName") as! String
                                    giverId = object.objectId
                                    self.giverNames.append(giverName)
                                    self.giverIds.append(giverId)
                                }
                                
                                self.tableView.reloadData()
                                
                                //Make sure before I push to CathyList, check if the userType is actually Cathy and not some other userType.
                                //Also make sure that the giver doesn't accidentally save the same Cathys twice. Do an error check.
                                let giverList = PFObject(className:"GiverList")
                                giverList["giverName"] = giverName
                                giverList["giverId"] = giverId
                                giverList.saveInBackgroundWithBlock {
                                    (success: Bool, error: NSError?) -> Void in
                                    if (success) {
                                        
                                    } else {
                                        // There was a problem, check error.description
                                    }
                                }
                            }
                        } else {
                            print("Error: Couldn't find the cathy with that email account")
                        }
                    } else {
                        print("Error: \(error!) \(error!.userInfo)")
                    }
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
        return giverNames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = giverNames[indexPath.row]
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!;
        passGiverName = giverNames[indexPath.row]
        passGiverId = giverIds[indexPath.row]
        
        performSegueWithIdentifier("officeGiverListToClientList", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "officeGiverListToClientList") {
            let officeClientListTableViewController = segue.destinationViewController as! OfficeClientListTableViewController
            officeClientListTableViewController.passedGiverName = passGiverName
            officeClientListTableViewController.passedGiverId = passGiverId
        }
    }

    @IBAction func signOutButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        PFUser.logOut()
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
