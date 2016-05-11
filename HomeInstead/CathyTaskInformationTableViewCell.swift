//
//  CathyTaskInformationTableViewCell.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 5/11/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class CathyTaskInformationTableViewCell: UITableViewCell {

    @IBOutlet weak var taskImageView: UIImageView!

    @IBOutlet weak var taskDescriptionLabel: UILabel!
    
    @IBOutlet weak var taskCommentLabel: UILabel!
    
    @IBOutlet weak var taskCommentTextView: UITextView!
    
    @IBOutlet weak var timeTaskCompletedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
