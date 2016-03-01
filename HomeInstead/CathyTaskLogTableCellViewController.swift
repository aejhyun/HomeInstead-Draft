//
//  CathyTaskLogTableViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 12/24/15.
//  Copyright © 2015 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class CathyTaskLogTableViewController: UITableViewController {
    
    var tasks = [String]()
    var dates = [String]()
    var times = [String]()
    var addresses = [String]()
    var messages = [String]()
    var pictures = [UIImage?]()
    var pictureFiles = [PFFile?]()
    var pictureMessages = [String]()
    var giverNames = [String]()
    var messageButtonRowSelected: Int? = nil
    var selectedIndexPath: NSIndexPath? = nil
    var flags = [Bool](count: 40, repeatedValue: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        
        let query = PFQuery(className:"TaskInformation")
        query.whereKey("cathyId", equalTo: (PFUser.currentUser()?.objectId)!)
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        self.pictures.append(nil)
                        self.giverNames.append(object.objectForKey("giverName") as! String)
                        self.tasks.append(object.objectForKey("task") as! String)
                        self.dates.append(object.objectForKey("date") as! String)
                        self.times.append(object.objectForKey("time") as! String)
                        self.addresses.append(object.objectForKey("address") as! String)
                        self.messages.append(object.objectForKey("message") as! String)
                        self.pictureMessages.append(object.objectForKey("pictureMessage") as! String)
                        if object.objectForKey("pictureFile") != nil {
                            self.pictureFiles.append(object.objectForKey("pictureFile") as? PFFile)
                        } else {
                            self.pictureFiles.append(nil)
                        }
                        object.pinInBackground()
                    }
                    self.tasks = self.tasks.reverse()
                    self.dates = self.dates.reverse()
                    self.times = self.times.reverse()
                    self.addresses = self.addresses.reverse()
                    self.messages = self.messages.reverse()
                    self.pictureMessages = self.pictureMessages.reverse()
                    self.pictureFiles = self.pictureFiles.reverse()
                    
                    self.getImagesFromPictureFiles({ (imageIndex) -> Void in
                        if imageIndex == self.pictures.count - 1 {
                            self.tableView.reloadData()
                        }
                    })
                    
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }

    
    override func childViewControllerForStatusBarHidden() -> UIViewController? {
        
        print("yo")
        return ImageViewerViewController()
        
    }
    
    func getImagesFromPictureFiles(completion: (imageIndex: Int) -> Void) {
        
        for index in 0...pictureFiles.count - 1 {
            
            if pictureFiles[index] != nil {
                pictureFiles[index]?.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        let image = UIImage(data:imageData!)
                        self.pictures[index] = image
                        completion(imageIndex: index)
                    } else {
                        print(error?.description)
                    }
                })
            }
            
        }
        
    }



    @IBAction func messageButtonTapped(sender: AnyObject) {
        print(self.pictureFiles)
//        let messageButton = sender as! UIButton
//        let superView = messageButton.superview!
//        let cathyTaskLogOneTableViewCell = superView.superview as! CathyTaskLogOneTableViewCell
//        let indexPath = tableView.indexPathForCell(cathyTaskLogOneTableViewCell)!
//        messageButtonRowSelected = indexPath.row
        
    }
    
    func cropToSquare(image originalImage: UIImage) -> UIImage {
        
        let contextImage: UIImage = UIImage(CGImage: originalImage.CGImage!)
        let contextImageSize: CGSize = contextImage.size
        let positionX: CGFloat
        let positionY: CGFloat
        let width: CGFloat
        let height: CGFloat
        
        if contextImageSize.width > contextImageSize.height {
            positionX = ((contextImageSize.width - contextImageSize.height) / 2)
            positionY = 0
            width = contextImageSize.height
            height = contextImageSize.height
        } else {
            positionX = 0
            positionY = ((contextImageSize.height - contextImageSize.width) / 2)
            width = contextImageSize.width
            height = contextImageSize.width
        }
        let rect: CGRect = CGRectMake(positionX, positionY, width, height)
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)!
        let image: UIImage = UIImage(CGImage: imageRef, scale: originalImage.scale, orientation: originalImage.imageOrientation)
        
        return image
        
    }
    
    func cellOne(indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellOne", forIndexPath: indexPath) as! CathyTaskLogOneTableViewCell
        cell.taskLabel.text = tasks[indexPath.row]
        cell.dateLabel.text = dates[indexPath.row]
        cell.timeLabel.text = times[indexPath.row]
        cell.locationLabel.text = addresses[indexPath.row]
        cell.messageLabel.text = messages[indexPath.row]
        
        
        return cell
        
    }
    
    func cellTwo(indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellTwo", forIndexPath: indexPath) as! CathyTaskLogTwoTableViewCell
        
        let cGPoint = CGPoint(x: 0.0, y: 0.0)
        let cGSize = CGSize(width: 100.0, height: 100.0)
        let cGRect = CGRect(origin: cGPoint, size: cGSize)
        let bezierPath = UIBezierPath(rect: cGRect)
        cell.pictureMessageTextView.textContainer.exclusionPaths = [bezierPath]
        
        cell.taskLabel.text = tasks[indexPath.row]
        cell.dateLabel.text = dates[indexPath.row]
        cell.timeLabel.text = times[indexPath.row]
        cell.locationLabel.text = addresses[indexPath.row]
        cell.pictureMessageTextView.text = pictureMessages[indexPath.row]
        cell.pictureMessageTextView.textColor = UIColor.lightGrayColor()
        cell.pictureMessageTextView.font = UIFont.systemFontOfSize(13.0)
        cell.pictureImageView.image = cropToSquare(image: pictures[indexPath.row]!)
        cell.pictureImageView.contentMode = .ScaleAspectFill
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("pictureTapped:"))
        cell.pictureImageView.addGestureRecognizer(tapRecognizer)
        
        return cell
        
    }

    
    func pictureTapped(gestureRecognizer: UITapGestureRecognizer) {

        let tappedLocation = gestureRecognizer.locationInView(self.tableView)
        if let tappedIndexPath = tableView.indexPathForRowAtPoint(tappedLocation) {
            
        
        
            
            let pointTapped: CGPoint = CGPoint(x: tappedLocation.x, y: tappedLocation.y)
            let size: CGSize = CGSize(width: 0, height: 0)
            
            let pictureTapped: UIImage = pictures[tappedIndexPath.row]!
            let imageViewerViewController = ImageViewerViewController()
            self.addChildViewController(imageViewerViewController)
            
            imageViewerViewController.image = self.pictures[tappedIndexPath.row]
            
            imageViewerViewController.cancelButtonImage = UIImage(named: "cancelButtonImage")
            imageViewerViewController.disableSavingImage = false
            self.view.addSubview(imageViewerViewController.view)
            
 
            imageViewerViewController.centerPictureFromPoint(pointTapped, ofSize: size, withCornerRadius: 0)
            self.navigationController?.navigationBarHidden = false
            self.didMoveToParentViewController(self)
            

        }

 
        
        
        //imageViewerViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        //self.presentViewController(imageViewerViewController, animated: false, completion: nil)
        
        
        
        
        
        
        
        
        //        let messageButton = sender as! UIButton
        //        let superView = messageButton.superview!
        //        let cathyTaskLogOneTableViewCell = superView.superview as! CathyTaskLogOneTableViewCell
        //        let indexPath = tableView.indexPathForCell(cathyTaskLogOneTableViewCell)!
        //        messageButtonRowSelected = indexPath.row
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCellWithIdentifier("cellTwo", forIndexPath: indexPath) as! CathyTaskLogTwoTableViewCell
//        
//        return cell
        

        
        if pictures[indexPath.row] == nil {
            return cellOne(indexPath)
        } else {
            return cellTwo(indexPath)
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cathyTaskLogMessageViewController = segue.destinationViewController as! CathyTaskLogMessageViewController
        if messageButtonRowSelected != nil {
            cathyTaskLogMessageViewController.passedMessage = messages[messageButtonRowSelected!]
        }
        
    }
    
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {
    
    }

    @IBAction func signOutButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        PFUser.logOut()
    }
    

}

