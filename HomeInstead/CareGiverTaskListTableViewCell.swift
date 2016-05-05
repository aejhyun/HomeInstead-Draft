//
//  CareGiverTaskListTableViewCell.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 5/5/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class CareGiverTaskListTableViewCell: UITableViewCell {

    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
