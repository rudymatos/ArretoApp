//
//  Board+CoreDataProperties.swift
//  ArretoApp
//
//  Created by Rudy E Matos on 5/7/17.
//  Copyright © 2017 Bearded Gentleman. All rights reserved.
//

import Foundation
import CoreData


extension Board {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Board> {
        return NSFetchRequest<Board>(entityName: "Board")
    }

    @NSManaged public var active: Bool
    @NSManaged public var createdOn: NSDate?
    @NSManaged public var firebaseId: String?
    @NSManaged public var key: String?
    @NSManaged public var published: Bool
    @NSManaged public var type: String?
    @NSManaged public var playerBoardInfo: NSSet?
    @NSManaged public var events: NSSet?
    @NSManaged public var league: League?

}

// MARK: Generated accessors for playerBoardInfo
extension Board {

    @objc(addPlayerBoardInfoObject:)
    @NSManaged public func addToPlayerBoardInfo(_ value: PlayerBoardInfo)

    @objc(removePlayerBoardInfoObject:)
    @NSManaged public func removeFromPlayerBoardInfo(_ value: PlayerBoardInfo)

    @objc(addPlayerBoardInfo:)
    @NSManaged public func addToPlayerBoardInfo(_ values: NSSet)

    @objc(removePlayerBoardInfo:)
    @NSManaged public func removeFromPlayerBoardInfo(_ values: NSSet)

}

// MARK: Generated accessors for events
extension Board {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}
