//
//  OfficeTaskInformationTableViewCell.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 5/9/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class OfficeTaskInformationFirstRowTableViewCell: UITableViewCell {

    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var startedTimeTextField: UITextField!
    
    @IBOutlet weak var finishedTimeTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var careGiverNameTextField: UITextField!
    
    @IBOutlet weak var clientNameTextField: UITextField!
    
    @IBOutlet weak var careGiverNameLabel: UILabel!
    
    @IBOutlet weak var clientNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
