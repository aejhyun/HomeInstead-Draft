//
//  OfficeTaskInformationTableViewCell.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 5/9/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class OfficeTaskInformationTableViewCell: UITableViewCell {

    @IBOutlet weak var taskImageView: UIImageView!
    
    @IBOutlet weak var borderImageView: UIImageView!
    
    @IBOutlet weak var addPhotoButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var timeTaskCompletedLabel: UITextField!
    
    var numberOfTimesViewLaidOutSubviews: Int = 0
    
    @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    
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
        
        self.addPhotoButton.titleLabel?.textAlignment = .Center
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
            
            self.setTaskImageView()
            self.setBorderImageView()
            
        }
        self.numberOfTimesViewLaidOutSubviews++
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
