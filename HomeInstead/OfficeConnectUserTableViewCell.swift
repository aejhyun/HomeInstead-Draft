//
//  OfficeConnectUserTableViewCell.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 4/20/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class OfficeConnectUserTableViewCell: UITableViewCell {

    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var notesTopSpaceLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var expandButton: UIButton!
    
    var height: CGFloat = 0.0
    var width: CGFloat = 0.0
    
    var connectedUserNameButton: UIButton!
    var connectedUserNameButtons: [UIButton] = [UIButton]()
    
    func removeConnectedUserNameButtons() {

        for userNameButton in connectedUserNameButtons {
            userNameButton.removeFromSuperview()
        }
    
    }
    
    func createConnectedUserNameButtons(userNames: [String]) {
        
        var userNameButtonFrameHeight: CGFloat = self.height

        for var row: Int = 0; row < userNames.count ; row++ {
            
            self.connectedUserNameButton = UIButton(type: UIButtonType.System) as UIButton
            self.connectedUserNameButton.frame = CGRectMake(self.width / 8, userNameButtonFrameHeight, 110, 20)
            self.connectedUserNameButton.setTitle(userNames[row], forState: UIControlState.Normal)
            self.connectedUserNameButton.titleLabel!.font = UIFont(name: "Helvetica", size: 12.0)
            self.connectedUserNameButtons.append(self.connectedUserNameButton)
            self.addSubview(self.connectedUserNameButton)
            
            userNameButtonFrameHeight += 20
        }
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