//    func cellWithoutMessage(indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("cellOne", forIndexPath: indexPath) as! CathyTaskLogOneTableViewCell
//        cell.taskLabel.text = tasks[indexPath.row]
//        cell.dateLabel.text = dates[indexPath.row]
//        cell.timeLabel.text = times[indexPath.row]
//        cell.locationLabel.text = addresses[indexPath.row]
//        cell.messageLabel.text = messages[indexPath.row]
//        return cell
//    }
//
//    func cellWithMessage(indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("cellTwo", forIndexPath: indexPath) as! CathyTaskLogTwoTableViewCell
//        cell.taskLabel.text = tasks[indexPath.row]
//        cell.dateLabel.text = dates[indexPath.row]
//        cell.timeLabel.text = times[indexPath.row]
//        cell.locationLabel.text = addresses[indexPath.row]
//        cell.messageLabel.text = messages[indexPath.row]
//        return cell
//    }

//        getImageFromFile(pictureFiles[indexPath.row]!, indexPath: indexPath) { (imageFromFile) -> UITableViewCell in
//            if imageFromFile == nil {
//                cell.pictureImageView.image = UIImage(named: "defaultPicture")!
//                return cell
//            } else {
//                cell.pictureImageView.image = imageFromFile
//                return cell
//            }
//        }



