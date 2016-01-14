//
//  OfficeCathyTableViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 12/27/15.
//  Copyright © 2015 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class OfficeCathyListTableViewController: UITableViewController {
    
    var passedGiverName: String = ""
    var passedGiverId: String = ""
    var passedGiverEmail: String = ""
    var passedClientName: String = ""
    var cathyNames = [String]()
    var cathyEmails = [String]()
    var objects = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        
        cathyNames.removeAll()
        cathyEmails.removeAll()
        
        let query = PFQuery(className:"CathyList")
        query.whereKey("officeId", equalTo: (PFUser.currentUser()?.objectId)!)
        query.whereKey("clientName", equalTo: passedClientName)
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
                        self.cathyNames.append(object.objectForKey("cathyName") as! String)
                        self.cathyEmails.append(object.objectForKey("cathyEmail") as! String)
                    }
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
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
        return cathyNames.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! OfficeCathyListTableViewCell
        cell.cathyNameLabel.text = cathyNames[indexPath.row]
        cell.cathyEmailLabel.text = cathyEmails[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            cathyNames.removeAtIndex(indexPath.row)
            cathyEmails.removeAtIndex(indexPath.row)
            
            let query = PFQuery(className:"CathyList")
            query.getObjectInBackgroundWithId(objects[indexPath.row].objectId!) {
                (cathyList: PFObject?, error: NSError?) -> Void in
                if error != nil {
                    print(error?.description)
                } else if let cathyList = cathyList {
                    cathyList["alreadyAddedByOffice"] = false
                    cathyList["clientName"] = ""
                    cathyList["officeId"] = ""
                    cathyList["officeName"] = ""
                    cathyList["officeEmail"] = ""
                    cathyList["giverName"] = ""
                    cathyList["giverId"] = ""
                    cathyList["giverEmail"] = ""
                    cathyList.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            print("Successfully updated object containing \(self.objects[indexPath.row].objectForKey("cathyName")).")
                        } else {
                            print(error?.description)
                        }
                    })
                }
            }
            objects[indexPath.row].unpinInBackground()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let addCathyTableViewController = segue.destinationViewController as! AddCathyTableViewController
        
        addCathyTableViewController.passedClientName = passedClientName
        addCathyTableViewController.passedGiverId = passedGiverId
        addCathyTableViewController.passedGiverName = passedGiverName
        addCathyTableViewController.passedGiverEmail = passedGiverEmail
        
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
