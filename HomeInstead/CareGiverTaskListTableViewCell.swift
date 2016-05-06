//
//  CareGiverTaskListTableViewCell.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 5/5/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class CareGiverTaskListTableViewCell: UITableViewCell {

    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var optionsButtons: UIButton!
    
    
    @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var taskImageView: UIImageView!

    @IBOutlet weak var borderImageView: UIImageView!
    
    var numberOfTimesViewLaidOutSubviews: Int = 0
    
    func setTaskImageView() {
        
        self.taskImageView.image = nil
        self.taskImageView.alpha = 1.0
        self.taskImageView.layer.borderWidth = 1.0
        self.taskImageView.layer.masksToBounds = false
        self.taskImageView.layer.cornerRadius = self.imageViewHeightLayoutConstraint.constant / 2
        self.taskImageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.taskImageView.clipsToBounds = true
        
    }
    
    func setBorderImageView() {
        self.borderImageView.image = nil
        self.borderImageView.alpha = 0.0
        self.borderImageView.layer.borderWidth = 1.0
        self.borderImageView.layer.masksToBounds = false
        self.borderImageView.layer.cornerRadius = self.imageViewHeightLayoutConstraint.constant / 2
        self.borderImageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.borderImageView.clipsToBounds = true
    }
    
    func setCell() {
        
        self.textView.layer.borderWidth = 1.0
        self.textView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.textView.layer.cornerRadius = 5.0
        self.addPhotoButton.titleLabel?.textAlignment = .Center
        self.addPhotoButton.alpha = 1.0
        self.editButton.hidden = true
        self.editButton.alpha = 0.0
        
        
    }
    
    func deleteImageWithAnimation() {
        
        self.taskImageView.image = nil
        self.taskImageView.alpha = 1.0
        self.taskImageView.layer.borderWidth = 1.0
        self.borderImageView.alpha = 0.0
        self.addPhotoButton.hidden = false
        self.addPhotoButton.alpha = 1.0
        self.editButton.hidden = true
        self.editButton.alpha = 0.0
        
    }
    
    func setTaskImage(image: UIImage?) {
        
        if let image = image {
            self.taskImageView.image = image
            self.taskImageView.alpha = 1.0
            self.taskImageView.layer.borderWidth = 0.0
            self.borderImageView.alpha = 0.0
            self.addPhotoButton.hidden = true
            self.addPhotoButton.alpha = 0.0
            self.editButton.hidden = false
            self.editButton.alpha = 1.0

        } else {
            self.taskImageView.image = nil
            self.taskImageView.alpha = 1.0
            self.taskImageView.layer.borderWidth = 1.0
            self.borderImageView.alpha = 0.0
            self.addPhotoButton.hidden = false
            self.addPhotoButton.alpha = 1.0
            self.editButton.hidden = true
            self.editButton.alpha = 0.0
        }
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.numberOfTimesViewLaidOutSubviews == 0 {
            //The imageView set up is inside self.numberOfTimesViewLaidOutSubviews == 1 check because the code below will be called more than once. And the imageView set up is not in viewDidLoad() because, self.imageView.frame returned was the incorrect value. It returns the correct self.imageView.frame value either in the viewDidLayoutSubviews and viewWillAppear functions. But in the viewWillAppear function causes the image to show up visibly late.
            
            self.setTaskImageView()
            self.setBorderImageView()
   
        }
        self.numberOfTimesViewLaidOutSubviews++

    }
    
    

}
