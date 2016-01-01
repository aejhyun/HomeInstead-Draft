//
//  ActivityIndicator.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 12/17/15.
//  Copyright © 2015 Jae Hyun Kim. All rights reserved.
//

import Foundation
import UIKit

class MyActivityIndicator {
    
    let activityIndicator: UIActivityIndicatorView
    
    init() {
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
    }
    
    func startActivityIndicator(view: UIView, x: CGFloat, _ y: CGFloat) {
        //187.5 for x is about the cente.
        activityIndicator.center = CGPointMake(x, y)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    func endActivityIndicator() {
        activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    
}

