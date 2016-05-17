//
//  ListeTableVC2.swift
//  UNO
//
//  Created by user on 16/05/2016.
//  Copyright © 2016 APP4-Info-Polytech. All rights reserved.
//

import Foundation

import UIKit

let expandingCellId = "expandingCell"
let estimatedHeight: CGFloat = 150
let topInset: CGFloat = 20

class MainViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset.top = topInset
        tableView.estimatedRowHeight = estimatedHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("expandingCell", forIndexPath: indexPath) as! ExpandingCell
        
        cell.title = "cocou"
        cell.detail = "ff"
        
        return cell
    }
    
    // MARK: Table view delegate
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if let selectedIndex = tableView.indexPathForSelectedRow where selectedIndex == indexPath {
            
            tableView.beginUpdates()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            tableView.endUpdates()
            
            return nil
        }
        
        return indexPath
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
