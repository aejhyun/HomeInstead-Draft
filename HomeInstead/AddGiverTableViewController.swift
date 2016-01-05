//
//  AddGiverTableViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 1/4/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class AddGiverTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {

    var giverNames = [String]()
    var giverEmails = [String]()
    var giverNamesEmails = [String: String]()
    var filteredGiverNames = [String]()
    var showSearchResults = false
    var searchController: UISearchController!
    
    func configureSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a giver :)"
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchBar()
        
        let query = PFQuery(className: "_User")
        query.whereKey("userType", equalTo: "giver")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) objects.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        if object.objectForKey("alreadyAddedByOffice") as! Bool == false {
                            let giverName = object.objectForKey("fullName") as! String
                            let giverEmail = object.objectForKey("email") as! String
                            self.giverNames.append(giverName)
                            self.giverEmails.append(giverEmail)
                            self.giverNamesEmails[giverName] = giverEmail
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
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        showSearchResults = true
        tableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        showSearchResults = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !showSearchResults {
            showSearchResults = true
            tableView.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        filteredGiverNames = giverNames.filter({ (giverName) -> Bool in
            let giverNameText: NSString = giverName
            return (giverNameText.rangeOfString(searchString!, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showSearchResults {
            return filteredGiverNames.count
        } else {
            return giverNames.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AddGiverTableViewCell
        
        if showSearchResults {
            cell.giverNameLabel.text = filteredGiverNames[indexPath.row]
            cell.giverEmailLabel.text = giverNamesEmails[filteredGiverNames[indexPath.row]]
        } else {
            cell.giverNameLabel.text = giverNames[indexPath.row]
            cell.giverEmailLabel.text = giverEmails[indexPath.row]
        }


        return cell
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
