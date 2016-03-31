//
//  OfficeClientProfileViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 3/28/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class OfficeClientProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ClientInformationDelegate {
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var noPhotoLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightLayoutConstraint: NSLayoutConstraint!
    
    var firstName: String!
    var lastName: String!
    var notes: String!
    var image: UIImage!
    var cathyNames: [String] = [String]()
    var cathyEmails: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.automaticallyAdjustsScrollViewInsets = false
        self.adjustTableViewHeight()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.firstNameLabel.text = self.firstName
        self.lastNameLabel.text = self.lastName
        self.notesTextView.text = self.notes
        self.setImageView()
        
        if self.notes.isEmpty {
            self.notesTextView.text = "None."
        }
        
        self.adjustTableViewHeight()
        self.tableView.reloadData()
        
    }
    
    func setImageView() {
        
        //The reason for self.imageViewHeightLayoutConstraint is because the imageView's correct height only became available in viewWillDidLoad(). But if I put the setImageView() inside viewWillDidLoad(), you can see the imageView circle being drawn.
        self.imageView.layer.masksToBounds = false
        self.imageView.layer.cornerRadius = self.imageViewHeightLayoutConstraint.constant / 2
        self.imageView.clipsToBounds = true
        if let image = self.image {
            self.imageView.image = image
            self.noPhotoLabel.hidden = true
            self.imageView.layer.borderWidth = 0.0
        } else {
            self.imageView.layer.borderWidth = 1.0
            self.imageView.layer.borderColor = UIColor.lightGrayColor().CGColor
            self.noPhotoLabel.textAlignment = .Center
        }
        
    }
    
    func adjustTableViewHeight() {
        
        //The 45 is the original height of self.tableView.contentSize. If the row height is changed in the XIB, then the 45 should also be changed to whatever number it is changed in the XIB.
        let height:CGFloat = 45 * CGFloat(self.cathyNames.count)
        var frame:CGRect = self.tableView.frame
        frame.size.height = height
        self.tableView.frame = frame
        self.tableViewHeightLayoutConstraint.constant = height
        
    }
    
//TableView functions start here.
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cathyNames.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! OfficeAddCathyTableViewCell
        
        cell.cathyNameLabel.text = self.cathyNames[indexPath.row]
        cell.cathyEmailLabel.text = self.cathyEmails[indexPath.row]
   
        return cell
        
    }
    
//TableView functions end here.
//Segue functions start here.
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let navigationController = segue.destinationViewController as? UINavigationController {
            if let officeCreateClientProfileViewController = navigationController.viewControllers[0] as? OfficeCreateClientProfileViewController {
                
                    officeCreateClientProfileViewController.isInEditingMode = true
                    officeCreateClientProfileViewController.firstName = self.firstName
                    officeCreateClientProfileViewController.lastName = self.lastName
                    officeCreateClientProfileViewController.notes = self.notes
                    officeCreateClientProfileViewController.image = self.image
                    officeCreateClientProfileViewController.cathyNames = self.cathyNames
                    officeCreateClientProfileViewController.cathyEmails = self.cathyEmails
                    officeCreateClientProfileViewController.clientInformationDelegate = self
                
            } else {
                print("officeCreateClientProfileViewController")
            }
        } else {
            print("navigationController is nil")
        }

    }
    
//Segue functions end here.
    
    func getClientFirstName(firstName: String) {
        self.firstName = firstName
    }
    
    func getClientLastName(lastName: String) {
        self.lastName = lastName
    }
    
    func getClientNotes(notes: String) {
        self.notes = notes
    }
    
    func getClientImage(image: UIImage?) {
        self.image = image
    }
    
    func getCathyNames(names: [String]) {
        self.cathyNames = names
    }
    
    func getCathyEmails(emails: [String]) {
        self.cathyEmails = emails
        
    }
    
}
