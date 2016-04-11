//
//  UserProfileViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 4/11/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var noPhotoLabel: UILabel!
    @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var user: [String: NSObject?] = [String: NSObject?]()
    var image: UIImage?
    
    func setImageView() {
        
        //The reason for self.imageViewHeightLayoutConstraint is because the imageView's correct height only became available in viewWillDidLoad(). But if I put the setImageView() inside viewWillDidLoad(), you can see the imageView circle being drawn.
        self.imageView.layer.masksToBounds = false
        self.imageView.clipsToBounds = true
        self.imageView.layer.cornerRadius = self.imageViewHeightLayoutConstraint.constant / 2
        if let image = self.image {
            self.imageView.image = image
            self.noPhotoLabel.hidden = true
            self.imageView.layer.borderWidth = 0.0
        } else {
            self.imageView.layer.borderWidth = 1.0
            self.imageView.layer.borderColor = UIColor.lightGrayColor().CGColor
            self.noPhotoLabel.textAlignment = .Center
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        print(self.user["pictureFile"])
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setImageView()
    }
}
