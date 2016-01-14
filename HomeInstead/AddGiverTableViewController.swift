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
    var giverEmailsNames = [String: String]()
    var searchGiverNamesEmails = [String]()
    var filteredGiverEmails = [String]()
    var filteredSearchGiverNamesEmails = [String]()
    var giverEmailsObjectIds = [String: String]()
    var showSearchResults = false
    var addButtonRowSelected = -1
    var searchController: UISearchController!
    var passedClientName: String = ""
    
    func configureSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a giver :)"
        searchController.searchBar.sizeToFit()
        searchController.loadView()
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchBar()

        let query = PFQuery(className: "GiverList")
        query.whereKey("alreadyAddedByOffice", equalTo: false)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) objects.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        let giverName = object.objectForKey("giverName") as! String
                        let giverEmail = object.objectForKey("giverEmail") as! String
                        self.giverEmails.append(giverEmail)
                        self.giverNames.append(giverName)
                        self.giverNamesEmails[giverName] = giverEmail
                        self.giverEmailsNames[giverEmail] = giverName
                        self.giverEmailsObjectIds[giverEmail] = object.objectId
                        self.searchGiverNamesEmails.append(giverName)
                        self.searchGiverNamesEmails.append(giverEmail)
                    }
                    self.tableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        
        let addButton = sender as! UIButton
        let superView = addButton.superview!
        let addGiverTableViewCell = superView.superview as! AddGiverTableViewCell
        let indexPath = tableView.indexPathForCell(addGiverTableViewCell)
        addButtonRowSelected = (indexPath?.row)!
        self.tableView.reloadData()
        
        var selectedGiverEmail = ""
        
        if showSearchResults {
            selectedGiverEmail = filteredGiverEmails[addButtonRowSelected]
        } else {
            selectedGiverEmail = giverEmails[addButtonRowSelected]
        }
        
        let query = PFQuery(className:"GiverList")
        query.getObjectInBackgroundWithId(giverEmailsObjectIds[selectedGiverEmail]!) {
            (giverList: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error?.description)
            } else if let giverList = giverList {
                giverList["alreadyAddedByOffice"] = true
                giverList["officeId"] = PFUser.currentUser()?.objectId
                giverList["officeName"] = PFUser.currentUser()?.objectForKey("fullName")
                giverList["officeEmail"] = PFUser.currentUser()?.objectForKey("email")
                giverList.pinInBackground()
                giverList.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        //this removing of element is for the user to see it dissappear. It's mainly for look because filteredGiverEmails will be loaded with new emails every single time the search is used.
                        self.filteredGiverEmails = self.filteredGiverEmails.filter {$0 != selectedGiverEmail}
                        self.giverEmails = self.giverEmails.filter {$0 != selectedGiverEmail}
                        self.giverNames = self.giverNames.filter {$0 != self.giverEmailsNames[selectedGiverEmail]}
                        self.searchGiverNamesEmails = self.giverEmails
                        self.searchGiverNamesEmails += self.giverNames
                        //after the user adds a giver, the searchGiverNamesEmails gets smaller with self.filteredGiverEmails = self.filteredGiverEmails.filter {$0 != selectedGiverEmail}. So instead of using searchGiverNamesEmails which is the old string that was retrived from view did load, I "refresh it with the newest set of emails and givernames that should be displayed to the user. Remember searchGiverNamesEmails needs to have both the emails and the names for it to work because I cannot call updateSearchResultsForSearchController for both email and name. I had to put it into one array.
                        self.addButtonRowSelected = -1
                        self.tableView.reloadData()
                    } else {
                        print(error?.description)
                    }
                }
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
        
        filteredGiverEmails.removeAll()
        let searchString = searchController.searchBar.text
        filteredSearchGiverNamesEmails = searchGiverNamesEmails.filter({ (giverNameEmail) -> Bool in
            let giverNameEmailText: NSString = giverNameEmail
            return (giverNameEmailText.rangeOfString(searchString!, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
        
        //With the following code, I get the filteredSearchGiverNamesEmails array that has both the giver names and emails and translate it into unique emails. So if the user types "a", and both the giver's email and name has the letter "a", it will then appened to filteredGiverEmails one email for both the name and the email. And by using the dictionary of giverEmailsNames, I can translate this unique email into the giver's name. The reason for this is in the case of givers having the same name but obviously different emails.
        for var filteredSearchGiverNameEmail in filteredSearchGiverNamesEmails {
            if filteredSearchGiverNameEmail.rangeOfString("@") == nil {
                filteredSearchGiverNameEmail = giverNamesEmails[filteredSearchGiverNameEmail]!
            }
            if filteredGiverEmails.contains(filteredSearchGiverNameEmail) == false {
                filteredGiverEmails.append(filteredSearchGiverNameEmail)
            }
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath
        indexPath: NSIndexPath) {
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showSearchResults {
            return filteredGiverEmails.count
        } else {
            return giverEmails.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AddGiverTableViewCell
        
        if addButtonRowSelected == indexPath.row {
            cell.addButton.enabled = false
        } else {
            cell.addButton.enabled = true
        }
        
        if showSearchResults {
            cell.giverNameLabel.text = giverEmailsNames[filteredGiverEmails[indexPath.row]]
            cell.giverEmailLabel.text = filteredGiverEmails[indexPath.row]
        } else {
            cell.giverNameLabel.text = giverEmailsNames[giverEmails[indexPath.row]]
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
