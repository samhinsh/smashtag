//
//  Mention.swift
//  Smashtag
//
//  Created by Samuel Hinshelwood on 5/9/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import Foundation
import CoreData


class Mention: NSManagedObject {
    
    /*
    class func tweetWithTwitterInfo(twitterInfo: Twitter.Tweet, inManagedObjectContext context: NSManagedObjectContext) -> Tweet? {
        // look in database for tweet
        let request = NSFetchRequest(entityName: "Tweet")
        request.predicate = NSPredicate(format: "id = %@ ", twitterInfo.id)
        if let tweet = (try? context.executeFetchRequest(request))?.first as? Tweet {
            return tweet // return the tweet already existing in Core Data
            
        } else if let tweet = NSEntityDescription.insertNewObjectForEntityForName("Tweet", inManagedObjectContext: context) as? Tweet { // create the db tweet
            tweet.id = twitterInfo.id
            tweet.text = twitterInfo.text
            tweet.created = twitterInfo.created
            tweet.tweeter = TwitterUser.twitterUserWithTwitterInfo(twitterInfo.user, inManagedObjectContext: context) // create or return the twitter user from Core Data
            return tweet
        }
        return nil
    }*/

}
