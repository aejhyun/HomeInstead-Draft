//
//  CathyImageViewerViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 3/3/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class CathyImageViewerViewController: UIViewController, UIScrollViewDelegate {

    var image: UIImage!
    var imageView: UIImageView!
    var scrollView: UIScrollView!
    var panGestureRecognizer: UIPanGestureRecognizer!
    var longPressGestureRecognizer: UILongPressGestureRecognizer!
    var cancelButton: UIButton!
    var cancelButtonImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        self.scrollView = UIScrollView(frame: self.view.frame)
        self.scrollView.maximumZoomScale = 3.0
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.zoomScale = 1.0
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
        
        let tapOnce = UITapGestureRecognizer(target: self, action: "tapOnce:")
        let tapTwice = UITapGestureRecognizer(target: self, action: "tapTwice:")
        self.longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("longPress:"))
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("moveImage:"))
        
        tapOnce.numberOfTapsRequired = 1
        tapTwice.numberOfTapsRequired = 2
        tapOnce.requireGestureRecognizerToFail(tapTwice)
        
        self.scrollView.addGestureRecognizer(tapOnce)
        self.scrollView.addGestureRecognizer(tapTwice)
        self.scrollView.addGestureRecognizer(self.longPressGestureRecognizer)
        self.scrollView.addGestureRecognizer(self.panGestureRecognizer)
        
        setCancelButton()
        centerPicture()
        
    }
    
    func setCancelButton() {
        self.cancelButtonImage = UIImage(named: "cancelButtonImage")
        self.cancelButton = UIButton(type: UIButtonType.RoundedRect)
        self.cancelButton.addTarget(self, action: Selector("cancelButtonTapped:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.cancelButton.setImage(self.cancelButtonImage, forState: UIControlState.Normal)
        self.cancelButton.tintColor = UIColor.whiteColor()
        self.cancelButton.frame = CGRectMake(self.view.frame.size.width - (self.cancelButtonImage.size.width * 2) - 18, 18, self.cancelButtonImage.size.width * 2, self.cancelButtonImage.size.height * 2)
        self.view.addSubview(self.cancelButton)
        
    }
    
    func cancelButtonTapped(sender: UIButton) {
        
        self.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func centerPicture() {
        
        self.imageView = UIImageView()
        self.imageView.clipsToBounds = true
        self.imageView.image = self.image
        self.scrollView.addSubview(self.imageView)

        let imageWidth = self.image.size.width;
        let imageHeight = self.image.size.height;
        let imageRatio = imageWidth/imageHeight;
        let viewRatio = self.view.frame.size.width / self.view.frame.size.height
        let ratio: CGFloat
        if imageRatio >= viewRatio {
            ratio = imageWidth / self.view.frame.size.width
        }
        else {
            ratio = imageHeight / self.view.frame.size.height
        }
        let newWidth = imageWidth / ratio
        let newHeight = imageHeight / ratio
        self.imageView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y, newWidth, newHeight)
        self.imageView.center = self.scrollView.center
        self.imageView.layer.cornerRadius = 0.0
        self.view.backgroundColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)

    }
    
    func moveImage(gesture: UIPanGestureRecognizer) {
        
        if self.cancelButton.hidden == false {
            UIView.animateWithDuration(0.5, animations: {() -> Void in
                self.cancelButton.alpha = 0.0
                //self.cancelButton.hidden = true
            })
        }
        
        let deltaY: CGFloat = gesture.translationInView(self.scrollView).y
        let translatedPoint: CGPoint = CGPointMake(self.view.center.x, self.view.center.y + deltaY)
        self.scrollView.center = translatedPoint
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            let velocityY: CGFloat = gesture.velocityInView(self.scrollView).y
            let maxDeltaY: CGFloat = (self.view.frame.size.height - self.imageView.frame.size.height) / 2
            if velocityY > 700 || (abs(deltaY) > maxDeltaY && deltaY > 0) {
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.view.frame.size.height, self.imageView.frame.size.width, self.imageView.frame.size.height)
                    self.view.alpha = 0
                    }, completion: { (finished: Bool) -> Void in
                        self.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                        self.dismissViewControllerAnimated(true, completion: nil)
                })
                
            } else if velocityY < -700 || (abs(deltaY)) > maxDeltaY && deltaY < 0 {
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, -self.view.frame.size.height, self.imageView.frame.size.width, self.imageView.frame.size.height)
                    self.view.alpha = 0
                    }, completion: { (finished: Bool) -> Void in
                        self.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                        self.dismissViewControllerAnimated(true, completion: nil)
                })
                
            } else {
                
                UIView.animateWithDuration(0.3, animations: {() -> Void in
                    self.cancelButton.alpha = 1.0
                    self.cancelButton.hidden = false
                    self.scrollView.center = self.view.center
                })
                
            }
            
        }
        
    }
    
    func tapOnce(gestureRecognizer: UIGestureRecognizer) {
        
        let alertController = UIAlertController(title: "Save Image", message: "Would you like to save this picture to your camera roll?", preferredStyle: UIAlertControllerStyle.Alert)
        var alertAction = UIAlertAction(title: "Save", style: .Default, handler: { (alertAction: UIAlertAction) -> Void in
            
            UIImageWriteToSavedPhotosAlbum(self.image, self, "image:didFinishSavingWithError:contextInfo:", nil)
            
        })
        alertController.addAction(alertAction)
        alertAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alertController.addAction(alertAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            let alertController = UIAlertController(title: "Saved :)", message: "Your image has been saved to your photos.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func tapTwice(gestureRecognizer: UIGestureRecognizer) {
        
        if self.scrollView.zoomScale == self.scrollView.minimumZoomScale {
            let zoomRect = self.zoomRectForScale(self.scrollView.maximumZoomScale, withCenter: gestureRecognizer.locationInView(gestureRecognizer.view!))
            self.scrollView.zoomToRect(zoomRect, animated: true)
        } else {
            self.scrollView.setZoomScale(self.scrollView.minimumZoomScale, animated: true)
        }
        
    }
    
    func zoomRectForScale(scale: CGFloat, withCenter center: CGPoint) -> CGRect {
        
        var zoomRect: CGRect = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        zoomRect.size.height = self.imageView.frame.size.height / scale
        zoomRect.size.width = self.imageView.frame.size.width / scale
        let center = self.imageView.convertPoint(center, fromView: self.view!)
        zoomRect.origin.x = center.x - ((zoomRect.size.width / 2.0))
        zoomRect.origin.y = center.y - ((zoomRect.size.height / 2.0))
        return zoomRect
        
    }
    
    func centerScrollViewContents() {
        
        let boundsSize = scrollView.bounds.size
        var imageFrame = imageView.frame
        
        if imageFrame.size.width < boundsSize.width {
            imageFrame.origin.x = (boundsSize.width - imageFrame.size.width) / 2.0
        } else {
            imageFrame.origin.x = 0.0
        }
        
        if imageFrame.size.height < boundsSize.height {
            imageFrame.origin.y = (boundsSize.height - imageFrame.size.height) / 2.0
        } else {
            imageFrame.origin.y = 0.0
        }
        
        imageView.frame = imageFrame
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return imageView
        
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        centerScrollViewContents()
        
        if self.scrollView.zoomScale == self.scrollView.minimumZoomScale {
            if self.cancelButton.hidden == true {
                UIView.animateWithDuration(0.5, animations: {() -> Void in
                    self.cancelButton.alpha = 1.0
                    self.cancelButton.hidden = false
                })
            }
            self.scrollView.addGestureRecognizer(self.panGestureRecognizer)
        }
        else {
            if self.cancelButton.hidden == false {
                UIView.animateWithDuration(0.5, animations: {() -> Void in
                    self.cancelButton.alpha = 0.0
                    }, completion: {(finished: Bool) -> Void in
                        self.cancelButton.hidden = true
                })
                self.scrollView.removeGestureRecognizer(self.panGestureRecognizer)
                
            }
        }
        
    }
    
    func longPress(gesture: UILongPressGestureRecognizer) {
        
        //Copy and paste functionality here.
        
    }

}
