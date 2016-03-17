//
//  TextField.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 3/14/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import Foundation

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 5);
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return self.newBounds(bounds)
    }
    
    private func newBounds(bounds: CGRect) -> CGRect {
        print("paisjdpfij")
        var newBounds = bounds
        newBounds.origin.x += padding.left
        newBounds.origin.y += padding.top
        newBounds.size.height -= padding.top + padding.bottom
        newBounds.size.width -= padding.left + padding.right
        return newBounds
    }
}