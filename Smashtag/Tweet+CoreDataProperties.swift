//
//  Tweet+CoreDataProperties.swift
//  Smashtag
//
//  Created by Samuel Hinshelwood on 5/9/16.
//  Copyright © 2016 Samuel Hinshelwood. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tweet {

    @NSManaged var created: NSDate?
    @NSManaged var id: String?
    @NSManaged var text: String?
    @NSManaged var tweeter: TwitterUser?
    @NSManaged var mentions: NSSet?

}
