//
//  OfficeAddUserTableViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 4/11/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class OfficeAddUserTableViewController: UITableViewController {

    var selectedUserType: UserType!
    var users: [[String: String]] = [[String: String]]()
    
    func setNavigationBarTitle() {
        
        if self.selectedUserType == UserType.careGiver {
            self.navigationItem.title = "Add Care Giver"
        } else if self.selectedUserType == UserType.cathy {
            self.navigationItem.title = "Add Cathy"
        } else if self.selectedUserType == UserType.client {
            self.navigationItem.title = "Add Client"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBarTitle()
        
        self.queryUserInformationFromCloudWithClassName("CareGiverUser") { (querySuccessful) -> Void in
            
            if querySuccessful {
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    func queryUserInformationFromCloudWithClassName(className: String, completion: (querySuccessful: Bool) -> Void) {
        
        var userInformation: [String: String] = [String: String]()
        let query = PFQuery(className:className)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        userInformation["imageFile"] = nil
                        userInformation["name"] = object.objectForKey("name") as? String
                        userInformation["email"] = object.objectForKey("email") as? String
                        userInformation["province"] = object.objectForKey("province") as? String
                        userInformation["city"] = object.objectForKey("city") as? String
                        userInformation["street"] = object.objectForKey("street") as? String
                        userInformation["postalCode"] = object.objectForKey("postalCode") as? String
                        userInformation["phoneNumber"] = object.objectForKey("phoneNumber") as? String
                        userInformation["emergencyPhoneNumber"] = object.objectForKey("emergencyPhoneNumber") as? String
                        self.users.append(userInformation)
                    }
                    completion(querySuccessful: true)
                }
            } else {
                completion(querySuccessful: false)
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! OfficeAddUserTableViewCell

        cell.nameLabel.text = "Name"
        cell.emailLabel.text = "Email"

        return cell
    }
    

    @IBAction func doneButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
