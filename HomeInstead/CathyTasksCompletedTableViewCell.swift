//
//  CathyTasksCompletedTableViewCell.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 5/11/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class CathyTasksCompletedTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var startedTimeLabel: UILabel!
    
    @IBOutlet weak var finishedTimeLabel: UILabel!
    
    @IBOutlet weak var careGiverNameButton: UIButton!
    
    @IBOutlet weak var clientNameButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
