//
//  CathyTaskLogMessageViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 1/13/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class CathyTaskLogMessageViewController: UIViewController {

    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var messageTextView: UITextView!
    var passedMessage: String = ""
    var defaultPictureButton: UIButton = UIButton(type: UIButtonType.Custom) as UIButton
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        messageTextView.layer.cornerRadius = 10
//        messageTextView.editable = false
//        messageTextView.text = passedMessage

        
        defaultPictureButton = UIButton(type: UIButtonType.Custom) as UIButton
        defaultPictureButton.frame = CGRectMake(100, 100, 40, 40)
        defaultPictureButton.addTarget(self, action: "defaultPictureButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        defaultPictureButton.setImage(UIImage(named: "defaultPicture"), forState: UIControlState.Normal)
        defaultPictureButton.layer.cornerRadius = 20.0
        defaultPictureButton.clipsToBounds = true
        defaultPictureButton.exclusiveTouch = true
        self.view.addSubview(defaultPictureButton)
        
    }
    
    func defaultPictureButtonTapped(sender: UIButton) {
        
        let imageViewerViewController = ImageViewerViewController()
        self.addChildViewController(imageViewerViewController)
        imageViewerViewController.image = self.defaultPictureButton.imageView!.image
        imageViewerViewController.cancelButtonImage = UIImage(named: "cancelButtonImage")
        imageViewerViewController.disableSavingImage = false
        self.view.addSubview(imageViewerViewController.view)
        imageViewerViewController.centerPictureFromPoint(self.defaultPictureButton.frame.origin, ofSize: self.defaultPictureButton.frame.size, withCornerRadius: self.defaultPictureButton.layer.cornerRadius)
        self.didMoveToParentViewController(self)
        
        
//        self.presentViewController(imageViewerViewController, animated: true, completion: nil)
        
        
        
        
        
//        
//        
//        
//
//        let aKImageViewerViewController = AKImageViewerViewController()
//        aKImageViewerViewController.image = self.defaultPictureButton.imageView!.image
//        aKImageViewerViewController.imgCancel = UIImage(named: "cancelButtonImage")
//        aKImageViewerViewController.disableSavingImage = true
//        self.view.addSubview(aKImageViewerViewController.view)
//        aKImageViewerViewController.centerPictureFromPoint(self.defaultPictureButton.frame.origin, ofSize: self.defaultPictureButton.frame.size, withCornerRadius: 20.0)
//
    }
    
    @IBAction func buttonTapped(sender: AnyObject) {
        
//        let defaultPicture = UIImage(named: "defaultPicture")
//        let imageView = UIImageView(image: defaultPicture)
//        let aKImageViewerViewController = AKImageViewerViewController()
//        aKImageViewerViewController.image = UIImage(named: "defaultPicture")
//        aKImageViewerViewController.imgCancel = UIImage(named: "cancelButton")
//        self.view.addSubview(aKImageViewerViewController.view)
//        aKImageViewerViewController.centerPictureFromPoint(imageView.frame.origin, ofSize: imageView.frame.size, withCornerRadius: 1.0)
        
        

    }

   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
