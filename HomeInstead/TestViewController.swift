//
//  TestViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 12/24/15.
//  Copyright © 2015 Jae Hyun Kim. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        //self.subView.bounds.width = self.view.bounds.width
       
        
        
        
        
//        self.subView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height + 500))
//        self.scrollView = UIScrollView(frame: self.view.frame)
//        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.width)
//        self.scrollView.contentSize = self.subView.bounds.size
//        self.scrollView.scrollEnabled = true
//        self.scrollView.addSubview(self.subView)
//        self.scrollView.addSubview(self.label)
//        self.view.addSubview(self.scrollView)

        
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        
        
    }
    override func viewDidLayoutSubviews() {
       //self.scrollView.contentSize = self.view.bounds.size
//        self.scrollView.contentSize.width = self.view.bounds.height
//        self.scrollView.contentSize.height = self.view.bounds.height + 300
        
    }
    

   


}
