//
//  TweetInfoTableViewController.swift
//  Smashtag
//
//  Created by Samuel Hinshelwood on 5/4/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import UIKit
import Twitter

class TweetInfoTableViewController: UITableViewController {
    
    var tweet: Twitter.Tweet? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private func setSectionInfo() {
        sectionSizes[TweetTableSection.Images] = tweet?.media.count
        sectionSizes[TweetTableSection.Hashtags] = tweet?.hashtags.count
        sectionSizes[TweetTableSection.Mentions] = tweet?.userMentions.count
        sectionSizes[TweetTableSection.Urls] = tweet?.urls.count
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSectionInfo()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    private enum TweetTableSection : Int {
        case Images = 0
        case Hashtags = 1
        case Mentions = 2
        case Urls = 3
    }
    
    // section type mapped to index nums, associated with their section size
    private var sectionSizes: Dictionary<TweetTableSection, Int> = [TweetTableSection:Int]()
    
    private struct Storyboard {
        static let TweetImageCellIdentifier = "Tweet Image"
        static let TweetHashtagCellIdentifier = "Tweet Hashtag"
        static let TweetMentionCellIdentifier = "Tweet Mention"
        static let TweetUrlCellIdentifier = "Tweet Url"
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionSizes.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionSizes[TweetTableSection(rawValue: section)!]!
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
