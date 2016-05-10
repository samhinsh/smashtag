//
//  SearchDetailTableViewController.swift
//  Smashtag
//
//  Created by Samuel Hinshelwood on 5/9/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class SearchDetailTableViewController: CoreDataTableViewController {
    
    var mentionSearch: String? { didSet { updateUI() } }
    
    private var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    private func updateUI() {
        
        if let mentionSearchTerm = mentionSearch {
            
            let request = NSFetchRequest(entityName: "Mention")
            request.predicate = NSPredicate(format: "mentionName contains[c] %@", mentionSearchTerm)
            request.sortDescriptors = [NSSortDescriptor(key: "refCount", ascending: false)]
            
            fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: managedObjectContext!,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Mentions", forIndexPath: indexPath)
        
        if let mention = fetchedResultsController?.objectAtIndexPath(indexPath) as? Mention {
            var mentionName: String?
            var mentionRefCount: NSNumber?
            mention.managedObjectContext?.performBlockAndWait {
                // it's easy to forget to do this on the proper queue
                mentionName = mention.mentionName
                mentionRefCount = mention.refCount
                // we're not assuming the context is a main queue context
                // so we'll grab the screenName and return to the main queue
                // to do the cell.textLabel?.text setting
            }
            cell.textLabel?.text = mentionName
            if let count = mentionRefCount?.intValue { // tweetCountWithMentionByTwitterUser(mention) {
                cell.detailTextLabel?.text = (count == 1) ? "1 mention" : "\(count) mentions"
            } else {
                cell.detailTextLabel?.text = ""
            }
        }
        
        return cell
    }
    
    // private func which figures out how many mentions
    // correspond to this search
    
//    private func tweetCountWithMentionByTwitterUser(mention: Mention) -> Int?
//    {
//        var count: Int?
//        mention.managedObjectContext?.performBlockAndWait {
//            let request = NSFetchRequest(entityName: "Mention")
//            request.predicate = NSPredicate(format: "text contains[c] %@ and tweeter = %@", self.mention!, user)
//            count = user.managedObjectContext?.countForFetchRequest(request, error: nil)
//        }
//        return count
//    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
}
