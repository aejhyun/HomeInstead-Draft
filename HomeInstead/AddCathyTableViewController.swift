//
//  AddCathyTableViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 1/12/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class AddCathyTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {

    var searchController: UISearchController!
    var cathyNames = [String]()
    var cathyEmails = [String]()
    var addedCathyNames:[String] = [String]()
    var addedCathyEmails: [String] = [String]()
    var cathyNamesEmails = [String: String]()
    var cathyEmailsNames = [String: String]()
    var cathyEmailsObjectIds = [String: String]()
    var searchCathyNamesEmails = [String]()
    var filteredCathyEmails = [String]()
    var filteredSearchCathyNamesEmails = [String]()
    var showSearchResults = false
    var addButtonRowSelected = -1
    var passedClientName = ""
    var passedGiverName: String = ""
    var passedGiverId: String = ""
    var passedGiverEmail: String = ""
    
    func configureSearchBar() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a cathy :)"
        searchController.searchBar.sizeToFit()
        searchController.loadView()
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()

        let query = PFQuery(className: "CathyList")
        query.whereKey("alreadyAddedByOffice", equalTo: false)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) objects.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        let cathyName = object.objectForKey("cathyName") as! String
                        let cathyEmail = object.objectForKey("cathyEmail") as! String
                        self.cathyNames.append(cathyName)
                        self.cathyEmails.append(cathyEmail)
                        self.cathyNamesEmails[cathyName] = cathyEmail
                        self.cathyEmailsNames[cathyEmail] = cathyName
                        self.cathyEmailsObjectIds[cathyEmail] = object.objectId
                        self.searchCathyNamesEmails.append(cathyName)
                        self.searchCathyNamesEmails.append(cathyEmail)
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
        let addCathyTableViewCell = superView.superview as! AddCathyTableViewCell
        let indexPath = tableView.indexPathForCell(addCathyTableViewCell)
        addButtonRowSelected = (indexPath?.row)!
        self.tableView.reloadData()
            
        var selectedCathyEmail = ""
        
        if showSearchResults {
            selectedCathyEmail = filteredCathyEmails[addButtonRowSelected]
            self.addedCathyNames.append(self.cathyEmailsNames[selectedCathyEmail]!)
            self.addedCathyEmails.append(selectedCathyEmail)
        } else {
            selectedCathyEmail = cathyEmails[addButtonRowSelected]
            self.addedCathyNames.append(self.cathyEmailsNames[selectedCathyEmail]!)
            self.addedCathyEmails.append(selectedCathyEmail)
        }
        
        let query = PFQuery(className:"CathyList")
        query.getObjectInBackgroundWithId(cathyEmailsObjectIds[selectedCathyEmail]!) {
            (cathyList: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error?.description)
            } else if let cathyList = cathyList {
                cathyList["alreadyAddedByOffice"] = false
                cathyList["officeId"] = PFUser.currentUser()?.objectId
                cathyList["officeName"] = PFUser.currentUser()?.objectForKey("fullName")
                cathyList["officeEmail"] = PFUser.currentUser()?.objectForKey("email")
                cathyList["clientName"] = self.passedClientName
                cathyList["giverName"] = self.passedGiverName
                cathyList["giverId"] = self.passedGiverId
                cathyList["giverEmail"] = self.passedGiverEmail
                cathyList.pinInBackground()
                cathyList.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        //this removing of element is for the user to see it dissappear. It's mainly for look because filteredGiverEmails will be loaded with new emails every single time the search is used.
                        self.filteredCathyEmails = self.filteredCathyEmails.filter {$0 != selectedCathyEmail}
                        self.cathyEmails = self.cathyEmails.filter {$0 != selectedCathyEmail}
                        self.cathyNames = self.cathyNames.filter {$0 != self.cathyEmailsNames[selectedCathyEmail]}
                        self.searchCathyNamesEmails = self.cathyEmails
                        self.searchCathyNamesEmails += self.cathyNames
                        //after the user adds a giver, the searchGiverNamesEmails gets smaller with self.filteredGiverEmails = self.filteredGiverEmails.filter {$0 != selectedGiverEmail}. So instead of using searchGiverNamesEmails which is the old string that was retrived from view did load, I "refresh it with the newest set of emails and givernames that should be displayed to the user. Remember searchGiverNamesEmails needs to have both the emails and the names for it to work because I cannot call updateSearchResultsForSearchController for both email and name. I had to put it into one array.
                        self.addButtonRowSelected = -1
                        self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Automatic)
                    } else {
                        print(error?.description)
                    }
                }
            }
        }
        
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        showSearchResults = true
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

        filteredCathyEmails.removeAll()
        let searchString = searchController.searchBar.text
        filteredSearchCathyNamesEmails = searchCathyNamesEmails.filter({ (cathyNameEmail) -> Bool in
            let cathyNameEmailText: NSString = cathyNameEmail
            return (cathyNameEmailText.rangeOfString(searchString!, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
        
        //With the following code, I get the filteredSearchGiverNamesEmails array that has both the giver names and emails and translate it into unique emails. So if the user types "a", and both the giver's email and name has the letter "a", it will then appened to filteredGiverEmails one email for both the name and the email. And by using the dictionary of giverEmailsNames, I can translate this unique email into the giver's name. The reason for this is in the case of givers having the same name but obviously different emails.
        for var filteredSearchCathyNameEmail in filteredSearchCathyNamesEmails {
            if filteredSearchCathyNameEmail.rangeOfString("@") == nil {
                filteredSearchCathyNameEmail = cathyNamesEmails[filteredSearchCathyNameEmail]!
            }
            if filteredCathyEmails.contains(filteredSearchCathyNameEmail) == false {
                filteredCathyEmails.append(filteredSearchCathyNameEmail)
            }
        }
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if showSearchResults {
            return filteredCathyEmails.count
        } else {
            return cathyEmails.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! AddCathyTableViewCell
        
        if addButtonRowSelected == indexPath.row {
            cell.addButton.enabled = false
        } else {
            cell.addButton.enabled = true
        }
        
        if showSearchResults {
            cell.cathyNameLabel.text = cathyEmailsNames[filteredCathyEmails[indexPath.row]]
            cell.cathyEmailLabel.text = filteredCathyEmails[indexPath.row]
        } else {
            cell.cathyNameLabel.text = cathyEmailsNames[cathyEmails[indexPath.row]]
            cell.cathyEmailLabel.text = cathyEmails[indexPath.row]
        }
        
        return cell
    }

    @IBAction func doneButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }


}
