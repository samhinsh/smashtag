//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Samuel Hinshelwood on 5/4/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    private var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    private var tweets = [Array<Twitter.Tweet>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var defaults = NSUserDefaults.standardUserDefaults()
    
    private var maxStoredSearches = 100
    
    private var searches : AnyObject {
        get {
            return (defaults.arrayForKey("storedSearches") as? [String]) ?? [String]()
        }
        set {
            if let searchStringToAppend = newValue as? String {
                var updatedStoredSearches: [String] = (searches as? [String]) ?? [String]()
                guard !updatedStoredSearches.contains(searchStringToAppend) else { return }
                if(updatedStoredSearches.count >= maxStoredSearches) {
                   updatedStoredSearches.removeAtIndex(updatedStoredSearches.count - 1) // pop-front if at max searches
                }
                updatedStoredSearches.insert(searchStringToAppend, atIndex: 0)
                defaults.setObject(updatedStoredSearches, forKey: "storedSearches")
            }
        }
    }
    
    private func clearDefaults(userDefaults: NSUserDefaults) {
        userDefaults.removeObjectForKey("storedSearches")
    }
    
    var searchText: String? {
        didSet {
            tweets.removeAll()
            lastTwitterRequest = nil
            searchForTweets()
            title = searchText
            if let searchToStore = searchText {
                searches = searchToStore // add to stored searches
            }
            print("Stored searches: \(searches)")
        }
    }
    
    // give the request for the current searchText
    private var twitterRequest: Twitter.Request? {
        if lastTwitterRequest == nil { // new batch if no search done
            if let query = searchText where !query.isEmpty { // if not nil and not empty (don't want empty twitter search)
                return Twitter.Request(search: query + " -filter:retweets", count: 100)
            }
        }
        return lastTwitterRequest?.requestForNewer // get new tweets from old search
    }
    
    private var lastTwitterRequest: Twitter.Request?
    
    private func searchForTweets()
    {
        if let request = twitterRequest {
            lastTwitterRequest = request
            // use the request
            // '[weak weakSelf = self]' => asynchrony memory cycle fix
            request.fetchTweets { [weak weakSelf = self] newTweets in // tweets from the request will be stored in newTweets
                // this callback will do something with the newTweets passed in
                // run this trailing closure on the main thread
                dispatch_async(dispatch_get_main_queue()) { // trailing closure, fn to be used on the main thread
                    // when multithreading, if user has done new search, check for it, and only finish adding new tweets if they haven't issued a new search
                    if request == weakSelf?.lastTwitterRequest { // => asynchrony return state fix (awareness of what changed since request)
                        if !newTweets.isEmpty {
                            // use weakSelf to allow self to leave the heap if navigated away from while this thread is happening
                            // as opposed to a strong pointer which would keep self in the heap even if user left the screen
                            weakSelf?.tweets.insert(newTweets, atIndex: 0) // add new tweets to beginning of table
                            // more: if newTeets comes back and self has left the heap, this will just be ignored
                            weakSelf?.updateDatabase(newTweets)
                        }
                    }
                    weakSelf?.refreshControl?.endRefreshing()
                }
            }
        } else {
            self.refreshControl?.endRefreshing()
        }
    }
    
    private func updateDatabase(newTweets: [Twitter.Tweet]) {
        managedObjectContext?.performBlock {
            for twitterInfo in newTweets {
                // the _ = just lets readers of our code know
                // that we are intentionally ignoring the return value
                _ = Tweet.tweetWithTwitterInfo(twitterInfo, inManagedObjectContext: self.managedObjectContext!)
            }
            // there is a method in AppDelegate
            // which will save the context as well
            // but we're just showing how to save and catch any error here
            do {
                try self.managedObjectContext?.save()
            } catch let error {
                print("Core Data Error: \(error)")
            }
        }
        printDatabaseStatistics()
        // note that even though we do this print()
        // AFTER printDatabaseStatistics() is called
        // it will print BEFORE because printDatabaseStatistics()
        // returns immediately after putting a closure on the context's queue
        // (that closure then runs sometime later, after this print())
        print("done printing database statistics")
    }
    
    private func printDatabaseStatistics() {
        managedObjectContext?.performBlock {
            let twitterUserCount = self.managedObjectContext!.countForFetchRequest(NSFetchRequest(entityName: "TwitterUser"), error: nil)
            print("\(twitterUserCount) TwitterUsers")
            
            let tweetCount = self.managedObjectContext!.countForFetchRequest(NSFetchRequest(entityName: "Tweet"), error: nil)
            print("\(tweetCount) Tweets") // efficient way to count objects
        }
    }
    
    // table refresh control
    @IBAction func refresh(sender: UIRefreshControl) {
        searchForTweets()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // clearDefaults(defaults)
        
        // set row heights to be dynamic
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // for interacting with Model.xcdatamodeld
        //        var manageObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        
        // Mark: - Database Functions
        //        do {
        //            try context.save(
        //        )
        //        } catch let error {
        //            throw error // must say that func throws if used
        //        }
        
        //        if let tweet = NSEntityDescription.insertNewObjectForEntityForName("Tweet", isManagedObjectContext: context) as? Tweet {
        //            tweet.text =
        //            tweet.created =
        //            tweet.tweeter =
        //            tweet.tweeter.name =
        //        }
        
        //        context.deleteObject(tweet) // make sure no strong pointers to tweet after deletion, delete set by delete rule in attributes editor
        
        // Querying: retreiving objects from a database
        // Done with Core Data by making NSFetchRequest in NSManagedObjectContext
        // 1) Only fetch ONE thing (i.e. tweet or twitterUser)
        // 2) Define how many, or maximmum number to get
        // 3) Use NSSortDescriptors list to specify the order in the array of which fetched objects are returned
        // 4) Use NSPredicate to specify which of those Entities to fetch (i.e. tweets created since yesterday)
        // You'd use an array of sort descriptors to sort first by one method, then by another within that same sort
        
        //        let sortDescriptor = NSSortDescriptor(
        //            key: "text" /*or "created" to sort by that attribute name */, ascending: <#T##Bool#>, selector: "localizedStandardCompate:" /* for user-interested alphabetically order; i.e. sorting like the Finder */
        //        )
        
        //        let users = try? context.executeFetchRequest(request)
        // try? will execute and if error thrown, return nil
        // otherwise returns empty array (not nil) on no matches in database
        // or returns Array of NSManagedObjects
        
        // NSManagedObjectContext is not thread-safe
        // thread-safety is done by having each NSManagedObjectContext live on its own queue
        // Thread-safe access to NSMO:
        // contex.performBlock {} // or performBlockAndWait, should be done for all calls to NSMO, even in non-multithreaded (costs no resources)
        
        // NSFetchedResultsController to UITableViewController
        //        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //            let cell = tableView.dequeue_
        //
        //            let object = fetchedResultsController.objectAtIndexPath(indexPath) as? Tweet {
        //                // load the cell based on properties of the obj
        //            }
        //
        //            return // the cell
        //        }
        //
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(tweets.count - section)"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    
    private struct Storyboard {
        static let TweetCellIdentifier = "Tweet"
        static let TweetInfoSegue = "Show TweetInfo"
        static let SearchDetailSegue = "Show Search Detail"
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        performSegueWithIdentifier(Storyboard.SearchDetailSegue, sender: self)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TweetCellIdentifier, forIndexPath: indexPath)
        
        let tweet = tweets[indexPath.section][indexPath.row]
        
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet // working with didSet + updateUI in the cell's class
            return tweetCell
        } else {
            cell.textLabel?.text = "@" + tweet.user.screenName
            cell.detailTextLabel?.text = tweet.text
        }
        
        return cell
    }
    
    // search text field
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    // default behavior of text field on return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder() // hide keyboard
        searchText = textField.text // do the search (working with didSet)
        return true // perform default behavior
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let tweetInfoVC = segue.destinationViewController as? TweetInfoTableViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case Storyboard.TweetInfoSegue:
                    tweetInfoVC.tweet =
                        tweets[tableView.indexPathForSelectedRow!.section][tableView.indexPathForSelectedRow!.row]
                    
                default: break
                }
            }
        } else if let searchDetailvc = segue.destinationViewController as? SearchDetailTableViewController {
            if let identifier = segue.identifier {
                if identifier == Storyboard.SearchDetailSegue {
                    // TODO prepare search detail segue
                }
            }
        }
    }
    
}
