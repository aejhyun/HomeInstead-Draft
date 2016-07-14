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
    
    @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    
    var numberOfTimesViewLaidOutSubviews: Int = 0
    
    func setTaskImageView() {
        
        self.taskImageView.image = nil
        self.taskImageView.alpha = 1.0
        self.taskImageView.layer.masksToBounds = false
        self.taskImageView.layer.cornerRadius = self.imageViewHeightLayoutConstraint.constant / 10
        self.taskImageView.clipsToBounds = true
        
        
    }
    
    func setBezierPath() {
        let cGPoint = CGPoint(x: 0.0, y: 0.0)
        let cGSize = CGSize(width: 103.0, height: 97.0)
        let cGRect = CGRect(origin: cGPoint, size: cGSize)
        let bezierPath = UIBezierPath(rect: cGRect)
        self.taskCommentTextView.textContainer.exclusionPaths = [bezierPath]
        self.taskCommentTextView.editable = true
        self.taskCommentTextView.font = UIFont(name: "Helvetica", size: 13)
        self.taskCommentTextView.textColor = UIColor(red: 102/255, green: 153/255, blue: 204/255, alpha: 1.0)
 
        self.taskCommentTextView.editable = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
