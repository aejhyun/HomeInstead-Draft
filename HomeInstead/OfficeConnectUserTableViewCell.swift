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
    
    var careGiverLabel: UILabel!
    var cathyLabel: UILabel!
    
    func removeConnectedUserNameButtons() {

        for userNameButton in connectedUserNameButtons {
            userNameButton.removeFromSuperview()
        }
    
    }
    
    func createCareGiverLabel() {
        
        self.careGiverLabel = UILabel(frame: CGRectMake(self.width / 9, self.height, 110, 20))
        self.careGiverLabel.font = UIFont(name: "Helvetica", size: 12.0)
        self.careGiverLabel.textAlignment = NSTextAlignment.Center
        self.careGiverLabel.text = "Care Giver(s)"
        self.careGiverLabel.textColor = UIColor.darkGrayColor()
        self.addSubview(self.careGiverLabel)
        
    }
    
    func createCathyLabel() {
        
        self.cathyLabel = UILabel(frame: CGRectMake((self.width * 5) / 9, self.height, 110, 20))
        self.cathyLabel.font = UIFont(name: "Helvetica", size: 12.0)
        self.cathyLabel.textAlignment = NSTextAlignment.Center
        self.cathyLabel.text = "Cathy(s)"
        self.cathyLabel.textColor = UIColor.darkGrayColor()
        self.addSubview(self.cathyLabel)
        
    }
    
    func createConnectedCareGiverNameButtons(careGiverNames: [String]) {
        
        var userNameButtonFrameHeight: CGFloat = self.height + 20

        for var row: Int = 0; row < careGiverNames.count ; row++ {
            
            self.connectedUserNameButton = UIButton(type: UIButtonType.System) as UIButton
            self.connectedUserNameButton.titleLabel?.lineBreakMode = NSLineBreakMode.ByTruncatingTail
            self.connectedUserNameButton.frame = CGRectMake(self.width / 9, userNameButtonFrameHeight, 110, 20)
            self.connectedUserNameButton.setTitle(careGiverNames[row], forState: UIControlState.Normal)
            self.connectedUserNameButton.titleLabel!.font = UIFont(name: "Helvetica", size: 12.0)
            self.connectedUserNameButtons.append(self.connectedUserNameButton)
            self.addSubview(self.connectedUserNameButton)
            
            userNameButtonFrameHeight += 20
        }

    }
    
    func createConnectedCathyNameButtons(cathyNames: [String]) {
        
        var userNameButtonFrameHeight: CGFloat = self.height + 20
        
        for var row: Int = 0; row < cathyNames.count ; row++ {
            
            self.connectedUserNameButton = UIButton(type: UIButtonType.System) as UIButton
            self.connectedUserNameButton.titleLabel?.lineBreakMode = NSLineBreakMode.ByTruncatingTail
            self.connectedUserNameButton.frame = CGRectMake((self.width * 5) / 9, userNameButtonFrameHeight, 110, 20)
            self.connectedUserNameButton.setTitle(cathyNames[row], forState: UIControlState.Normal)
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
