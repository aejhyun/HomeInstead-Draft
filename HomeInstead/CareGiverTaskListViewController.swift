//
//  CareGiverTaskListViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 5/5/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit
import Parse

class CareGiverTaskListViewController: UIViewController, UIBarPositioningDelegate, UITableViewDelegate, UITableViewDataSource {

    var navigationBarLine: UIView = UIView()
    @IBOutlet weak var barButtonItem: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    func removeBottomLineFromNavigationBar() {
        
        for parent in self.navigationController!.navigationBar.subviews {
            for childView in parent.subviews {
                if childView is UIImageView && childView.bounds.size.width == self.navigationController!.navigationBar.frame.size.width {
                    self.navigationBarLine = childView
                }
            }
        }
        
    }
    
    func setSegmentedControlWidth() {
        
        let viewWidth: CGFloat = self.view.frame.width
        self.barButtonItem.width = viewWidth - 40.0
    
    }
    
    func setToolbar() {
        
        self.toolbar.layer.borderWidth = 1.0
        self.toolbar.clipsToBounds = true
        self.toolbar.layer.borderColor = UIColor(red: 163.0/255.0, green: 163.0/255.0, blue: 163.0/255.0, alpha: 1.0).CGColor
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSegmentedControlWidth()
        self.setToolbar()
        self.navigationItem.title = "Task List"
        self.removeBottomLineFromNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationBarLine.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        self.navigationBarLine.hidden = false
        
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CareGiverTaskListTableViewCell
        cell.taskNameLabel.text = "dawg"
        return cell
    }


}

    
    


