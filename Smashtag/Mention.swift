//
//  Mention.swift
//  Smashtag
//
//  Created by Samuel Hinshelwood on 5/9/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import Foundation
import CoreData
import Twitter

class Mention: NSManagedObject {
    
    //
    class func tweetWithTwitterInfo(twitterInfo: Twitter.Mention, parentTweet: Tweet,  mentionType: String, inManagedObjectContext context: NSManagedObjectContext) -> Mention? {
        // look in the database for this mention (a mention with this name (i.e. mentionName == #stanford, or mentionName == @Dan)
        let request = NSFetchRequest(entityName: "Mention")
        request.predicate = NSPredicate(format: "mentionName = %@ ", twitterInfo.keyword) // return only mentions with this name (should only be one)
        if let mention = (try? context.executeFetchRequest(request))?.first as? Mention { // found the mention in Core Data
            
            mention.refCount = NSNumber(int: (mention.refCount?.intValue)! + 1) // update refCount for this mention
            return mention // return the mention already existing in Core Data
            
        // create the Core Data mention
        } else if let mention = NSEntityDescription.insertNewObjectForEntityForName("Mention", inManagedObjectContext: context) as? Mention {
            mention.mentionName = twitterInfo.keyword
            mention.mentionType = mentionType
            mention.refCount = 1;
            mention.parentTweets = mention.parentTweets?.setByAddingObject(parentTweet) // add the mention-tweet relationship
            return mention
        }
        return nil
    }

}
