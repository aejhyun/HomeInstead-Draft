//
//  CathyTaskInformationTableViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 5/11/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class CathyTaskInformationTableViewController: UITableViewController {

    var taskInformationObjectId: String = ""
    
    var date: String = ""
    var startedTime: String = ""
    var finishedTime: String = ""
    var address: String = ""
    var clientName: String = ""
    var careGiverName: String = ""
    var clietName: String = ""
    var taskDescriptions: [String] = [String]()
    var taskComments: [String] = [String]()
    var timeTasksCompleted: [String] = [String]()
    
    var gotAllImages: Bool = false
    var images: [String: UIImage] = [String: UIImage]()
    var imageFiles: [String: PFFile] = [String: PFFile]()
    
    func attempQueryingTaskInformation(completion: (querySuccessful: Bool) -> Void) {
        
        let query = PFQuery(className: "TaskInformation")
        query.fromLocalDatastore()
        query.getObjectInBackgroundWithId(self.taskInformationObjectId) {
            (objects: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
                completion(querySuccessful: false)
            } else if let object = objects {
       
                self.date = object.objectForKey("date") as! String
                self.startedTime = object.objectForKey("startedTime") as! String
                self.finishedTime = object.objectForKey("finishedTime") as! String
                self.address = object.objectForKey("address") as! String
                self.clientName = object.objectForKey("clientName") as! String
                self.careGiverName = object.objectForKey("careGiverName") as! String
                self.taskDescriptions = object.objectForKey("taskDescriptions") as! [String]
                self.timeTasksCompleted = object.objectForKey("timeTasksCompleted") as! [String]
                self.taskComments = object.objectForKey("taskComments") as! [String]
                
                if let imageFiles = object.objectForKey("imageFiles") {
                    self.imageFiles = imageFiles as! [String: PFFile]
                    
                    var count: Int = 0
                    self.getImages({ (gotImage) -> Void in
                        if count == imageFiles.count - 1 {
                            self.gotAllImages = true
                            self.tableView.reloadData()
                        }
                        count++
                    })
                }
                
                completion(querySuccessful: true)
                
            }
        }
        
    }
    
    func getImages(completion: (gotImage: Bool) -> Void) {
        
        for (key, imageFile) in self.imageFiles {
            
            imageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                if error != nil {
                    print(error)
                } else {
                    let image = UIImage(data: imageData!)
                    self.images[key] = image
                    completion(gotImage: true)
                }
            })
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 140
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationItem.title = "Task Information"
        
        self.attempQueryingTaskInformation { (querySuccessful) -> Void in
            if querySuccessful {

                self.tableView.reloadData()
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
        return self.taskDescriptions.count + 1
    }

    func firstRowCell(indexPath: NSIndexPath) -> CathyTaskInformationFirstRowTableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellZero", forIndexPath: indexPath) as! CathyTaskInformationFirstRowTableViewCell
        
        cell.dateLabel.text = self.date
        cell.startedTimeLabel.text = self.startedTime
        cell.finishedTimeLabel.text = self.finishedTime
        cell.addressLabel.text = self.address
        cell.careGiverNameLabel.text = self.careGiverName
        cell.clientNameLabel.text = self.clientName
        
        return cell
    }
    
    func simpleCell(indexPath: NSIndexPath) -> CathyTaskInformationTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("simpleCell", forIndexPath: indexPath) as! CathyTaskInformationTableViewCell
        let indexPathRow = indexPath.row - 1
        
        cell.taskDescriptionLabel.text = self.taskDescriptions[indexPathRow]
                
        cell.timeTaskCompletedLabel.text = self.timeTasksCompleted[indexPathRow]
        
        return cell
    }
    
    func cellWithTaskComment(indexPath: NSIndexPath) -> CathyTaskInformationTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellWithTaskComment", forIndexPath: indexPath) as! CathyTaskInformationTableViewCell
        let indexPathRow = indexPath.row - 1
        
        cell.taskDescriptionLabel.text = self.taskDescriptions[indexPathRow]
        cell.taskCommentLabel.text = "                     \(self.taskComments[indexPathRow])"
        cell.timeTaskCompletedLabel.text = self.timeTasksCompleted[indexPathRow]
        
        return cell
    }
    
    func cellWithTaskImage(indexPath: NSIndexPath) -> CathyTaskInformationTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellWithTaskImage", forIndexPath: indexPath) as! CathyTaskInformationTableViewCell
        let indexPathRow = indexPath.row - 1
        
        cell.setTaskImageView()
        cell.setBezierPath()
        
        cell.taskDescriptionLabel.text = self.taskDescriptions[indexPathRow]
        cell.taskCommentTextView.text = "                     \(self.taskComments[indexPathRow])"
            
            //self.taskComments[indexPathRow]
        
        //cell.taskCommentLabel.text = "                     \(self.taskComments[indexPathRow])"
        cell.timeTaskCompletedLabel.text = self.timeTasksCompleted[indexPathRow]
        
        cell.taskImageView.image = self.images["\(indexPathRow)"]
        
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            return self.firstRowCell(indexPath)
        } else {
            if self.images["\(indexPath.row - 1)"] != nil {
                return cellWithTaskImage(indexPath)
            } else if self.taskComments[indexPath.row - 1] == "" {
                return simpleCell(indexPath)
            } else {
                return cellWithTaskComment(indexPath)
            }
        }

    }

}
