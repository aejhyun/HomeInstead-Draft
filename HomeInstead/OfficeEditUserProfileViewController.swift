//
//  OfficeEditUserProfileViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 4/12/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class OfficeEditUserProfileViewController: SignUpViewController, UITextViewDelegate {

    @IBOutlet weak var borderImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var gestureRecognizer: UIGestureRecognizer!
    var activeTextView: UITextView!
    
    func setScrollView() {
        
        self.scrollView.contentSize.width = self.view.bounds.width
        self.scrollView.contentSize.height = self.view.bounds.height
        self.scrollView.delegate = self
        
    }
    
    override func viewDidLoad() {
        
        self.addPhotoButton.titleLabel?.textAlignment = .Center
        self.editButton.hidden = true
        self.nameTextField.becomeFirstResponder()
        self.automaticallyAdjustsScrollViewInsets = false
        
        //self.setScrollView()
        
        self.gestureRecognizer = UITapGestureRecognizer(target: self, action: "textViewTapped:")
        self.textView.addGestureRecognizer(gestureRecognizer)
        self.textView.selectable = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)

       
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.textView.resignFirstResponder()
    }
    
    func textViewTapped(gestureRecognizer: UIGestureRecognizer) {
        self.textView.becomeFirstResponder()
        self.activeTextView = self.textView
        self.activeTextField = nil
    }
    
    func setScrollViewWhenKeyBoardDidShow(keyboardSize: CGRect) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        var aRect = self.view.frame
        aRect.size.height -= keyboardSize.size.height
        
    }
    
    override func keyboardDidShow(notification: NSNotification) {
        
        if let activeTextField = self.activeTextField, keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            
            self.setScrollViewWhenKeyBoardDidShow(keyboardSize)
            self.scrollView.scrollRectToVisible(activeTextField.frame, animated: true)
            
        } else if let activeTextView = self.activeTextView, keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
 
            self.setScrollViewWhenKeyBoardDidShow(keyboardSize)
            self.scrollView.scrollRectToVisible(activeTextView.frame, animated: true)
            
        }
        
    }
    

    
    
    
    
    


}
