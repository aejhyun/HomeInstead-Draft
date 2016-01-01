//
//  ClientListTableViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 12/15/15.
//  Copyright © 2015 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class GiverClientListTableViewController: UITableViewController {
    
    //Array used to populate the table views.
    var clientNames = [String]()
    //Variable to hold the value passed to the next view controller. It's destination is to the CathyListTableViewController. It's being passed twice. 
    var passClientName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFQuery(className:"ClientList")
        query.whereKey("giverId", equalTo: (PFUser.currentUser()?.objectId)!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) objects.")
                if let objects = objects {
                    for object in objects {
                        //print(object.objectForKey("clientName")!)
                        self.clientNames.append(object.objectForKey("clientName") as! String)
                    }
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    
    //We can have a base with client names so that Givers can't add random names.
    
    

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
        cell.textLabel?.text = clientNames[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let indexPath = tableView.indexPathForSelectedRow!;
        let currentCell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
        passClientName = (currentCell.textLabel?.text)!
        performSegueWithIdentifier("clientListToCheckList", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "clientListToCheckList") {
            let taskListViewController = segue.destinationViewController as! TaskListViewController
            taskListViewController.passClientName = passClientName
        }
    }
    
    @IBAction func signOutButtonTapped(sender: AnyObject) {
        PFUser.logOut()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
//    @IBAction func addButtonTapped(sender: AnyObject) {
//        
//        var nameTextField: UITextField?
//        let enterNameAlert = UIAlertController(title: nil, message: "Enter client's name", preferredStyle: UIAlertControllerStyle.Alert)
//        enterNameAlert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
//            textField.placeholder = "Name"
//            nameTextField = textField
//        })
//        enterNameAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
//            
//            let clientList = PFObject(className: "ClientList")
//            clientList["giverId"] = PFUser.currentUser()?.objectId
//            clientList["clientName"] = nameTextField!.text
//            clientList.saveInBackgroundWithBlock {
//                (success: Bool, error: NSError?) -> Void in
//                if (success) {
//                    //The function call empties the clientList array and fills it with the array with the new name that the user provided. And reloadData() and MyActivityIndicatoris included in this function.
//                    self.getClientList(true)
//                } else {
//                    // There was a problem, check error.description
//                }
//            }
//            
//        }))
//        enterNameAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
//        presentViewController(enterNameAlert, animated: true, completion: nil)
//    }
    
    
    
    
    //    func getClientList() {
    //        let activityIndicator = MyActivityIndicator()
    //        activityIndicator.startActivityIndicator(self.view, x: 187.5, 270)
    //
    //        let query = PFQuery(className:"ClientList")
    //        query.whereKey("giverId", equalTo: (PFUser.currentUser()?.objectId)!)
    //        query.findObjectsInBackgroundWithBlock {
    //            (objects: [PFObject]?, error: NSError?) -> Void in
    //
    //            if error == nil {
    //                // The find succeeded.
    //                print("Successfully retrieved \(objects!.count) objects.")
    //                if let objects = objects {
    //                    for object in objects {
    //                        //print(object.objectForKey("clientName")!)
    //                        self.clientList.append(object.objectForKey("clientName") as! String)
    //                    }
    //                    self.tableView.reloadData()
    //                    activityIndicator.endActivityIndicator()
    //                }
    //            } else {
    //                // Log details of the failure
    //                print("Error: \(error!) \(error!.userInfo)")
    //            }
    //        }
    //
    //    }
    
    //    func getUpdatedClientList() {
    //        let activityIndicator = MyActivityIndicator()
    //        activityIndicator.startActivityIndicator(self.view, x: 187.5, 270)
    //
    //        self.clientList.removeAll()
    //        let query = PFQuery(className:"ClientList")
    //        query.whereKey("giverId", equalTo: (PFUser.currentUser()?.objectId)!)
    //        query.findObjectsInBackgroundWithBlock {
    //            (objects: [PFObject]?, error: NSError?) -> Void in
    //
    //            if error == nil {
    //                // The find succeeded.
    //                print("Successfully retrieved \(objects!.count) objects.")
    //                if let objects = objects {
    //                    for object in objects {
    //                        //print(object.objectForKey("clientName")!)
    //                        self.clientList.append(object.objectForKey("clientName") as! String)
    //                    }
    //                    self.tableView.reloadData()
    //                    activityIndicator.endActivityIndicator()
    //                }
    //            } else {
    //                // Log details of the failure
    //                print("Error: \(error!) \(error!.userInfo)")
    //            }
    //        }
    //    
    //    }
    
    
    
    
    
    
    

    

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
