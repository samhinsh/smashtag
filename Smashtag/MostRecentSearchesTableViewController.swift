//
//  MostRecentSearchesTableViewController.swift
//  Smashtag
//
//  Created by Samuel Hinshelwood on 5/9/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import UIKit

class MostRecentSearchesTableViewController: UITableViewController {
    
    
    private struct Storyboard {
        static let MostRecentCellIdentifier = "Most Recent Searches"
        static let ShowRecentSearchSegue = "Show Recent Search Item"
        static let SearchDetailSegue = "Show Search Detail"
    }
    
    private var storedTwitterSearches : [String] {
        return (NSUserDefaults.standardUserDefaults().arrayForKey("storedSearches") as? [String]) ?? [String]()
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        performSegueWithIdentifier(Storyboard.SearchDetailSegue, sender: self)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return storedTwitterSearches.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.MostRecentCellIdentifier, forIndexPath: indexPath)
        
        cell.textLabel?.text = storedTwitterSearches[indexPath.row]
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.ShowRecentSearchSegue:
                if let recentSearchvc = segue.destinationViewController as? TweetTableViewController {
                    recentSearchvc.searchText = storedTwitterSearches[(tableView.indexPathForSelectedRow?.row)!]
                }
            case Storyboard.SearchDetailSegue:
                if let searchDetailvc = segue.destinationViewController as? SearchDetailTableViewController {
                    searchDetailvc.mentionSearch = storedTwitterSearches[(tableView.indexPathForSelectedRow?.row)! ] // prepare search detail segue
                }
            default: break
            }
            
        }
    }
    
}
