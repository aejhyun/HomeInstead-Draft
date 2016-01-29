//
//  CathyTaskLogTableViewCell.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 12/24/15.
//  Copyright © 2015 Jae Hyun Kim. All rights reserved.
//

import UIKit

class CathyTaskLogOneTableViewCell: UITableViewCell {

    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageToOfficeTextView: UITextView!
    @IBOutlet weak var pictureMessageTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        //messageButton.hidden = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
