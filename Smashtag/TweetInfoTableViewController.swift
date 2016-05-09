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
    
    private func setSectionSizes() {
        sectionSizes[TweetTableSection.Images] = tweet?.media.count
        sectionSizes[TweetTableSection.Hashtags] = tweet?.hashtags.count
        sectionSizes[TweetTableSection.Mentions] = tweet?.userMentions.count
        sectionSizes[TweetTableSection.Urls] = tweet?.urls.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        
        setSectionSizes()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        if let selectedRow = tableView.indexPathForSelectedRow { // deselect selected row
            tableView.deselectRowAtIndexPath(selectedRow, animated: true)
        }
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
    
    private var sectionTitles: Dictionary<TweetTableSection, String> = [
        .Images : "Images",
        .Hashtags : "Hashtags",
        .Mentions : "Mentions",
        .Urls : "Urls"
    ]
    
    // table section types ampped to their respective sizes
    private var sectionSizes: Dictionary<TweetTableSection, Int> = [TweetTableSection:Int]()
    
    private struct Storyboard {
        static let TweetImageCellIdentifier = "Tweet Image"
        static let TweetHashtagCellIdentifier = "Tweet Hashtag"
        static let TweetMentionCellIdentifier = "Tweet Mention"
        static let TweetUrlCellIdentifier = "Tweet Url"
        static let TweetUserSearchIdentifier = "Show User Search"
        static let TweetHashtagSearchIdentifier = "Show Hashtag Search"
        static let TweetImageViewIdentifier = "Show Full Image"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionSizes.count
    }
    
    // hide section header on empty section
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sectionSizes[ TweetTableSection(rawValue: section)! ] > 0 {
            return sectionTitles[ TweetTableSection(rawValue: section)! ]
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionSizes[ TweetTableSection(rawValue: section)! ]!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if let ratio = tweet?.media[indexPath.row].aspectRatio {
                return CGFloat(view.frame.width / CGFloat(ratio))
            }
        }
        
        return UITableViewAutomaticDimension
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if TweetTableSection(rawValue: indexPath.section) == .Urls {
            let tweetUrl = NSURL(string: (tweet?.urls[indexPath.row].keyword)!)
            if let url = tweetUrl {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let tableSection = TweetTableSection(rawValue: indexPath.section) {
            
            switch tableSection {
            case .Images:
                if let tweetImageCell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TweetImageCellIdentifier, forIndexPath: indexPath) as? TweetImageTableViewCell {
                    
                    if let tweetImageUrl = tweet?.media[indexPath.row].url {
                        if let imageData = NSData(contentsOfURL: tweetImageUrl) {
                            tweetImageCell.tweetImageView.image = UIImage(data: imageData)
                            return tweetImageCell
                        }
                    }
                }
                
            case .Hashtags:
                let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TweetHashtagCellIdentifier, forIndexPath: indexPath)
                cell.textLabel?.text = tweet?.hashtags[indexPath.row].keyword
                return cell
                
            case .Mentions:
                let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TweetMentionCellIdentifier, forIndexPath: indexPath)
                cell.textLabel?.text = tweet?.userMentions[indexPath.row].keyword
                return cell
                
            case .Urls:
                let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TweetUrlCellIdentifier, forIndexPath: indexPath)
                cell.textLabel?.text = tweet?.urls[indexPath.row].keyword
                return cell
            }
        }
        
        let cell = UITableViewCell()
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationvc = segue.destinationViewController as? TweetTableViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case Storyboard.TweetHashtagSearchIdentifier:
                    destinationvc.searchText = tweet?.hashtags[(tableView.indexPathForSelectedRow?.row)!].keyword
                case Storyboard.TweetUserSearchIdentifier:
                    destinationvc.searchText = tweet?.userMentions[(tableView.indexPathForSelectedRow?.row)!].keyword
                default: break
                }
            }
        } else if let destinationvc = segue.destinationViewController as? ImageViewController {
            if segue.identifier == Storyboard.TweetImageViewIdentifier {
                destinationvc.imageURL = tweet?.media[(tableView.indexPathForSelectedRow?.row)!].url
            }
        }
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
