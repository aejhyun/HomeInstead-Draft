//
//  OfficeAddClientAndCathyViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 3/14/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class OfficeAddClientAndCathyViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    var drewTextFieldWithOnlyBottomLine: Bool = false
    var number = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setScrollView()
        self.addLeftPaddingToTextField(self.firstNameTextField)
        self.addLeftPaddingToTextField(self.lastNameTextField)
        
    }
    
    override func viewDidLayoutSubviews() {
        
        //The reason for self.drewTextFieldWithOnlyBottomLine Bool check is because the "viewDidLayoutSubviews()" is being called twice. The reason for this, I hypothesize is because these UITextField(s) are laid "on top" of the UIScrollView, which is laid "on top" of a UIView. So this function  is called when the UIView loads and then another time when UIScrollView loads.
        if self.drewTextFieldWithOnlyBottomLine {
            self.drawTextFieldWithOnlyBottomLine(self.firstNameTextField)
            self.drawTextFieldWithOnlyBottomLine(self.lastNameTextField)
        }
        self.drewTextFieldWithOnlyBottomLine = true
        
        
    }
    
    func textViewDidChange(textView: UITextView) {
        
        let textViewWidth: CGFloat = self.notesTextView.frame.size.width
        let newSize: CGSize = self.notesTextView.sizeThatFits(CGSizeMake(textViewWidth, CGFloat(MAXFLOAT)))
        var newFrame: CGRect = self.notesTextView.frame
        newFrame.size = CGSizeMake(fmax(newSize.width, textViewWidth), newSize.height)
        newFrame.offsetInPlace(dx: 0.0, dy: 0.0)
        self.notesTextView.frame = newFrame
       
    }
    
    
    func drawTextFieldWithOnlyBottomLine(textField: UITextField!) {
      
        let border = CALayer()
        let width = CGFloat(0.8)
        border.borderColor = UIColor.lightGrayColor().CGColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width: textField.frame.size.width, height: width)
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
        
    }
    
    func addLeftPaddingToTextField(textField: UITextField!) {
        
        let paddingView = UIView(frame: CGRect(x: 0.0, y: 10.0, width: 10.0, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .Always
        
    }
    
    func setScrollView() {
        
        self.scrollView.contentSize.width = self.view.bounds.width
        self.scrollView.contentSize.height = self.view.bounds.height
        self.automaticallyAdjustsScrollViewInsets = false
        
    }
    

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
}
