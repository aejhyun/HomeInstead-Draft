//
//  OfficeClientProfileViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 3/28/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class OfficeClientProfileViewController: UIViewController {
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var noPhotoLabel: UILabel!
    @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    
    var firstName: String!
    var lastName: String!
    var notes: String!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.firstNameLabel.text = self.firstName
        self.lastNameLabel.text = self.lastName
        self.notesLabel.text = self.notes
        
        self.setImageView()

    }
    
    func setImageView() {
        
        //The reason for self.imageViewHeightLayoutConstraint is because the imageView's correct height only became available in viewWillDidLoad(). But if I put the setImageView() inside viewWillDidLoad(), you can see the imageView circle being drawn.
        self.imageView.layer.masksToBounds = false
        self.imageView.layer.cornerRadius = self.imageViewHeightLayoutConstraint.constant / 2
        self.imageView.clipsToBounds = true
        if let image = self.image {
            self.imageView.image = image
            self.noPhotoLabel.hidden = true
        } else {
            self.imageView.layer.borderWidth = 1.0
            self.imageView.layer.borderColor = UIColor.lightGrayColor().CGColor
            self.noPhotoLabel.textAlignment = .Center
        }
        
    }

}
