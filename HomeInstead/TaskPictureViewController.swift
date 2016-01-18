//
//  TaskPictureViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 1/2/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class TaskPictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var pictureMessageTextView: UITextView!
    
    var pictureMessage = [String](count: 30, repeatedValue: "")
    var picture = [UIImage](count: 30, repeatedValue: UIImage(named: "defaultPicture")!)
    var pictureButtonRowSelected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pictureMessageTextView.layer.cornerRadius = 10
        pictureImageView.layer.cornerRadius = 10
        pictureMessageTextView.becomeFirstResponder()
        pictureMessageTextView.text = pictureMessage[pictureButtonRowSelected]
        pictureImageView.image = picture[pictureButtonRowSelected]
        
    
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.view.endEditing(true);
        
    }
    
    @IBAction func defaultButtonTapped(sender: AnyObject) {
        
        pictureImageView.image = UIImage(named: "defaultPicture")!
        
    }
    
    @IBAction func selectImageFromPhotoLibraryButtonTapped(sender: UITapGestureRecognizer) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        pictureMessageTextView.becomeFirstResponder()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        pictureImageView.image = selectedImage
        dismissViewControllerAnimated(true, completion: nil)
        pictureMessageTextView.becomeFirstResponder()
        
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
