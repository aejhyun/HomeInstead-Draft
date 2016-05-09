//
//  OfficeTaskInformationTableViewController.swift
//  HomeInstead
//
//  Created by Jae Hyun Kim on 5/9/16.
//  Copyright © 2016 Jae Hyun Kim. All rights reserved.
//

import UIKit

class OfficeTaskInformationTableViewController: UITableViewController {

    var taskInformationObjectId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 140
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }


    // MARK: - Table view data source
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return 138.0
//        }
//        return 129.0
//    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    func firstRow(indexPath: NSIndexPath) -> OfficeTaskInformationFirstRowTableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellZero", forIndexPath: indexPath) as! OfficeTaskInformationFirstRowTableViewCell
        return cell
    }
    
    func otherRows(indexPath: NSIndexPath) -> OfficeTaskInformationTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellOne", forIndexPath: indexPath) as! OfficeTaskInformationTableViewCell
        cell.setCell()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            return self.firstRow(indexPath)
        } else {
            return self.otherRows(indexPath)
        }
        

    }
    


}
