//
//  AddCathyTableViewCell.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 1/12/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class AddCathyTableViewCell: UITableViewCell {

    @IBOutlet weak var cathyNameLabel: UILabel!
    @IBOutlet weak var cathyEmailLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
