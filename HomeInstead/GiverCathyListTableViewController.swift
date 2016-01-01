//
//  CathyListTableViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 12/19/15.
//  Copyright © 2015 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class GiverCathyListTableViewController: UITableViewController {
    
    //Variable that was passed from the ClientListTableViewController
    var passedClientName: String!
    //Variable holding the list of cathys.
    var cathyNames = [String!]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query = PFQuery(className:"CathyList")
        query.whereKey("giverId", equalTo: (PFUser.currentUser()?.objectId)!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        //Narrow search specific to the giver's client's cathys
                        if self.passedClientName == object.objectForKey("clientName") as! String {
                            self.cathyNames.append(object.objectForKey("cathyName") as! String)
                        }
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! GiverCathyListTableViewCell
        cell.cathyNameLabel.text = cathyNames[indexPath.row]
        
        return cell
    }
    
}


//    @IBAction func addButtonTapped(sender: AnyObject) {
//        
//        var emailTextField: UITextField?
//        let enterEmailAlert = UIAlertController(title: nil, message: "Enter cathy's email", preferredStyle: UIAlertControllerStyle.Alert)
//        enterEmailAlert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
//            textField.placeholder = "email"
//            emailTextField = textField
//        })
//        enterEmailAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
//            
//            let query = PFQuery(className:"_User")
//            query.whereKey("username", equalTo:emailTextField!.text!)
//            query.findObjectsInBackgroundWithBlock {
//                (objects: [PFObject]?, error: NSError?) -> Void in
//                
//                if error == nil {
//                    if objects!.count != 0 {
//                        print("Found and saved the cathy with that email account")
//                        
//                        var cathyName = ""
//                        var cathyId = ""
//                        var giverName = ""
//                        
//                        if let objects = objects {
//                            for object in objects {
//                                cathyName = object.objectForKey("firstName") as! String
//                                cathyName += " "
//                                cathyName += object.objectForKey("lastName") as! String
//                                cathyId = object.objectId!
//                            }
//                            giverName = PFUser.currentUser()?.objectForKey("firstName") as! String
//                            giverName += " "
//                            giverName += PFUser.currentUser()?.objectForKey("lastName") as! String
//                            
//                            //Make sure before I push to CathyList, check if the userType is actually Cathy and not some other userType.
//                            //Also make sure that the giver doesn't accidentally save the same Cathys twice. Do an error check.
//                            let cathyList = PFObject(className:"CathyList")
//                            cathyList["cathyName"] = cathyName
//                            cathyList["cathyId"] = cathyId
//                            cathyList["giverName"] = giverName
//                            cathyList["giverId"] = PFUser.currentUser()?.objectId
//                            cathyList["clientName"] = self.passedClientName
//                            cathyList["requestAccepted"] = false
//                            
//                            cathyList.saveInBackgroundWithBlock {
//                                (success: Bool, error: NSError?) -> Void in
//                                if (success) {
//                                    self.getCathyList(true)
//                                } else {
//                                    // There was a problem, check error.description
//                                }
//                            }
//                        }
//                    } else {
//                        print("Error: Couldn't find the cathy with that email account")
//                    }
//                } else {
//                    print("Error: \(error!) \(error!.userInfo)")
//                }
//            }
//            
//        }))
//        enterEmailAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
//        presentViewController(enterEmailAlert, animated: true, completion: nil)
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





//    func getUpdatedClientList() {
//        self.cathyList.removeAll()
//
//        let query = PFQuery(className:"CathyList")
//        query.whereKey("giverId", equalTo: (PFUser.currentUser()?.objectId)!)
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [PFObject]?, error: NSError?) -> Void in
//
//            if error == nil {
//                print("Successfully retrieved \(objects!.count) scores.")
//                if let objects = objects {
//                    for object in objects {
//                        //Narrow search specific to the giver's client's cathys
//                        if self.passedClientName == object.objectForKey("clientName") as! String {
//                            self.cathyList.append(object.objectForKey("cathyName") as! String)
//                        }
//                    }
//                    print(self.cathyList)
//                    self.tableView.reloadData()
//                }
//            } else {
//                // Log details of the failure
//                print("Error: \(error!) \(error!.userInfo)")
//            }
//        }
//
//    }

