//
//  OfficeChooseUserTypeTableViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 4/9/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class OfficeChooseUserTypeTableViewController: UITableViewController {
    
    var userTypes: [String] = ["Care Giver", "Cathy", "Client"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = userTypes[indexPath.row]

        return cell
    }
    
    @IBAction func signOutButtonTapped(sender: AnyObject) {
        
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
            if let error = error {
                print(error)
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }
        }
        
    }


}
