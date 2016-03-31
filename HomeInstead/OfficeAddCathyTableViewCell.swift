//
//  OfficeAddCathyTableViewCell.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 3/18/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class OfficeAddCathyTableViewCell: UITableViewCell {

    @IBOutlet weak var cathyNameLabel: UILabel!
    @IBOutlet weak var cathyEmailLabel: UILabel!
    @IBOutlet weak var addCathyLabel: UILabel!
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
