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

    var firstName: String!
    var lastName: String!
    var notes: String!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firstNameLabel.text = self.firstName
        self.lastNameLabel.text = self.lastName
        self.notesLabel.text = self.notes
        if let image = self.image {
            self.imageView.image = image
        } else {
            self.imageView.hidden = true
        }
        
    }

}
