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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return storedTwitterSearches.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Most Recent Searches", forIndexPath: indexPath)
        
        cell.textLabel?.text = storedTwitterSearches[indexPath.row]

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "Show Recent Search Item" {
                if let recentSearchvc = segue.destinationViewController as? TweetTableViewController {
                    recentSearchvc.searchText = storedTwitterSearches[(tableView.indexPathForSelectedRow?.row)!]
                }
            }
        }
    }

}
