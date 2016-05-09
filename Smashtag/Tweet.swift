//
//  Tweet.swift
//  Smashtag
//
//  Created by Samuel Hinshelwood on 5/9/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//

import Foundation
import CoreData


class Tweet: NSManagedObject {

    override func prepareForDeletion() {
        // don't need to set tweeter to nil, done automatically
        // but could do something, like decrement the tweeters tweetcount: tweeter.tweetCount--
    }

}
