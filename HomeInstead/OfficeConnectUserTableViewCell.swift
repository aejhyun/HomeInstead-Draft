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
    
    var spaceBetweenCathys: CGFloat = 0.0
    var spaceBetweenUserLabelsAndUsers: CGFloat = 0.0
    var spaceBetweenCathyGroups: CGFloat = 0.0
    
    var nameButtonHeight: CGFloat = 20.0
    var nameButtonWidth: CGFloat = 110.0
    
    var userLabelHeight: CGFloat = 20.0
    var userLabelWidth: CGFloat = 110.0
    
    var leftSideSpaceForUsersAndUserLabel: CGFloat = 40.0
    var rightSideSpaceForUsersAndUserLabel: CGFloat = 0.0
    
    var clientNameButton: UIButton!
    var nameButtons: [UIButton] = [UIButton]()
    
    var careGiverNameButton: UIButton!
    
    var userTypeLabels: [UILabel] = [UILabel]()
    
    var clientLabel: UILabel = UILabel()
    var cathyLabel: UILabel = UILabel()
    
    var userObjectIdsAndNames: [String: String] = [String: String]()
    
    func removeUserTypeLabels() {
        for userTypeLabel in self.userTypeLabels {
            userTypeLabel.removeFromSuperview()
        }
        self.userTypeLabels.removeAll()
    }
    
    func removeNameButtons() {

        for nameButton in self.nameButtons {
            nameButton.removeFromSuperview()
        }
        self.nameButtons.removeAll()
    }
    
    func calculateRightSideSpace() -> CGFloat{
        let space = self.width - self.leftSideSpaceForUsersAndUserLabel * 3.75
        return space
    }
    
    func createClientLabel() {
        
        self.clientLabel = UILabel(frame: CGRectMake(self.leftSideSpaceForUsersAndUserLabel, self.height, self.userLabelWidth, self.userLabelHeight))
        self.clientLabel.font = UIFont(name: "Helvetica", size: 12.0)
        self.clientLabel.textAlignment = NSTextAlignment.Center
        self.clientLabel.text = "Client(s)"
        self.clientLabel.textColor = UIColor.darkGrayColor()
        self.userTypeLabels.append(self.clientLabel)
        self.addSubview(self.clientLabel)
        
    }
    
    func createCathyLabel() {
        
        self.rightSideSpaceForUsersAndUserLabel = self.calculateRightSideSpace()
        self.cathyLabel = UILabel(frame: CGRectMake(self.rightSideSpaceForUsersAndUserLabel, self.height, self.userLabelWidth, self.userLabelHeight))
        self.cathyLabel.font = UIFont(name: "Helvetica", size: 12.0)
        self.cathyLabel.textAlignment = NSTextAlignment.Center
        self.cathyLabel.text = "Cathy(s)"
        self.cathyLabel.textColor = UIColor.darkGrayColor()
        self.userTypeLabels.append(self.cathyLabel)
        self.addSubview(self.cathyLabel)
        
    }
    
    
    
    func createNameButtons(connectedObjectIds: Dictionary<String, [String]>) {
        
        var clientNameButtonFrameHeight: CGFloat = self.height + self.spaceBetweenUserLabelsAndUsers
        var careGiverNameButtonFrameHeight: CGFloat = self.height + self.spaceBetweenUserLabelsAndUsers
        
        var numberOfCathys: Int = 0
        
        for (clientObjectId, _) in connectedObjectIds {
       
            self.clientNameButton = UIButton(type: UIButtonType.System) as UIButton
            self.clientNameButton.titleLabel?.lineBreakMode = NSLineBreakMode.ByTruncatingTail
            self.clientNameButton.frame = CGRectMake(self.leftSideSpaceForUsersAndUserLabel, clientNameButtonFrameHeight, self.nameButtonWidth, self.nameButtonHeight)
            self.clientNameButton.setTitle(self.userObjectIdsAndNames[clientObjectId], forState: UIControlState.Normal)
            self.clientNameButton.titleLabel!.font = UIFont(name: "Helvetica", size: 12.0)
            self.nameButtons.append(self.clientNameButton)
            self.addSubview(self.clientNameButton)

            numberOfCathys = connectedObjectIds[clientObjectId]!.count
            clientNameButtonFrameHeight += CGFloat(numberOfCathys) * (self.spaceBetweenCathys) + self.spaceBetweenCathyGroups
            
            for cathyObjectId in connectedObjectIds[clientObjectId]! {
                self.careGiverNameButton = UIButton(type: UIButtonType.System) as UIButton
                self.careGiverNameButton.titleLabel?.lineBreakMode = NSLineBreakMode.ByTruncatingTail
                self.careGiverNameButton.frame = CGRectMake(self.rightSideSpaceForUsersAndUserLabel, careGiverNameButtonFrameHeight, self.nameButtonWidth, self.nameButtonHeight)
                self.careGiverNameButton.setTitle(self.userObjectIdsAndNames[cathyObjectId], forState: UIControlState.Normal)
                self.careGiverNameButton.titleLabel!.font = UIFont(name: "Helvetica", size: 12.0)
                self.nameButtons.append(self.careGiverNameButton)
                self.addSubview(self.careGiverNameButton)
                careGiverNameButtonFrameHeight += self.spaceBetweenCathys
            }
            careGiverNameButtonFrameHeight += self.spaceBetweenCathyGroups
            
        }
        
        
        
        
        
        
        
//            newRowHeight = originalRowHeights[row] + self.spaceBetweenUserLabelsAndUsersInExpandedCell + (CGFloat(numberOfClients) * self.spaceBetweenCathyGroupsInExpandedCell) + (CGFloat(numberOfCathys) * self.spaceBetweenCathysInExpandedCell)
//            expandedRowHeights.append(newRowHeight)
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
//    func createConnectedCareGiverNameButtons(careGiverNames: [String]) {
//        
//        var userNameButtonFrameHeight: CGFloat = self.height + self.spaceBetweenUserLabelsAndUsers
//
//        for var row: Int = 0; row < careGiverNames.count ; row++ {
//            
//            self.connectedUserNameButton = UIButton(type: UIButtonType.System) as UIButton
//            self.connectedUserNameButton.titleLabel?.lineBreakMode = NSLineBreakMode.ByTruncatingTail
//            self.connectedUserNameButton.frame = CGRectMake(self.leftSideSpaceForUsersAndUserLabel, userNameButtonFrameHeight, 110, 20)
//            self.connectedUserNameButton.setTitle(careGiverNames[row], forState: UIControlState.Normal)
//            self.connectedUserNameButton.titleLabel!.font = UIFont(name: "Helvetica", size: 12.0)
//            self.connectedUserNameButtons.append(self.connectedUserNameButton)
//            self.addSubview(self.connectedUserNameButton)
//
//            userNameButtonFrameHeight += self.spaceBetweenUsers
//        }
//
//    }
//    
//    func createConnectedCathyNameButtons(cathyNames: [String]) {
//        
//        self.rightSideSpaceForUsersAndUserLabel = self.calculateRightSideSpace()
//        var userNameButtonFrameHeight: CGFloat = self.height + self.spaceBetweenUserLabelsAndUsers
//        
//        for var row: Int = 0; row < cathyNames.count ; row++ {
//            
//            self.connectedUserNameButton = UIButton(type: UIButtonType.System) as UIButton
//            self.connectedUserNameButton.titleLabel?.lineBreakMode = NSLineBreakMode.ByTruncatingTail
//            self.connectedUserNameButton.frame = CGRectMake((self.rightSideSpaceForUsersAndUserLabel), userNameButtonFrameHeight, 110, 20)
//            self.connectedUserNameButton.setTitle(cathyNames[row], forState: UIControlState.Normal)
//            self.connectedUserNameButton.titleLabel!.font = UIFont(name: "Helvetica", size: 12.0)
//            self.connectedUserNameButtons.append(self.connectedUserNameButton)
//            self.addSubview(self.connectedUserNameButton)
//            
//            userNameButtonFrameHeight += self.spaceBetweenUsers
//        }
//        
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
