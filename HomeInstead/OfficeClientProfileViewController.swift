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
    
    var firstName: String!
    var lastName: String!
    var notes: String!
    var image: UIImage!
    var numberOfTimesViewLaidOutSubviews: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
//        self.firstNameLabel.text = self.firstName
//        self.lastNameLabel.text = self.lastName
//        self.notesLabel.text = self.notes
//        if let image = self.image {
//            self.imageView.image = image
//        } else {
//            self.imageView.hidden = true
//        }
        
    }
    
    override func viewDidLayoutSubviews() {
//
//        self.imageView.layer.masksToBounds = false
//        self.imageView.layer.cornerRadius = self.imageView.frame.height / 2
//        self.imageView.clipsToBounds = true

    }

}
