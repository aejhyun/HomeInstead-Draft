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
    var giverEmails = [String]()
    var giverIds = [String]()
    var giverNameToBePassed: String = ""
    var giverIdToBePassed: String = ""
    var giverEmailToBePassed: String = ""
    var objects = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
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
        
    }
    
    @IBAction func addGiverButtonPressed(sender: AnyObject) {

        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "officeGiverListToClientList") {
            let officeClientListTableViewController = segue.destinationViewController as! OfficeClientListTableViewController
            officeClientListTableViewController.passedGiverName = giverNameToBePassed
            officeClientListTableViewController.passedGiverId = giverIdToBePassed
            officeClientListTableViewController.passedGiverEmail = giverEmailToBePassed
        }
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
            
            
            
//            cathyListQuery.getObjectInBackgroundWithId(objects[indexPath.row].objectId!) {
//                (cathyList: PFObject?, error: NSError?) -> Void in
//                if error != nil {
//                    print(error?.description)
//                } else if let cathyList = cathyList {
//                    cathyList["officeId"] = ""
//                    cathyList["officeName"] = ""
//                    cathyList["officeEmail"] = ""
//                    cathyList["giverName"] = ""
//                    cathyList["giverId"] = ""
//                    cathyList["giverEmail"] = ""
//                    cathyList["clientName"] = ""
//                    
//                    cathyList.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
//                        if (success) {
//                            print("Successfully updated object containing \(self.objects[indexPath.row].objectForKey("giverName")) for the CathyList Class.")
//                        } else {
//                            print(error?.description)
//                        }
//                    })
//                }
//            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
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