//        let pictureFile = pictureFiles[indexPath.row]
//        pictureFile!.getDataInBackgroundWithBlock({ (imageData: NSData?, error:NSError?) -> Void in
//            if error == nil {
//                let image = UIImage(data:imageData!)
//                cell.pictureImageView.image = image
//
//            } else {
//                print(error?.description)
//                return cell
//            }
//        })


//        let pictureImageView = UIImageView()
//        pictureImageView.contentMode = .ScaleAspectFill
//        pictureImageView.frame.size.width = 100
//        pictureImageView.frame.size.height = 100
//
//        pictureImageView.image = pictures[indexPath.row]
//        print(pictureImageView.image!.size.height)
//        print(pictureImageView.image!.size.width)
//        let desiredPictureHeight = pictureImageView.image!.size.height
//        let desiredPictureWidth = pictureImageView.image!.size.width
//
//        pictureImageView.frame.size.width = 100
//        pictureImageView.frame.size.height = 100
//
//
//



//        cell.pictureImageView.addSubview(pictureImageView)
//
//
//        pictureImageView.tag = indexPath.row

//        for subview in cell.pictureMessageTextView.subviews {
//            print("PSDIFJPSIDFJPSIDJFPJ \(subview)")
//            print(cell.pictureMessageTextView.textContainer)
//            if subview != pictureImageView {
//                if subview != cell.pictureMessageTextView.textContainer {
//                    subview.removeFromSuperview()
//                }
//
//            }
//        }
//


//func cellThree(indexPath: NSIndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCellWithIdentifier("cellThree", forIndexPath: indexPath) as! CathyTaskLogThreeTableViewCell
//    
//    let cGPoint = CGPoint(x: 0.0, y: 0.0)
//    let cGSize = CGSize(width: 100.0, height: 100.0)
//    let cGRect = CGRect(origin: cGPoint, size: cGSize)
//    let bezierPath = UIBezierPath(rect: cGRect)
//    cell.pictureMessageTextView.textContainer.exclusionPaths = [bezierPath]
//    
//    cell.taskLabel.text = tasks[indexPath.row]
//    cell.dateLabel.text = dates[indexPath.row]
//    cell.timeLabel.text = times[indexPath.row]
//    cell.locationLabel.text = addresses[indexPath.row]
//    cell.pictureMessageTextView.text = pictureMessages[indexPath.row]
//    cell.pictureMessageTextView.textColor = UIColor.lightGrayColor()
//    cell.pictureMessageTextView.font = UIFont.systemFontOfSize(13.0)
//    
//    let pictureImageView = UIImageView()
//    pictureImageView.contentMode = .ScaleAspectFill
//    pictureImageView.frame.size.width = 100
//    pictureImageView.frame.size.height = 100
//    pictureImageView.tag = indexPath.row
//    
//    pictureImageView.image = pictures[indexPath.row]
//    print(pictureImageView.viewWithTag(indexPath.row))
//    print(pictureImageView.image!.size.height)
//    print(pictures[indexPath.row])
//    
//    if pictureImageView.viewWithTag(indexPath.row) == pictures[indexPath.row] {
//        
//    }
//    
//    for subview in cell.pictureMessageTextView.subviews {
//        if subview is UIImageView {
//            if subview != pictures[indexPath.row] {
//                subview.removeFromSuperview()
//            }
//        }
//    }
//    
//    
//    
//    
//    cell.pictureMessageTextView.addSubview(pictureImageView)
//    
//    
//    
//    
//    
//    return cell
//}

