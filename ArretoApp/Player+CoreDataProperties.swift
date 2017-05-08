//
//  Player+CoreDataProperties.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 5/7/17.
//  Copyright © 2017 Bearded Gentleman. All rights reserved.
//

import Foundation
import CoreData


extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player")
    }

    @NSManaged public var name: String?
    @NSManaged public var playerBoardInfo: PlayerBoardInfo?
    @NSManaged public var events: NSSet?

}

// MARK: Generated accessors for events
extension Player {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}
