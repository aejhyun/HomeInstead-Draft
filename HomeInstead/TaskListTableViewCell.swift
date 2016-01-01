//
//  TaskListTableViewCell.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 12/21/15.
//  Copyright © 2015 Jae Hyun Kim. All rights reserved.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        sendButton.enabled = false
        messageButton.enabled = false
        activityIndicator.hidden = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
