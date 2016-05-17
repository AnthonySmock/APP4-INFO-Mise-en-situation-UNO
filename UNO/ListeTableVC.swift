//
//  ListeTableVC.swift
//  UNO
//
//  Created by user on 16/05/2016.
//  Copyright © 2016 APP4-Info-Polytech. All rights reserved.
//

import Foundation

import UIKit

let TableCellId = "listCell"

class ListeTableVC: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset.top = topInset
        tableView.estimatedRowHeight = estimatedHeight
        //tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(TableCellId, forIndexPath: indexPath) as! TableCell
        
        cell.title = "Table n°1"
        cell.detail = "4/5 personnes"
        cell.mdp = "coucou"
        
        return cell
    }
    
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
