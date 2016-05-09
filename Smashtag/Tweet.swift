//
//  Tweet.swift
//  Smashtag
//
//  Created by Samuel Hinshelwood on 5/9/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import Foundation
import CoreData
import Twitter


class Tweet: NSManagedObject {

    class func tweetWithTwitterInfo(twitterInfo: Twitter.Tweet, inManagedObjectContext context: NSManagedObjectContext) -> Tweet? {
        // look in database for tweet
        let request = NSFetchRequest(entityName: "Tweet")
        request.predicate = NSPredicate(format: "id = %@ ", twitterInfo.id)
        
        if let tweet = (try? context.executeFetchRequest(request))?.first as? Tweet {
            return tweet
        } else if let tweet = NSEntityDescription.insertNewObjectForEntityForName("Tweet", inManagedObjectContext: context) as? Tweet { // create the db tweet
            tweet.id = twitterInfo.id
            tweet.text = twitterInfo.text
            tweet.created = twitterInfo.created
            tweet.tweeter = // create the twitter user
        }
        
        // if it exists, update it
        
        // if not, create it
        
        return nil
    }
    
    override func prepareForDeletion() {
        // don't need to set tweeter to nil, done automatically
        // but could do something, like decrement the tweeters tweetcount: tweeter.tweetCount--
    }

}
